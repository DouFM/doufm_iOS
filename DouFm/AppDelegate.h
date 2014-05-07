//
//  AppDelegate.h
//  DouFm
//
//  Created by jackie on 14-4-28.
//  Copyright (c) 2014年 jackie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESTfulEngine.h"
#define  AppDelegate ((DouFmAppDelegate *)[UIApplication sharedApplication].delegate)



@interface DouFmAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RESTfulEngine *engine;

@end
