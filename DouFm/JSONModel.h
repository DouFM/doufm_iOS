//
//  JSONModel.h
//  DouFm
//
//  Created by jackie on 14-5-6.
//  Copyright (c) 2014年 jackie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONModel : NSObject <NSCoding, NSCopying, NSMutableCopying>{
    
}

- (id) initWithDictionary:(NSMutableDictionary *)jsonObject;
@end
