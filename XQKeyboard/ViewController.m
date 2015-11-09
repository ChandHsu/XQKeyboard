//
//  ViewController.m
//  XQKeyboard
//
//  Created by 徐强 on 15/10/14.
//  Copyright © 2015年 xuqiang. All rights reserved.
//

#import "ViewController.h"
#import "XQKeyboard.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:95/255.0 green:250/255.0 blue:250/255.0 alpha:1.0];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(60, 150, 200, 40)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.placeholder = @"这是一个输入框";
    [self.view addSubview:textField];
    XQKeyboard *keyBoard = [[XQKeyboard alloc] init];
    keyBoard.random = NO;
    textField.inputView = keyBoard;
    
}

@end
