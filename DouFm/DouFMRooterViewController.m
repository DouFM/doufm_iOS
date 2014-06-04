//
//  DouFMRooterViewController.m
//  DouFm
//
//  Created by jackie on 14-4-28.
//  Copyright (c) 2014年 jackie. All rights reserved.
//

#import "DouFMRooterViewController.h"
#import "AppDelegate.h"

@implementation DouFMRooterViewController

-(void)awakeFromNib
{
    self.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
    self.contentViewShadowColor = [UIColor blackColor];
    self.contentViewShadowOffset = CGSizeMake(0, 0);
    self.contentViewShadowOpacity = 0.6;
    self.contentViewShadowRadius = 12;
    self.contentViewShadowEnabled = YES;
    
    self.contentViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"];
    self.leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftMenuViewController"];
    self.backgroundImage = [UIImage imageNamed:@"Background"];
    self.delegate = self;
    
//    NSMutableString *strName = [NSMutableString stringWithString:@"hello"];
//    self.name = [strName mutableCopy];
//    [strName appendString:@" world"];
//    DLog(@"name %@",self.name);
//    NSArray * arr = [NSArray arrayWithObjects:@"1", @"2", @"3", nil];
//    
//    NSMutableArray *dataArray = [NSMutableArray arrayWithObjects:[NSMutableString stringWithString:@"hello"], [NSMutableString stringWithString:@"world"], nil];//[NSMutableArray arrayWithObjects:@"one", @"two", @"three", nil];
//    //NSMutableArray *dataArray2 = [arr mutableCopy];
//    NSMutableArray *dataArray2 = [dataArray mutableCopy];
//    NSMutableString *str = [dataArray objectAtIndex:0];
//    [str appendString:@"world"];
//    //[dataArray removeObjectAtIndex:0];
//   // [dataArray2 removeObjectAtIndex:2];
//    DLog(@"dataArray %@", dataArray)
//    DLog(@"dataArray2 %@", dataArray2);
   
    
}

#pragma mark -
#pragma mark RESideMenu Delegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    DLog(@"willShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
    DLog(@"didShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
    DLog(@"willHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
    DLog(@"didHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

@end
