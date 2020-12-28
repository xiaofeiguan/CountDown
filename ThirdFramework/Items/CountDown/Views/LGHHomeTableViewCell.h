//
//  LGHHomeTableViewCell.h
//  ThirdFramework
//
//  Created by tangkaifu on 2018/7/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGHPlanModel.h"

@protocol LGHHomeTableViewCellProtocol <NSObject>

-(void)editThisCellWithModel:(LGHPlanModel*)model;

@end

@interface LGHHomeTableViewCell : UITableViewCell
@property (nonatomic, weak) id<LGHHomeTableViewCellProtocol>  protocolDelegate ;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet UILabel *daysLabel;
@property (weak, nonatomic) IBOutlet UILabel *hoursLabel;
@property (weak, nonatomic) IBOutlet UILabel *minuteLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundName;

@property (weak, nonatomic) IBOutlet UIView *countdownTimeView;
@property (weak, nonatomic) IBOutlet UILabel *showPastTimeLabel;

-(void)setHomeTableViewCellWithPlan:(LGHPlanModel*)model;
@end
