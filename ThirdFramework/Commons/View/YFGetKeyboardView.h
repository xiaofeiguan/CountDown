//
//  YFGetKeyboardView.h
//  YFWeChat
//
//  Created by dyf on 16/5/22.
//  Copyright © 2016年 dyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFGetKeyboardView : UIView

/** 
 在键盘弹出时使用  UIKeyboardDidShowNotification
（注意：如果在UIKeyboardWillShowNotification这个系统通知里处理是不会得到键盘所在view的）
 
 只需要将自定义的键盘 addSubView到 [UIView yf_getKeyboardView] 上即可
 
 */
+ (UIView *)yf_getKeyboardView;

@end
