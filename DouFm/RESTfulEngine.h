//
//  RESTfulEngine.h
//  DouFm
//
//  Created by jackie on 14-5-6.
//  Copyright (c) 2014年 jackie. All rights reserved.
//

#import "MKNetworkEngine.h"
#import "JSONModel.h"
#import "RESTfulOperation.h"

#define  SONG_ITEMS_URL @"/api/music/?"
#define  PLAY_LIST_URL @"/api/playlist/"

typedef void (^VoidBlock) (void);
typedef void (^ModelBlock) (JSONModel *aModelBaseObject);
typedef void (^ArrayBlock) (NSMutableArray *listOfModelBaseObjects);
typedef void (^ErrorBlock) (NSError * engineError);

@interface RESTfulEngine : MKNetworkEngine {
    
}

/*
 * 获取由start开始到end结束的歌曲数据
 */
- (RESTfulOperation *) fetchSongItemsFrom:(NSUInteger )start
                                    toEnd:(NSUInteger )end
                               OnSucceded:(ArrayBlock)succededBlock
                                  onError:(ErrorBlock)errorBlock;
- (RESTfulOperation *) fetchPlayListOnSucceded:(ArrayBlock)succededBlock
                                       onError:(ErrorBlock)errorBlock;
@end
