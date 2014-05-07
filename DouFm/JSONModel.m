//
//  JSONModel.m
//  DouFm
//
//  Created by jackie on 14-5-6.
//  Copyright (c) 2014年 jackie. All rights reserved.
//

#import "JSONModel.h"
#import "MKNetworkKit.h"

@implementation JSONModel

-(id)initWithDictionary:(NSMutableDictionary *)jsonObject
{
    if ((self = [super init]))
    {
        //KVC机制，会调用字典中的所有的key属性set方法
        [self setValuesForKeysWithDictionary:jsonObject];
    }
    return self;
}

-(BOOL) allowsKeyedCoding
{
    return YES;
}

-(id) initWithCoder:(NSCoder *)encoder
{
    return self;
}

-(id) mutableCopyWithZone:(NSZone *)zone
{
    //父类做深复制，因为没有任何变量，因此这么做是OK的
    JSONModel *newModel = [[JSONModel allocWithZone:zone]init];
    return newModel;
}

-(id) copyWithZone:(NSZone *)zone
{
    //子类继承实现深复制
    JSONModel *newModel = [[JSONModel allocWithZone:zone]init];
    return newModel;
}

-(id) valueForUndefinedKey:(NSString *)key
{
    DLog(@"Undefined Key:%@", key);
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    DLog(@"Undefined Key:%@", key);
    //子类应该实现对为定义的类的赋值
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    //这部分什么也不做，由子类实现
}

@end
