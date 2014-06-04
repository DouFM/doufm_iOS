//
//  SongItem.m
//  DouFm
//
//  Created by jackie on 14-5-6.
//  Copyright (c) 2014年 jackie. All rights reserved.
//

#import "SongItem.h"

@implementation SongItem

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

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@",self.title];
}

- (NSURL *)audioFileURL
{
    if (_audioFileURL == nil)
    {
        _audioFileURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@", kBaseURL, self.audio]];
    }
    return _audioFileURL;
}
//===========================================================
//  Keyed Archiving
//  关键部分代码
//===========================================================

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.upload_date forKey:@"upload_date"];
    [aCoder encodeObject:self.album forKey:@"album"];
    [aCoder encodeObject:self.key forKey:@"key"];
    [aCoder encodeObject:self.kbps forKey:@"kbps"];
    [aCoder encodeObject:self.artist forKey:@"artist"];
    [aCoder encodeObject:self.audio forKey:@"audio"];
    [aCoder encodeObject:self.company forKey:@"company"];
    [aCoder encodeObject:self.cover forKey:@"cover"];
    [aCoder encodeObject:self.public_time forKey:@"public_time"];
    //[aCoder encodeObject:self.audioFileURL forKey:@"audioFileURL"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.upload_date = [aDecoder decodeObjectForKey:@"upload_date"];
        self.album = [aDecoder decodeObjectForKey:@"album"];
        self.key = [aDecoder decodeObjectForKey:@"key"];
        self.kbps = [aDecoder decodeObjectForKey:@"kbps"];
        self.artist = [aDecoder decodeObjectForKey:@"artist"];
        self.audio = [aDecoder decodeObjectForKey:@"audio"];
        self.company = [aDecoder decodeObjectForKey:@"company"];
        self.cover = [aDecoder decodeObjectForKey:@"cover"];
        self.public_time = [aDecoder decodeObjectForKey:@"public_time"];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    id theCopy = [[[self class]allocWithZone:zone]init];
    
    //防止意外
    [(SongItem *)theCopy setTitle:[self.title copy]];
    [theCopy setUpload_date:[self.upload_date copy]];
    [theCopy setAlbum:[self.album copy]];
    [theCopy setKey:[self.key copy]];
    [theCopy setKbps:[self.kbps copy]];
    [theCopy setArtist:[self.artist copy]];
    [theCopy setAudio:[self.audio copy]];
    [theCopy setCompany:[self.company copy]];
    [theCopy setCover:[self.cover copy]];
    [theCopy setPublic_time:[self.public_time copy]];
    [theCopy setAudioFileURL:[self.audioFileURL copy]];
    
    return theCopy;
}

@end

