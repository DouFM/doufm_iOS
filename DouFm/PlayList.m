//
//  PlayList.m
//  DouFm
//
//  Created by jackie on 14-5-6.
//  Copyright (c) 2014年 jackie. All rights reserved.
//

#import "PlayList.h"

@implementation PlayList

- (id)init
{
    self = [super init];
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    [super setValue:value forUndefinedKey:key];
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
}

//返回分类的名字
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", self.name];
}

//===========================================================
//  Keyed Archiving
//  关键部分代码
//
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.key forKey:@"name"];
    [aCoder encodeObject:self.music_list forKey:@"music_list"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.music_list = [aDecoder decodeObjectForKey:@"music_list"];
        self.key = [aDecoder decodeObjectForKey:@"key"];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    id theCopy = [[[self class]allocWithZone:zone]init];
    
    [theCopy setName:[self.name copy]];
    [theCopy setMusic_list:[self.music_list copy]];
    [theCopy setKey:[self.key copy]];
    
    return theCopy;
}

@end

