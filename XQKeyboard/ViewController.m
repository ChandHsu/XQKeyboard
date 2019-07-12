//
//  ViewController.m
//  XQKeyboard
//
//  Created by 徐强 on 15/10/14.
//  Copyright © 2015年 xuqiang. All rights reserved.
//

#import "ViewController.h"
#import "XQKeyboard.h"

@interface ViewController ()<UITextFieldDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:95/255.0 green:250/255.0 blue:250/255.0 alpha:1.0];
    
    UITextField *textField = [self putFieldAtFrame:CGRectMake(60, 150, 200, 40)];
//    XQKeyboard *keyBoard = [[XQKeyboard alloc] init];
    XQKeyboard *keyBoard = [XQKeyboard keyboardWithHeight:200];
    keyBoard.random = YES;
    keyBoard.numberLimit = true;
    textField.inputView = keyBoard;
    
    [self putFieldAtFrame:CGRectMake(60, 220, 200, 40)];
    
}
- (UITextField *)putFieldAtFrame:(CGRect)frame{
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(60, 150, 200, 40)];
    textField.secureTextEntry = true;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.placeholder = @"这是一个输入框";
    textField.delegate = self;
    [self.view addSubview:textField];
    textField.frame = frame;
    return textField;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSLog(@"正在输入");
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"完成");
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:true];
}

@end
