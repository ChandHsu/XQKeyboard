//
//  XQKeyboardSymbolPad.m
//  XQKeyboard
//
//  Created by 徐强 on 15/8/15.
//  Copyright (c) 2015年 xuqiang. All rights reserved.
//

#import "XQKeyboardSymbolPad.h"
#import "XQKeyboardTool.h"

@interface XQKeyboardSymbolPad () 

@property (nonatomic, weak) UITextField *responder;
@property (nonatomic, strong) NSArray *symbolArray;
@property (nonatomic, strong) NSMutableArray *btnArray;

@property (nonatomic, weak) UIButton *okBtn;
@property (nonatomic, weak) UIButton *deleteBtn;
@property (nonatomic, weak) UIButton *numPadCheckBtn;
@property (nonatomic, weak) UIButton *wordBtn;

@end

@implementation XQKeyboardSymbolPad


- (UITextField *)responder{
//    if (!_responder) {  // 防止多个输入框采用同一个inputview
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        UIView *firstResponder = [keyWindow valueForKey:@"firstResponder"];
        _responder = (UITextField *)firstResponder;
//    }
    return _responder;
}

- (NSArray *)symbolArray{
    if (!_symbolArray) {
        _symbolArray = @[@"*",@"/",@":",@";",@"(",@")",@"[",@"]",@"$",@"=",@"!",@"^",@"&",@"%",@"+",@"-",@"￥",@"?",@"{",@"}",@"#",@"_",@"\\",@"|",@"~",@"`",@"∑",@"€",@"£",@"。"];
    }
    return _symbolArray;
}

- (void)setRandom:(BOOL)random{
    _random = random;
    if (random) {
        
        NSMutableArray *newArray = [NSMutableArray arrayWithArray:self.symbolArray];
        for(int i = 0; i< self.symbolArray.count; i++)
        {
            int m = (arc4random() % (self.symbolArray.count - i)) + i;
            [newArray exchangeObjectAtIndex:i withObjectAtIndex: m];
        }
        self.symbolArray = newArray;
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
    for (int i = 0; i < 30; i++) {
        XQKeyboardBtn *btn = [XQKeyboardBtn buttonWithTitle:self.symbolArray[i] tag:i delegate:self];
        [self addSubview:btn];
        [btnArray addObject:btn];
    }
    self.btnArray = btnArray;
    
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"images.bundle/keypadDeleteBtn"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteBtn];
    
    UIButton *numPadCheckBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [numPadCheckBtn setTitle:@"123" forState:UIControlStateNormal];
    [numPadCheckBtn setBackgroundImage:[UIImage imageNamed:@"images.bundle/keypadLongBtn"] forState:UIControlStateNormal];
    [numPadCheckBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    numPadCheckBtn.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    [numPadCheckBtn addTarget:self action:@selector(switchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:numPadCheckBtn];
    
    UIButton *wordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [wordBtn setTitle:@"ABC" forState:UIControlStateNormal];
    [wordBtn setBackgroundImage:[UIImage imageNamed:@"images.bundle/keypadLongBtn"] forState:UIControlStateNormal];
    wordBtn.titleLabel.textColor = numPadCheckBtn.titleLabel.textColor;
    [wordBtn addTarget:self action:@selector(switchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:wordBtn];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [okBtn setTitle:@"完成" forState:UIControlStateNormal];
    [okBtn setBackgroundImage:[UIImage imageNamed:@"images.bundle/keypadLongBtn"] forState:UIControlStateNormal];
    okBtn.titleLabel.textColor = numPadCheckBtn.titleLabel.textColor;
    [okBtn addTarget:self action:@selector(okBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:okBtn];
    
    self.okBtn = okBtn;
    self.wordBtn = wordBtn;
    self.numPadCheckBtn = numPadCheckBtn;
    self.deleteBtn = deleteBtn;
    
    self.okBtn.layer.cornerRadius = 5.0;
    self.okBtn.layer.masksToBounds = YES;
    self.numPadCheckBtn.layer.cornerRadius = 5.0;
    self.numPadCheckBtn.layer.masksToBounds = YES;
    self.wordBtn.layer.cornerRadius = 5.0;
    self.wordBtn.layer.masksToBounds = YES;
    self.deleteBtn.layer.cornerRadius = 5.0;
    self.deleteBtn.layer.masksToBounds = YES;
    
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleWidth;
}

- (void)deleteBtnClick{
    [XQKeyboardTool deleteStringForResponder:self.responder];
}

- (void)switchBtnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(KeyboardSymbolPadDidClickSwitchBtn:)]) {
        [self.delegate KeyboardSymbolPadDidClickSwitchBtn:btn];
    }
}

- (void)okBtnClick{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat btnW = (self.frame.size.width - 13*margin)/10;
    CGFloat btnH = (self.frame.size.height - 5*margin)/4;
    
    for (int i = 0; i < 30; i++) {
        XQKeyboardBtn *btn = self.btnArray[i];
        btn.frame = CGRectMake(2*margin + (i%10)*(btnW + margin), margin + (i/10)*(margin + btnH), btnW, btnH);
    }
    
    CGFloat bigBtnW = (self.frame.size.width - 7*margin)/4;
    self.numPadCheckBtn.frame = CGRectMake(2*margin, 4*margin + btnH*3, bigBtnW, btnH);
    self.wordBtn.frame = CGRectMake(3*margin+bigBtnW, 4*margin + btnH*3, bigBtnW, btnH);
    self.deleteBtn.frame = CGRectMake(4*margin + 2*bigBtnW, 4*margin + btnH*3, bigBtnW, btnH);
    self.okBtn.frame = CGRectMake(5*margin + 3*bigBtnW, 4*margin + btnH*3, bigBtnW, btnH);
    
}

#pragma mark - XQKeyboardBtnDelegate
-(void)KeyboardBtnDidClick:(XQKeyboardBtn *)btn{
    
    [XQKeyboardTool appendString:btn.titleLabel.text forResponder:self.responder];
}




@end
