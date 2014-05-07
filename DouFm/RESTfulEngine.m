//
//  RESTfulEngine.m
//  DouFm
//
//  Created by jackie on 14-5-6.
//  Copyright (c) 2014年 jackie. All rights reserved.
//

#import "RESTfulEngine.h"
#import "SongItem.h"
#import "PlayList.h"

@implementation RESTfulEngine

- (id) initWithHostName:(NSString *)hostName
{
    self = [super initWithHostName:hostName];
    if (self) {
        [self registerOperationSubclass:[RESTfulOperation class]];
    }
    return self;
}


- (RESTfulOperation *) fetchSongItemsFrom:(int )start
                                    toEnd:(int )end
                               OnSucceded:(ArrayBlock)succededBlock
                                  onError:(ErrorBlock)errorBlock
{
    NSString *path = [NSString stringWithFormat:@"%@start=%d&end=%d", SONG_ITEMS_URL, start, end];
    RESTfulOperation *op = (RESTfulOperation *)[self operationWithPath:path];
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        NSMutableArray *responseItemsJson = [completedOperation responseJSON];
        
        NSMutableArray *songItems = [NSMutableArray array];
        //将结果放入到menuItems
        [responseItemsJson enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [songItems addObject:[[SongItem alloc]initWithDictionary:obj]];
        }];
        
        //返回结果
        succededBlock(songItems);
    } onError:errorBlock];
    [self enqueueOperation:op];
    
    return op;
    
}

- (RESTfulOperation *)fetchPlayListOnSucceded:(ArrayBlock)succededBlock
                                      onError:(ErrorBlock)errorBlock
{
    RESTfulOperation *op = (RESTfulOperation *)[self operationWithPath:PLAY_LIST_URL];
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        NSMutableArray *responseItemsJson = [completedOperation responseJSON];
        
        NSMutableArray *playItems = [NSMutableArray array];
        //将结果放入到menuItems
        [responseItemsJson enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [playItems addObject:[[PlayList alloc]initWithDictionary:obj]];
        }];
        //返回结果
        succededBlock(playItems);
    } onError:errorBlock];
    [self enqueueOperation:op];
    return op;
    
}
@end
