//
//  XQKeyboardTool.h
//  XQKeyboard
//
//  Created by Apple on 15/12/14.
//  Copyright © 2015年 xuqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XQKeyboardTool : NSObject

+ (NSRange)rangeFromTextRange:(UITextRange *)textRange inTextField:(UITextField *)textField;
+ (void)setSelectedRange:(NSRange)range ofTextField:(UITextField *)textField;

+ (void)appendString:(NSString *)newString forResponder:(UITextField *)textField;
+ (void)deleteStringForResponder:(UITextField *)textField;

@end
