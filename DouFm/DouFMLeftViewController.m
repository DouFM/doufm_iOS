//
//  DouFMLeftViewController.m
//  DouFm
//
//  Created by jackie on 14-4-28.
//  Copyright (c) 2014年 jackie. All rights reserved.
//

#import "DouFMLeftViewController.h"
#import "DouFMContentViewController.h"
#import "UIViewController+RESideMenu.h"
#import "AppDelegate.h"
#import "PlayList.h"
#import "DouFMCollectionCell.h"

NSString *kCellID = @"cellID";
NSString *kFileName = @"playlist.plist";

@interface DouFMContentViewController()

@end

@implementation DouFMLeftViewController

//返回存储路径
- (NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectiory = [paths objectAtIndex:0];
    NSString *fileName = [documentsDirectiory stringByAppendingPathComponent:kFileName];
    return fileName;
}

//获取数据
- (void)getPlayListFromFile
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self dataFilePath]])
    {
        self.playList = [NSArray arrayWithContentsOfFile:[self dataFilePath]];
    }
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updatePlayList];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)handleNotification:(NSNotification *)event
{
    if ([event.name isEqualToString:UIApplicationDidBecomeActiveNotification]) {
        
        [self getPlayListFromFile];
        NSDate *lastUpdate = [[NSUserDefaults standardUserDefaults]objectForKey:@"lastUpdate"];
        NSDate *now = [NSDate date];
        NSTimeInterval interval = [now timeIntervalSinceDate:lastUpdate];
        if (_playList == nil || lastUpdate == nil  || interval >= 2 * 24 * 60 * 60 )
        {
            [[NSUserDefaults standardUserDefaults]setObject:now forKey:@"lastUpdate"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self updatePlayList];
        }
    }
}

- (void)updatePlayList
{
    [AppDelegate.engine fetchPlayListOnSucceded:^(NSMutableArray *listOfModelBaseObjects)
     {
         DLog(@"fetch items %@", listOfModelBaseObjects);
         self.playList = listOfModelBaseObjects;
         [self.playList writeToFile:[self dataFilePath] atomically:YES];
         
         PlayList *playList = [_playList objectAtIndex:0];
         
         [[NSUserDefaults standardUserDefaults]setObject:playList.key forKey:kMusicType];
         [[NSUserDefaults standardUserDefaults]synchronize];
         
         self.musicType = playList.key;
         //[self.tableView reloadData];
         [self.collectionView reloadData];
         
     }onError:^(NSError *engineError)
     {
         DLog(@"error %@",engineError);
     }];
}

#pragma mark -- UICollectionDataSourceDelegate


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.playList count] ;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DouFMCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    
    PlayList *playList = [_playList objectAtIndex:indexPath.row];
    cell.titleLabel.text = playList.name;
    return  cell;
}

#pragma mark --UICollectionViewDelegateMethod

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    PlayList *playList = [_playList objectAtIndex: indexPath.row];
    if ([_musicType isEqualToString:playList.key]) {
        [self.sideMenuViewController hideMenuViewController];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:playList.key forKey:kMusicType];
    [[NSUserDefaults standardUserDefaults]setObject:playList.name forKey:kMusicTypeName];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    self.musicType = playList.key;
    [self.sideMenuViewController hideMenuViewController];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}
@end
