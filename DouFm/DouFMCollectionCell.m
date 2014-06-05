//
//  DouFMCollectionCell.m
//  DouFm
//
//  Created by jackie on 14-6-5.
//  Copyright (c) 2014年 jackie. All rights reserved.
//

#import "DouFMCollectionCell.h"

@implementation DouFMCollectionCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.layer.cornerRadius = 3.0;
        self.clipsToBounds = YES;
        
        UIView *selectBackgroundView = [[UIView alloc]initWithFrame:self.bounds];
        selectBackgroundView.backgroundColor = [UIColor grayColor];
        self.selectedBackgroundView = selectBackgroundView;
        
    }
    return self;
}
@end
