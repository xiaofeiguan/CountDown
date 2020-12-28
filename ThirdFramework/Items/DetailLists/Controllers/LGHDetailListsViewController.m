//
//  LGHDetailListsViewController.m
//  ThirdFramework
//
//  Created by 小肥观 on 2020/12/28.
//  Copyright © 2020 apple. All rights reserved.
//

#import "LGHDetailListsViewController.h"

@interface LGHDetailListsViewController ()

@end

@implementation LGHDetailListsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *editButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"清单" style:UIBarButtonItemStylePlain target:nil action:nil];
    NSDictionary *textAttributes = @{
        NSForegroundColorAttributeName: [UIColor blackColor],
        NSFontAttributeName:[UIFont fontWithName:@"方圆硬笔行书简" size:25]
    };
    [editButtonItem setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = editButtonItem;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
