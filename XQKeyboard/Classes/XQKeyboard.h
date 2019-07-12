//
//  XQKeyboard.h
//  XQKeyboard
//
//  Created by ChandHsu on 15/8/15.
//  Copyright (c) 2015年 ChandHsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XQKeyboard : UIInputView

/*** 如果设置YES,键盘随机排布 **/
@property (nonatomic, assign) BOOL random;// 默认NO;
@property (nonatomic, assign) BOOL numberLimit;// 默认YES;

/* 可以使用 init 初始化,如果遇到高度问题,选择用下面两个方法初始化 */
+ (instancetype)keyboard;
+ (instancetype)keyboardWithHeight:(CGFloat)height;

@end
