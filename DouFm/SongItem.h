//
//  SongItem.h
//  DouFm
//
//  Created by jackie on 14-5-6.
//  Copyright (c) 2014年 jackie. All rights reserved.
//

/*
 demo
 album: "MTV Unplugged in ...",
 upload_date: "Mon, 05 May 2014 13:59:19 -0000",
 public_time: "1994",
 audio: "/api/fs/536728b61d41c850a0071dc1/",
 key: "536728b71d41c850a0071dc9",
 title: "Plateau",
 cover: "/api/fs/536728b61d41c850a0071dbf/",
 company: "Universal",
 artist: "Nirvana",
 kbps: "64"
 */

#import "JSONModel.h"
#import "DOUAudioFile.h"

@interface SongItem : JSONModel<DOUAudioFile>


//注意名字要和demo保持一致，以便使用KVC，例外情况应该是少数部分
@property (strong, nonatomic) NSString *album;
@property (strong, nonatomic) NSString *upload_date;
@property (strong, nonatomic) NSString *public_time;
@property (strong, nonatomic) NSString *audio;
@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *cover;
@property (strong, nonatomic) NSString *company;
@property (strong, nonatomic) NSString *artist;
@property (strong, nonatomic) NSString *kbps;
@property (strong, nonatomic) NSURL *audioFileURL;

@end
