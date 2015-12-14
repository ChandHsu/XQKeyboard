//
//  XQKeyboardNumPad.m
//  XQKeyboard
//
//  Created by 徐强 on 15/8/15.
//  Copyright (c) 2015年 xuqiang. All rights reserved.
//

#import "XQKeyboardNumPad.h"
#import "XQKeyboardTool.h"

@interface XQKeyboardNumPad () <XQKeyboardBtnDelegate>

@property (nonatomic, strong) NSMutableArray *btnArray;
@property (nonatomic, weak) UITextField *responder;
@property (nonatomic, strong) NSArray *numArray;
@property (nonatomic, assign) NSRange selectedRange;

@end

@implementation XQKeyboardNumPad

- (UITextField *)responder{
//    if (!_responder) {  // 防止多个输入框采用同一个inputview
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        UIView *firstResponder = [keyWindow valueForKey:@"firstResponder"];
        _responder = (UITextField *)firstResponder;
//    }
    return _responder;
}



- (NSArray *)numArray{
    if (!_numArray) {
        _numArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",@"@",@"."];
        
    }
    return _numArray;
}

- (void)setRandom:(BOOL)random{
    _random = random;
    if (random) {
        
        NSMutableArray *newArray = [NSMutableArray arrayWithArray:self.numArray];
        for(int i = 0; i< self.numArray.count; i++)
        {
            int m = (arc4random() % (self.numArray.count - i)) + i;
            [newArray exchangeObjectAtIndex:i withObjectAtIndex: m];
        }
        self.numArray = newArray;
        for (UIButton *btn in self.subviews) {
            [btn removeFromSuperview];
        }
        [self addControl];
    }
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addControl];
    }
    return self;
}

- (void)addControl{
    NSMutableArray *btnArray = [NSMutableArray array];
    XQKeyboardBtn *btn1 = [XQKeyboardBtn buttonWithTitle:self.numArray[0] tag:0 delegate:self];
    [self addSubview:btn1];
    
    XQKeyboardBtn *btn2 = [XQKeyboardBtn buttonWithTitle:self.numArray[1] tag:1 delegate:self];
    [self addSubview:btn2];
    
    XQKeyboardBtn *btn3 = [XQKeyboardBtn buttonWithTitle:self.numArray[2] tag:2 delegate:self];
    [self addSubview:btn3];
    
    XQKeyboardBtn *btn4 = [XQKeyboardBtn buttonWithTitle:self.numArray[3] tag:4 delegate:self];
    [self addSubview:btn4];
    
    XQKeyboardBtn *btn5 = [XQKeyboardBtn buttonWithTitle:self.numArray[4] tag:5 delegate:self];
    [self addSubview:btn5];
    
    XQKeyboardBtn *btn6 = [XQKeyboardBtn buttonWithTitle:self.numArray[5] tag:6 delegate:self];
    [self addSubview:btn6];
    
    XQKeyboardBtn *btn7 = [XQKeyboardBtn buttonWithTitle:self.numArray[6] tag:8 delegate:self];
    [self addSubview:btn7];
    
    XQKeyboardBtn *btn8 = [XQKeyboardBtn buttonWithTitle:self.numArray[7] tag:9 delegate:self];
    [self addSubview:btn8];
    
    XQKeyboardBtn *btn9 = [XQKeyboardBtn buttonWithTitle:self.numArray[8] tag:10 delegate:self];
    [self addSubview:btn9];
    
    XQKeyboardBtn *btn0 = [XQKeyboardBtn buttonWithTitle:self.numArray[9] tag:13 delegate:self];
    [self addSubview:btn0];
    
    XQKeyboardBtn *btnAT = [XQKeyboardBtn buttonWithTitle:self.numArray[10] tag:12 delegate:self];
    [self addSubview:btnAT];
    
    XQKeyboardBtn *pointBtn = [XQKeyboardBtn buttonWithTitle:self.numArray[11] tag:14 delegate:self];
    [self addSubview:pointBtn];
    
    UIButton *wordSwitchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    wordSwitchBtn.tag = 3;
    [wordSwitchBtn addTarget:self action:@selector(switchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [wordSwitchBtn setTitle:@"ABC" forState:UIControlStateNormal];
    wordSwitchBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [wordSwitchBtn setBackgroundImage:[UIImage imageNamed:@"images.bundle/keypadLongBtn"] forState:UIControlStateNormal];
    [self addSubview:wordSwitchBtn];
    
    UIButton *symbolSwitchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [symbolSwitchBtn setBackgroundImage:[UIImage imageNamed:@"images.bundle/keypadLongBtn"] forState:UIControlStateNormal];
    [symbolSwitchBtn setTitle:@"@#%" forState:UIControlStateNormal];
    [symbolSwitchBtn addTarget:self action:@selector(switchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    symbolSwitchBtn.titleLabel.font = wordSwitchBtn.titleLabel.font;
    symbolSwitchBtn.tag = 7;
    [self addSubview:symbolSwitchBtn];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"images.bundle/keypadDeleteBtn"] forState:UIControlStateNormal];
    [self addSubview:deleteBtn];
    deleteBtn.tag = 11;
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [okBtn setTitle:@"完成" forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(okBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:okBtn];
    [okBtn setBackgroundImage:[UIImage imageNamed:@"images.bundle/keypadLongBtn"] forState:UIControlStateNormal];
    okBtn.tag = 15;

    [wordSwitchBtn addTarget:self action:@selector(switchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [symbolSwitchBtn addTarget:self action:@selector(switchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [okBtn addTarget:self action:@selector(okBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.btnArray = btnArray;
    [self.btnArray addObject:btn1];
    [self.btnArray addObject:btn2];
    [self.btnArray addObject:btn3];
    [self.btnArray addObject:btn4];
    [self.btnArray addObject:btn5];
    [self.btnArray addObject:btn6];
    [self.btnArray addObject:btn7];
    [self.btnArray addObject:btn8];
    [self.btnArray addObject:btn9];
    [self.btnArray addObject:btn0];
    [self.btnArray addObject:btnAT];
    [self.btnArray addObject:pointBtn];
    [self.btnArray addObject:deleteBtn];
    [self.btnArray addObject:symbolSwitchBtn];
    [self.btnArray addObject:wordSwitchBtn];
    [self.btnArray addObject:okBtn];
    
    for (int i = 11; i<16; i++) {
        UIButton *btn = self.btnArray[i];
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
    }
    
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleWidth;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat btnW = (self.frame.size.width - 5*margin)/4;
    CGFloat btnH = (self.frame.size.height - 5*margin)/4;
    
    for (XQKeyboardBtn *btn in self.btnArray) {
        btn.frame = CGRectMake(margin + btn.tag % 4 * (btnW + margin), margin + btn.tag / 4 * (btnH + margin), btnW, btnH);
    }
}

- (void)switchBtnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(KeyboardNumPadDidClickSwitchBtn:)]) {
        [self.delegate KeyboardNumPadDidClickSwitchBtn:btn];
    }
}

- (void)deleteBtnClick{
    [XQKeyboardTool deleteStringForResponder:self.responder];
}

- (void)okBtnClick{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

#pragma mark - XQKeyboardBtnDelegate
-(void)KeyboardBtnDidClick:(XQKeyboardBtn *)btn{
    if (btn.tag % 4 == 3) return;
    
    [XQKeyboardTool appendString:btn.titleLabel.text forResponder:self.responder];
}


@end
