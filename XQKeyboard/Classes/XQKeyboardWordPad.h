//
//  XQKeyboardWordPad.h
//  XQKeyboard
//
//  Created by 徐强 on 15/8/15.
//  Copyright (c) 2015年 xuqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XQKeyboardBtn.h"

@protocol XQKeyboardWordPadDelegate <NSObject>

@required
- (void)KeyboardWordPadDidClickSwitchBtn:(UIButton *)btn;

@end

@interface XQKeyboardWordPad : UIView <XQKeyboardBtnDelegate>

@property (nonatomic, assign) id <XQKeyboardWordPadDelegate> delegate;

@end
