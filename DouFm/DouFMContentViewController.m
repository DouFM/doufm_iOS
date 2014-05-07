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
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>

static void *kStatusKVOKey = &kStatusKVOKey;
static void *kDurationKVOKey = &kDurationKVOKey;

@interface DouFMContentViewController()

@property (strong, nonatomic) DOUAudioStreamer *streamPlayer;
@property (assign, nonatomic) NSUInteger currentTrackIndex;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation DouFMContentViewController

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
        
        if (track.audioFileURL != nil) {
            _musicTitle.text = track.title;
            self.streamPlayer = [DOUAudioStreamer streamerWithAudioFile:track];
            [_streamPlayer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:kStatusKVOKey];
            [_streamPlayer addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:kDurationKVOKey];
            _streamPlayer.volume = 1.0;
            
            //设置音乐台控制信息
            if ([MPNowPlayingInfoCenter class]) {
                NSMutableDictionary *songInfo = [[NSMutableDictionary alloc]init];
               // MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc]initWithImage:[UIImage imageNamed:@"play.png"]];
                [songInfo setObject:track.title forKey:MPMediaItemPropertyTitle];
                [songInfo setObject:track.artist forKey:MPMediaItemPropertyArtist];
               // [songInfo setObject:@"Audio Album" forKey:MPMediaItemPropertyAlbumTitle];
                //[songInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork];
                [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
            }
            
            [_streamPlayer play];
        }
    }
}

- (void)_setupHintForStreamer
{
    NSUInteger nextIndex = _currentTrackIndex + 1;
    if (nextIndex >= [_tracks count])
    {
        nextIndex = 0;
    }
    
    [DOUAudioStreamer setHintWithAudioFile:[_tracks objectAtIndex:nextIndex]];
}

- (void)_timerAction:(id)timer
{
   
    self.title = [NSString stringWithFormat:@"%d:%02d", (int)(_streamPlayer.duration - _streamPlayer.currentTime) / 60, (int)(_streamPlayer.duration - _streamPlayer.currentTime)  % 60];
    
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
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)viewDidLoad
{
    [AppDelegate.engine fetchSongItemsFrom:0
                                    toEnd:10
                               OnSucceded:^(NSMutableArray *listOfModelBaseObjects)
                                {
                                    DLog(@"fetch %@", listOfModelBaseObjects)
                                    self.tracks = [listOfModelBaseObjects copy];
                                    [self _resetStreamer];
    
                                }
                                onError:^(NSError *engineError)
                                {
                                    DLog(@"error %@", engineError);
    
                                }];
    
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
