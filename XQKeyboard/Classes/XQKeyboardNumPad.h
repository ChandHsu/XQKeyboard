//
//  XQKeyboardNumPad.h
//  XQKeyboard
//
//  Created by 徐强 on 15/8/15.
//  Copyright (c) 2015年 xuqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XQKeyboardBtn.h"

@protocol XQKeyboardNumPadDelegate  <NSObject>

@required
- (void)KeyboardNumPadDidClickSwitchBtn:(UIButton *)btn;

@end


@interface XQKeyboardNumPad : UIView <XQKeyboardBtnDelegate>


@property (nonatomic, assign) id <XQKeyboardNumPadDelegate> delegate;

@end
