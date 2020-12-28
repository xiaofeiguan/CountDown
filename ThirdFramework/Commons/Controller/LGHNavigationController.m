//
//  LGHNavigationController.m
//  ThirdFramework
//
//  Created by tangkaifu on 2018/7/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "LGHNavigationController.h"
#import "UINavigationBar+Awesome.h"

@interface LGHNavigationController ()

@end

@implementation LGHNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 修改导航栏背景 和 标题文字颜色
    [self.navigationBar lt_setBackgroundColor: [UIColor whiteColor]];
    NSDictionary *textAttributes = @{
                                     NSForegroundColorAttributeName: [UIColor blackColor],
                                     NSFontAttributeName:[UIFont fontWithName:@"方圆硬笔行书简" size:25]
                                     };
    self.navigationBar.titleTextAttributes = textAttributes;
    self.navigationBar.tintColor = [UIColor blackColor];
}

// 修改状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

@end
