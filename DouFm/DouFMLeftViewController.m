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

@interface DouFMContentViewController()


@end

@implementation DouFMLeftViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    _tableView.opaque = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.bounces = NO;
    _tableView.scrollsToTop = NO;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [AppDelegate.engine fetchPlayListOnSucceded:^(NSMutableArray *listOfModelBaseObjects)
     {
         DLog(@"fetch items %@", listOfModelBaseObjects);
         self.playList = [listOfModelBaseObjects copy];
         PlayList *playList = [_playList objectAtIndex:0];
         
         [[NSUserDefaults standardUserDefaults]setObject:playList.key forKey:kMusicType];
         [[NSUserDefaults standardUserDefaults]synchronize];
         
         self.musicType = playList.key;
         [self.tableView reloadData];
         
     }onError:^(NSError *engineError)
     {
         DLog(@"error %@",engineError);
     }];
    
    [super viewDidAppear:animated];
}
#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.playList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"playListIdentiy";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    PlayList *item = [self.playList objectAtIndex:indexPath.row];
    cell.textLabel.text = item.name;
    //cell.detailTextLabel.text = item.music_list;
    return cell;
}

#pragma mark UITableView Delegate method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayList *playList = [_playList objectAtIndex:indexPath.row];
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

@end
