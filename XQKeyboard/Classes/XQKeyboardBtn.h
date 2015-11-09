//
//  XQKeyboardBtn.h
//  XQKeyboard
//
//  Created by 徐强 on 15/8/15.
//  Copyright (c) 2015年 xuqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define margin 5  


@class XQKeyboardBtn;
@protocol XQKeyboardBtnDelegate <NSObject>

@required
- (void)KeyboardBtnDidClick:(XQKeyboardBtn *)btn;

@end

@interface XQKeyboardBtn : UIButton


+ (XQKeyboardBtn *)buttonWithTitle:(NSString *)title tag:(NSInteger)tag  delegate:(id)delegate;

@property (nonatomic, assign) id <XQKeyboardBtnDelegate> delegate;

@end
