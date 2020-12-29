//
//  EBCalendarDayCell.h
//  EBCalendarViewDemo
//
//  Created by HoYo on 2018/4/26.
//  Copyright © 2018年 HoYo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EBCalendarModel.h"

@interface EBCalendarDayCell : UICollectionViewCell
- (void)configWithCalendarModel:(EBCalendarModel*)model;
@end
