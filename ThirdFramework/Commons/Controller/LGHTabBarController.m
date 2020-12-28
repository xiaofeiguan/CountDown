//
//  LGHTabBarController.m
//  ThirdFramework
//
//  Created by tangkaifu on 2018/7/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "LGHTabBarController.h"

@interface LGHTabBarController ()<UITabBarDelegate>
@property(nonatomic,weak) id<UITabBarDelegate> delegate;

@end

@implementation LGHTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.修改文字颜色
    UIColor *selColor = [UIColor colorWithRed:(252/255.0) green:(70 / 255.0) blue:(82 / 255.0) alpha:1];
    for (UINavigationController *nav in self.childViewControllers) {
        UITabBarItem *item = nav.tabBarItem;
        
        // 修改选中时,tabBar上的字体
        [item setTitleTextAttributes: @{NSForegroundColorAttributeName: selColor}
                            forState: UIControlStateSelected];
    }
    // 2.修改选中图片颜色
    self.tabBar.tintColor = selColor;
    
    //3.监听
    self.delegate = self;
}

#pragma Mark - UITabBarControllerDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    DLog(@"当前选中的\"%@\"",item.title);
}

@end
