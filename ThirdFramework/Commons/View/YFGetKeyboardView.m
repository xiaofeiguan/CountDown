//
//  YFGetKeyboardView.m
//  YFWeChat
//
//  Created by dyf on 16/5/22.
//  Copyright © 2016年 dyf. All rights reserved.
//

#import "YFGetKeyboardView.h"

@implementation YFGetKeyboardView

+ (UIView *)yf_getKeyboardView
{
    UIView *result = nil;
    NSArray *windowsArray = [UIApplication sharedApplication].windows;
    for (UIView *tmpWindow in windowsArray) {
        NSArray *viewArray = [tmpWindow subviews];
        for (UIView *tmpView  in viewArray) {
            if ([[NSString stringWithUTF8String:object_getClassName(tmpView)] isEqualToString:@"UIPeripheralHostView"]) {
                result = tmpView;
                break;
            }
        }
        
        if (result != nil) {
            break;
        }
    }
    
    return result;
}

@end
