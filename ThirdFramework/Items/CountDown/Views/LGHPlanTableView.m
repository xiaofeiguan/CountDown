//
//  LGHPlanTableView.m
//  ThirdFramework
//
//  Created by tangkaifu on 2018/7/27.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "LGHPlanTableView.h"
@interface LGHPlanTableView()

@end

@implementation LGHPlanTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if(self)
    {
        [self  setInit];
    }
    return self;
}

-(void)setInit{
//    self.delegate = self
//    self.dataSource = self;
}

@end
