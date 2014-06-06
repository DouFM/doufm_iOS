//
//  DouFMLeftViewController.h
//  DouFm
//
//  Created by jackie on 14-4-28.
//  Copyright (c) 2014年 jackie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"

@interface DouFMLeftViewController : UIViewController <RESideMenuDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (copy, nonatomic) NSArray *playList;
@property (strong, nonatomic) NSString *musicType;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (void)updatePlayList;

@end
