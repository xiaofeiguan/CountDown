//
//  LGHPlanModel.h
//  ThirdFramework
//
//  Created by tangkaifu on 2018/7/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKDBModel.h"
@interface LGHPlanModel :NSObject
@property(nonatomic , strong)NSString *name;
@property(nonatomic,strong)NSString *desc;
@property(nonatomic,assign)NSInteger  backgroundName;
@property(nonatomic,assign)int isAlert;
@property(nonatomic,strong) NSString*targetDateStr;
@property(nonatomic, assign) NSInteger numId;
@property(nonatomic, assign) NSInteger status;

@end
