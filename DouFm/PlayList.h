//
//  PlayList.h
//  DouFm
//
//  Created by jackie on 14-5-6.
//  Copyright (c) 2014年 jackie. All rights reserved.
//

#import "JSONModel.h"

/*
    music_list: 2969,
    name: "华语",
    key: "52f8ca1d1d41c851663fcba7"
 */
@interface PlayList : JSONModel

@property (strong, nonatomic) NSString *music_list;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *key;

@end
