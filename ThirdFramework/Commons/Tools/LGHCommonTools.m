//
//  LGHCommonTools.m
//  ThirdFramework
//
//  Created by 小肥观 on 2020/12/28.
//  Copyright © 2020 apple. All rights reserved.
//

#import "LGHCommonTools.h"

@implementation LGHCommonTools
/**
 * 判断是否需要升级
 */
+(BOOL)judgeNeedUpdate
{
    NSDictionary *bundleDict = [NSBundle mainBundle].infoDictionary;
    NSString *appID = bundleDict[@"CFBundleIdentifier"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/lookup?bundleId=%@",appID]];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (data) {
        NSDictionary *lookupDict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([lookupDict[@"resultCount"] integerValue] == 1) {
            NSString* appStoreVersion = lookupDict[@"results"][0][@"version"];
            NSString* currentVersion = bundleDict[@"CFBundleShortVersionString"];
            if ([appStoreVersion compare:currentVersion options:NSNumericSearch] == NSOrderedDescending) {
                NSLog(@"\n\nNeed to update. Appstore version %@ is greater than %@",appStoreVersion, currentVersion);
                return YES;
            } else {
                NSLog(@"no need update");
                return NO;
            }
        }
    }
    return NO;
}
@end
