//
//  DouFmTests.m
//  DouFmTests
//
//  Created by jackie on 14-4-28.
//  Copyright (c) 2014年 jackie. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DouFMLeftViewController.h"

@interface DouFmTests : XCTestCase

@property DouFMLeftViewController *leftViewController;

@end

@implementation DouFmTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.leftViewController = [DouFMLeftViewController new];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//- (void)testExample
//{
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
//}

//- (void)testMyDogCats
//{
//    NSString *cats = @"cats";
//    XCTAssertEqualObjects([self.leftViewController dogMyCats:cats], @"dogs", @"ouFMLeftViewController fail to produce dogs from \"%@\"", cats);
//}

@end
