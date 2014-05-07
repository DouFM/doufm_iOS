//
//  RESTfulOperation.m
//  DouFm
//
//  Created by jackie on 14-5-6.
//  Copyright (c) 2014年 jackie. All rights reserved.
//

#import "RESTfulOperation.h"


@implementation RESTfulOperation

- (void)operationSucceeded
{
    
//    NSMutableDictionary *errorDic = [[self responseJSON]objectForKey:@"error"];
//    if (errorDic) {
//        //扩充以便于进行错误信息判断
//        DLog(@"error on succeed %@", errorDic);
//    }
//    else{
        [super operationSucceeded];
  //  }
}

- (void) operationFailedWithError:(NSError *)error
{
    //NSMutableDictionary *errorDict = [[self.responseJSON] objectForKey:@"error"];
    [super operationFailedWithError:error];
}

@end
