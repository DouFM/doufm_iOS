//
//  DouFMContentViewController.m
//  DouFm
//
//  Created by jackie on 14-4-28.
//  Copyright (c) 2014年 jackie. All rights reserved.
//

#import "DouFMContentViewController.h"
#import "DOUAudioStreamer.h"
#import "DOUAudioVisualizer.h"
#import "SongItem.h"
#import "AppDelegate.h"
#import "RCApplication.h"
#import "UIImageView+WebCache.h"
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>
#import "Reachability.h"
#import "DouFMLeftViewController.h"
#import "RESideMenu.h"

extern NSString *remoteControlPlayButtonTapped;
extern NSString *remoteControlPauseButtonTapped;
extern NSString *remoteControlStopButtonTapped;
extern NSString *remoteControlForwardButtonTapped;
extern NSString *remoteControlBackwardButtonTapped;
extern NSString *remoteControlOtherButtonTapped;
extern NSString *remoteControlTogglePlayPause;

static void *kStatusKVOKey = &kStatusKVOKey;
static void *kDurationKVOKey = &kDurationKVOKey;
static void *kMusicKVOKey = &kMusicKVOKey;

@interface DouFMContentViewController()

@property (strong, nonatomic) DOUAudioStreamer *streamPlayer;
@property (assign, nonatomic) NSUInteger currentTrackIndex;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation DouFMContentViewController

- (void)_fetchSongItems
{
    [AppDelegate.engine fetchSongItemsFrom:_currentIndex
                                     toEnd:_currentIndex + 10
                                OnSucceded:^(NSMutableArray *listOfModelBaseObjects)
     {
         DLog(@"fetch %@", listOfModelBaseObjects);
         self.tracks = nil;
         _tracks = [listOfModelBaseObjects copy];
         [self _resetStreamer];
         
     }
                                   onError:^(NSError *engineError)
     {
         DLog(@"error %@", engineError);
         
     }];
    
}
- (void)_cancelStreamer
{
    
    if (self.streamPlayer) {
        [_streamPlayer pause];
        [_streamPlayer removeObserver:self forKeyPath:@"status"];
        [_streamPlayer removeObserver:self forKeyPath:@"duration"];
        self.streamPlayer = nil;
    }
}

- (void)_resetStreamer
{
    [self _cancelStreamer];
    
    if (0 == [_tracks count])
    {
        DLog(@"no stream track available");
    }
    else
    {
 
        SongItem *track = [_tracks objectAtIndex:_currentTrackIndex];
        DLog(@"track url %@", track.title);
        DLog(@"track url %@", track.audioFileURL);
        
        if (track.audioFileURL != nil)
        {
            _musicTitle.text = track.title;
            
            self.streamPlayer = [DOUAudioStreamer streamerWithAudioFile:track];
            [_streamPlayer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:kStatusKVOKey];
            [_streamPlayer addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:kDurationKVOKey];
            _streamPlayer.volume = 1.0;
            
            [_streamPlayer play];
            //设置下一个要播放的音乐
            [self _setupHintForStreamer];
            //设置音乐台控制信息
            if ([MPNowPlayingInfoCenter class])
            {
                
                //[MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = nil;
                NSMutableDictionary *songInfo = [[NSMutableDictionary alloc]init];
                [songInfo setObject:track.title forKey:MPMediaItemPropertyTitle];
                [songInfo setObject:track.artist forKey:MPMediaItemPropertyArtist];
                [songInfo setObject:track.album forKey:MPMediaItemPropertyAlbumTitle];
                [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
                
                //异步加载album
                NSURL *albumArtURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@", kBaseURL, track.cover]];
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                [manager downloadWithURL:albumArtURL
                                 options:0
                                progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                    
                                }
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                   
                                   if (image && finished)
                                   {
                                       MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc]initWithImage:image];
                                       [songInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork];
                                       [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
                                   }
                               
                 }];
            }
        }
    }
}

- (void)_setupHintForStreamer
{
    //当播放到列表最后一个时，要向下加载十条数据，同时index指向0
    NSUInteger nextIndex = _currentTrackIndex + 1;
    if (nextIndex >= [_tracks count])
    {
        _currentIndex += 10;
        [self _fetchSongItems];
        _currentTrackIndex = 0;
        nextIndex = _currentTrackIndex;
    }
    
    [DOUAudioStreamer setHintWithAudioFile:[_tracks objectAtIndex:nextIndex]];
}

- (void)_timerAction:(id)timer
{
   
    _leftTime.text = [NSString stringWithFormat:@"%d:%02d", (int)(_streamPlayer.duration - _streamPlayer.currentTime) / 60, (int)(_streamPlayer.duration - _streamPlayer.currentTime)  % 60];
    
}

- (void)_updateStatus
{
    switch ([_streamPlayer status])
    {
        case DOUAudioStreamerPlaying:
            [_playButton setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
            break;
        case DOUAudioStreamerPaused:
            [_playButton setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
            break;
        case DOUAudioStreamerBuffering:
            self.title = @"正在缓冲...";
            break;
        case DOUAudioStreamerFinished:
            [self next:nil];
            break;
        case DOUAudioStreamerIdle:
            self.title = @"空闲中...";
            break;
        case  DOUAudioStreamerError:
            DLog(@"error happend");
            self.title = @"出错了...";
            break;
        default:
            break;
    }
}

/*
 * KVO
 */
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (context == kStatusKVOKey)
    {
        [self performSelectorOnMainThread:@selector(_updateStatus)
                               withObject:nil
                            waitUntilDone:NO];
    }
    else if (context == kDurationKVOKey)
    {
        [self performSelectorOnMainThread:@selector(_timerAction:) withObject:nil waitUntilDone:NO];

    }
    else if (context == kMusicKVOKey)
    {
        [self performSelectorOnMainThread:@selector(_changeMusicType) withObject:nil waitUntilDone:NO];
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)_changeMusicType
{
    //默认音乐类型改变，就要重新加载新类型歌曲
    _currentIndex = 0;
    _currentTrackIndex = 0;
    self.tracks = nil;
    [self _fetchSongItems];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 注册监听事件通知的代码
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:remoteControlPlayButtonTapped object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:remoteControlPauseButtonTapped object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:remoteControlStopButtonTapped object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:remoteControlForwardButtonTapped object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:remoteControlBackwardButtonTapped object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:remoteControlOtherButtonTapped object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:remoteControlTogglePlayPause object:nil];
    
    //注册监听左侧音乐类型的observer
    DouFMLeftViewController *leftViewController = (DouFMLeftViewController *)self.sideMenuViewController.leftMenuViewController;
    if (leftViewController)
    {
        [leftViewController addObserver:self
                             forKeyPath:@"musicType"
                                options:NSKeyValueObservingOptionNew
                                context:kMusicKVOKey];
    }
  
    
    Reachability  *_reachability = [Reachability reachabilityWithHostname:kBaseURL];
    
    _reachability.reachableBlock = ^(Reachability *reach)
    {
        //如果当前网络是通过校园网无线连接
        if ([reach isReachableViaWiFi])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([_tracks count] == 0)
                {
                    [self _fetchSongItems];
                }
            });
        }
        else
        {
            [_streamPlayer pause];
            [_playButton setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
            [[SDWebImageManager sharedManager] cancelAll];
            
        }
    };
    
    _reachability.unreachableBlock = ^(Reachability *reach)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_streamPlayer pause];
            [_playButton setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
            [[SDWebImageManager sharedManager] cancelAll];
            
        });
    };
    
    [_reachability startNotifier];
}


- (void)handleNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:remoteControlTogglePlayPause]){
        DLog(@"headphone play or pause");
        [self play:nil];
    }
    if ([notification.name isEqualToString:remoteControlPlayButtonTapped]) {
        DLog(@"Play remote event recieved play.");
        [self play:nil];
    } else  if ([notification.name isEqualToString:remoteControlPauseButtonTapped]) {
        DLog(@"pause");
        [self play:nil];
        
    } else if ([notification.name isEqualToString:remoteControlStopButtonTapped]) {
        DLog(@"Play remote event recieved stopped.");
        [_streamPlayer stop];
        
    } else if ([notification.name isEqualToString:remoteControlForwardButtonTapped]) {
        DLog(@"Play remote event recieved play forward");
        [self next:nil];
    } else if ([notification.name isEqualToString:remoteControlBackwardButtonTapped]) {
        DLog(@"Play remote event recieved play backward");
    }
    else {
        DLog(@"Play remote event recieved unkown notification");
    }

}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self _resetStreamer];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(_timerAction:)
                                                userInfo:nil
                                                 repeats:YES];

}

- (void)viewDidDisappear:(BOOL)animated
{
    [_timer invalidate];
    self.timer = nil;
    [super viewDidDisappear:animated];
}

- (void)dealloc
{
    DouFMLeftViewController *leftViewController = (DouFMLeftViewController *)self.sideMenuViewController.leftMenuViewController;
    
    if (leftViewController)
    {
        [leftViewController removeObserver:self forKeyPath:@"musicType"];
    }
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}
- (IBAction)play:(id)sender {
    if (_streamPlayer.status == DOUAudioStreamerPaused ||
        _streamPlayer.status == DOUAudioStreamerIdle)
    {
        [_playButton setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        [_streamPlayer play];
    }
    else
    {
        [_playButton setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        [_streamPlayer pause];
    }
}

- (IBAction)next:(id)sender {
    if (++_currentTrackIndex >= [_tracks count])
    {
        _currentTrackIndex = 0;
    }
    [self _resetStreamer];
}


@end
