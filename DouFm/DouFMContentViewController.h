//
//  DouFMContentViewController.h
//  DouFm
//
//  Created by jackie on 14-4-28.
//  Copyright (c) 2014年 jackie. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DouFMContentViewController : UIViewController

@property (nonatomic, copy) NSMutableArray *tracks;
@property (assign, nonatomic) NSUInteger currentIndex;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *musicTitle;
@property (weak, nonatomic) IBOutlet UILabel *leftTime;

- (IBAction)play:(id)sender;
- (IBAction)next:(id)sender;

@end
