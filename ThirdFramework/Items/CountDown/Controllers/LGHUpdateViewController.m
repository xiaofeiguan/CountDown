//
//  LGHUpdateViewController.m
//  ThirdFramework
//
//  Created by 小肥观 on 2018/9/7.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "LGHUpdateViewController.h"
#import "LGHMainView.h"
@interface LGHUpdateViewController ()

@property(nonatomic,strong) LGHPlanModel *plan;

@end

@implementation LGHUpdateViewController

-(instancetype)initWithPlan:(LGHPlanModel*)plan
{
    self = [super init];
    if (self) {
        self.plan = plan;
        //点击修改设置
        LGHMainView *mainView = [[NSBundle  mainBundle]loadNibNamed:@"LGHMainView" owner:nil options:nil].lastObject;
        [self.view addSubview:mainView];
        mainView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
