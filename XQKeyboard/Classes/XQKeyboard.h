//
//  XQKeyboard.h
//  XQKeyboard
//
//  Created by 徐强 on 15/8/15.
//  Copyright (c) 2015年 xuqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XQKeyboard : UIView

/*** 如果设置YES,键盘随机排布 **/
@property (nonatomic, assign) BOOL random;// default is NO;
@property (nonatomic, assign) BOOL numberLimit;// default is NO;

@end
