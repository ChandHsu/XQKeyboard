//
//  XQKeyboard.m
//  XQKeyboard
//
//  Created by 徐强 on 15/8/15.
//  Copyright (c) 2015年 xuqiang. All rights reserved.
//

#import "XQKeyboard.h"
#import "XQKeyboardNumPad.h"
#import "XQKeyboardSymbolPad.h"
#import "XQKeyboardWordPad.h"

#define  iPhone4     ([[UIScreen mainScreen] bounds].size.height==480)
#define  iPhone5     ([[UIScreen mainScreen] bounds].size.height==568)
#define  iPhone6     ([[UIScreen mainScreen] bounds].size.height==667)
#define  iPhone6plus ([[UIScreen mainScreen] bounds].size.height==736)


@interface XQKeyboard ()<XQKeyboardNumPadDelegate,XQKeyboardWordPadDelegate,XQKeyboardSymbolPadDelaget>

@property (nonatomic, weak) XQKeyboardNumPad *numPad;
@property (nonatomic, weak) XQKeyboardWordPad *wordPad;
@property (nonatomic, weak) XQKeyboardSymbolPad *symbolPad;

@end

@implementation XQKeyboard

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:116/255.0 green:144/255.0 blue:194/255.0 alpha:0.2];
        CGRect rect = CGRectZero;
        if (iPhone4 || iPhone5) {
            rect = CGRectMake(0, 0, 320, 180);
//            rect = CGRectMake(0, 0, 320, 216);
        }else if (iPhone6){
            rect = CGRectMake(0, 0, 375, 375/320*180);
//            rect = CGRectMake(0, 0, 375, 216);
        }else{
            rect = CGRectMake(0, 0, 414, 414/320*180);
//            rect = CGRectMake(0, 0, 414, 226);
        }
        
        self.frame = rect;
        XQKeyboardNumPad *numPad = [[XQKeyboardNumPad alloc] initWithFrame:rect];
        numPad.delegate = self;
        self.numPad = numPad;
        [self addSubview:numPad];
    }
    return self;
}

- (void)KeyboardNumPadDidClickSwitchBtn:(UIButton *)btn{
    if ([btn.titleLabel.text isEqualToString:@"ABC"]) {
        XQKeyboardWordPad *wordPad = [[XQKeyboardWordPad alloc] initWithFrame:self.bounds];
        wordPad.delegate = self;
        [self addSubview:wordPad];
        self.wordPad = wordPad;
        [self.numPad removeFromSuperview];
    }else{
        XQKeyboardSymbolPad *symbolPad = [[XQKeyboardSymbolPad alloc] initWithFrame:self.bounds];
        symbolPad.delegate = self;
        [self addSubview:symbolPad];
        self.symbolPad = symbolPad;
        [self.numPad removeFromSuperview];
    }
}

-(void)KeyboardWordPadDidClickSwitchBtn:(UIButton *)btn{
    if ([btn.titleLabel.text isEqualToString:@"123"]) {
        XQKeyboardNumPad *numPad = [[XQKeyboardNumPad alloc] initWithFrame:self.bounds];
        numPad.delegate = self;
        [self addSubview:numPad];
        self.numPad = numPad;
        [self.wordPad removeFromSuperview];
    }else{
        XQKeyboardSymbolPad *symbolPad = [[XQKeyboardSymbolPad alloc] initWithFrame:self.bounds];
        symbolPad.delegate = self;
        [self addSubview:symbolPad];
        self.symbolPad = symbolPad;
        [self.wordPad removeFromSuperview];
    }
}

- (void)KeyboardSymbolPadDidClickSwitchBtn:(UIButton *)btn{
    if ([btn.titleLabel.text isEqualToString:@"123"]) {
        XQKeyboardNumPad *numPad = [[XQKeyboardNumPad alloc] initWithFrame:self.bounds];
        numPad.delegate = self;
        [self addSubview:numPad];
        self.numPad = numPad;
        [self.symbolPad removeFromSuperview];
    }else{
        XQKeyboardWordPad *wordPad = [[XQKeyboardWordPad alloc] initWithFrame:self.bounds];
        wordPad.delegate = self;
        [self addSubview:wordPad];
        self.wordPad = wordPad;
        [self.symbolPad removeFromSuperview];
    }
}


@end
