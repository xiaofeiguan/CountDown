//
//  LGHBaseViewController.m
//  ThirdFramework
//
//  Created by tangkaifu on 2018/7/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "LGHBaseViewController.h"

@interface LGHBaseViewController ()

@end

@implementation LGHBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.navigationController) {
        if (self.navigationController.childViewControllers.count != 0) {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"navi_back"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        }
    }
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}




@end
