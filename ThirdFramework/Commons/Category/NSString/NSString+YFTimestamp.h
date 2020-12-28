//
//  NSString+YFTimestamp.h
//  YFWeChat
//
//  Created by dyf on 16/5/19.
//  Copyright © 2016年 dyf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (YFTimestamp)

+ (NSString *)yf_convastionTimeStr:(long long)time;

@end
