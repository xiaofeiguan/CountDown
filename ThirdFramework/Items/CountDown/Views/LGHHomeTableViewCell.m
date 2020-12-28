//
//  LGHHomeTableViewCell.m
//  ThirdFramework
//
//  Created by tangkaifu on 2018/7/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "LGHHomeTableViewCell.h"
@interface LGHHomeTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *cellMainView;

@property (nonatomic, strong) LGHPlanModel * model;
@end

@implementation LGHHomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.cellMainView.layer.cornerRadius = 8;
    self.cellMainView.clipsToBounds = YES;
}

-(void)setHomeTableViewCellWithPlan:(LGHPlanModel*)model
{
    self.nameLabel.text = model.name;
    self.descLabel.text = model.desc;
    if (model.backgroundName!=1&&model.backgroundName!=2&&model.backgroundName!=3&&model.backgroundName!=4&&model.backgroundName!=5) {
        model.backgroundName=1;
    }
    self.backgroundName.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",model.backgroundName]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)editCell:(UIButton *)sender {
    [self.protocolDelegate editThisCellWithModel:self.model];
}

@end
