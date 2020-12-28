//
//  LGHTabBarController.m
//  ThirdFramework
//
//  Created by tangkaifu on 2018/7/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "LGHTabBarController.h"
#import "LGHNavigationController.h"
#import "LGHSettingViewController.h"

@interface LGHTabBarController ()<UITabBarDelegate>
@property(nonatomic,weak) id<UITabBarDelegate> delegate;

@end

@implementation LGHTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createControllers];
    
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


- (void)createControllers {
    NSArray *classnameArray = @[@"LGHHomeViewController", @"LGHDetailListsViewController", @"LGHPlanViewController",@"LGHSettingViewController"];
    NSArray *images = @[@"tabbar_home",@"tabbar_qingdan",@"tabbar_jihua",@"tabbar_setting"];
    NSArray *selectedImages = @[@"tabbar_home_select",@"tabbar_qingdan_select",@"tabbar_jihua_select",@"tabbar_setting_select"];
    NSArray *titles = @[@"首页",@"清单",@"计划",@"设置"];
    for (NSInteger i = 0; i < classnameArray.count; i++) {
        Class class = NSClassFromString(classnameArray[i]);
        UIViewController *vc = nil;
        vc = [[class alloc] init];
        LGHNavigationController *navigationVc = [[LGHNavigationController alloc]initWithRootViewController:vc];
        vc.tabBarItem.image = [[UIImage imageNamed:images[i]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImages[i]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc.tabBarItem.title = titles[i];
        // 添加
        [self addChildViewController:navigationVc];
    }
}


#pragma Mark - UITabBarControllerDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    DLog(@"当前选中的\"%@\"",item.title);
}

@end
