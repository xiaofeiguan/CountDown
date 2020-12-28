//
//  LGHMainView.m
//  ThirdFramework
//
//  Created by tangkaifu on 2018/7/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "LGHMainView.h"

@interface LGHMainView()
@property (weak, nonatomic) IBOutlet UIImageView *styleImgView;
    
@property(nonatomic , strong)NSArray *btns;


@end



@implementation LGHMainView

-(void)setPlan:(LGHPlanModel *)plan
{
    _plan = plan;
    self.showNameLabel.text = plan.name;
    self.showDescLabel.text = plan.desc;
    if (plan.isAlert) {
        [self.alertSwitch setOn:YES];
    }else{
        [self.alertSwitch setOn:NO];
    }
    self.planTimeLabel.text = plan.targetDateStr;
}

-(void)layoutSubviews
{
    self.backgroundName = 1;
    self.showPlanView.layer.cornerRadius = 5;
    self.showPlanView.clipsToBounds = YES;
    [self layoutIfNeeded ];
}

    -(NSArray*) btns
    {
        if (!_btns) {
            _btns =  @[_btn1,_btn2,_btn3,_btn4,_btn5] ;
        }
        return _btns ;
    }
    
- (IBAction)changeStyle:(UIButton *)sender {
    NSLog(@"sender");
    sender.selected = YES;
   for(UIButton *btn in self.btns )
    {
        if(btn!=sender)
        {
            btn.selected = NO;
        }
    }
    NSInteger imgName = sender.tag-100;
    self.styleImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",imgName]];
    self.backgroundName = imgName;
}
    
    
    
@end
