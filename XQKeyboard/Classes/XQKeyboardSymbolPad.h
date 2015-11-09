//
//  XQKeyboardSymbolPad.h
//  XQKeyboard
//
//  Created by 徐强 on 15/8/15.
//  Copyright (c) 2015年 xuqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XQKeyboardBtn.h"

@protocol XQKeyboardSymbolPadDelaget  <NSObject>

@required
- (void)KeyboardSymbolPadDidClickSwitchBtn:(UIButton *)btn;

@end

@interface XQKeyboardSymbolPad : UIView <XQKeyboardBtnDelegate>

@property (nonatomic, assign) BOOL random;
@property (nonatomic, assign) id <XQKeyboardSymbolPadDelaget> delegate;

@end
