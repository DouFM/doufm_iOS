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
    
    [AppDelegate.engine fetchPlayListOnSucceded:^(NSMutableArray *listOfModelBaseObjects) {
                DLog(@"fetch items %@", listOfModelBaseObjects);
        self.playList = [listOfModelBaseObjects copy];
        [self.tableView reloadData];
            } onError:^(NSError *engineError) {
                DLog(@"error %@",engineError);
            }];
}

#pragma tableView datasoure delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.playList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"playListIdentiy"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"playListIdentiy"];
    }
    PlayList *item = [self.playList objectAtIndex:indexPath.row];
    cell.textLabel.text = item.name;
    return cell;
}
@end
