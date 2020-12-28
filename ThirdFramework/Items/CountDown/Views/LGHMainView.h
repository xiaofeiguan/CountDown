//
//  LGHMainView.h
//  ThirdFramework
//
//  Created by tangkaifu on 2018/7/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGHPlanModel.h"
@interface LGHMainView : UIView



    @property (weak, nonatomic) IBOutlet UITextField *nameField;
    @property (weak, nonatomic) IBOutlet UIButton *timeButton;
    @property (weak, nonatomic) IBOutlet UILabel *planTimeLabel;

    @property (weak, nonatomic) IBOutlet UITextField *descriptionField;
    @property (weak, nonatomic) IBOutlet UISwitch *alertSwitch;
    @property (weak, nonatomic) IBOutlet UIButton *completeButton;

    
    @property (weak, nonatomic) IBOutlet UIView *showPlanView;


    
    @property (weak, nonatomic) IBOutlet UIButton *btn1;
    @property (weak, nonatomic) IBOutlet UIButton *btn2;
    @property (weak, nonatomic) IBOutlet UIButton *btn3;
    @property (weak, nonatomic) IBOutlet UIButton *btn4;
    @property (weak, nonatomic) IBOutlet UIButton *btn5;





@property (weak, nonatomic) IBOutlet UILabel *showNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *showDescLabel;
@property (weak, nonatomic) IBOutlet UIView *showCountdownView;
@property (weak, nonatomic) IBOutlet UILabel *daysLabel;
@property (weak, nonatomic) IBOutlet UILabel *hoursLabel;
@property (weak, nonatomic) IBOutlet UILabel *minutesLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondsLabel;

 @property(nonatomic , assign)NSInteger backgroundName ;


@property(nonatomic ,assign)LGHPlanModel *plan;
    
@end
