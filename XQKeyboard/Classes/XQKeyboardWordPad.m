//
//  XQKeyboardWordPad.m
//  XQKeyboard
//
//  Created by 徐强 on 15/8/15.
//  Copyright (c) 2015年 xuqiang. All rights reserved.
//

#import "XQKeyboardWordPad.h"
#import "XQKeyboardBtn.h"

@interface XQKeyboardWordPad ()

@property (nonatomic, weak) UITextField *responder;

@property (nonatomic, strong) NSMutableArray *btnArray;
@property (nonatomic, strong) NSArray *wordArray;
@property (nonatomic, strong) NSArray *WORDArray;
@property (nonatomic, weak) UIButton *trasitionWordBtn;
@property (nonatomic, weak) UIButton *deleteBtn;
@property (nonatomic, weak) UIButton *numPadCheckBtn;
@property (nonatomic, weak) UIButton *symbolBtn;
@property (nonatomic, weak) UIButton *okBtn;

@end

@implementation XQKeyboardWordPad

- (UITextField *)responder{
//    if (!_responder) {  // 防止多个输入框采用同一个inputview
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        UIView *firstResponder = [keyWindow valueForKey:@"firstResponder"];
        _responder = (UITextField *)firstResponder;
//    }
    return _responder;
}

- (NSArray *)wordArray{
    if (!_wordArray) {
        _wordArray = @[@"q",@"w",@"e",@"r",@"t",@"y",@"u",@"i",@"o",@"p",@"a",@"s",@"d",@"f",@"g",@"h",@"j",@"k",@"l",@"z",@"x",@"c",@"v",@"b",@"n",@"m",@"空格"];
    }
    return _wordArray;
}
- (NSArray *)WORDArray
{
    if (!_WORDArray) {
        _WORDArray = @[@"Q",@"W",@"E",@"R",@"T",@"Y",@"U",@"I",@"O",@"P",@"A",@"S",@"D",@"F",@"G",@"H",@"J",@"K",@"L",@"Z",@"X",@"C",@"V",@"B",@"N",@"M",@"空格"];
    }
    return _WORDArray;
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
    for (int i = 0; i< 27; i++) {// 添加26个英文字母
        XQKeyboardBtn *btn = [XQKeyboardBtn buttonWithTitle:self.wordArray[i] tag:i delegate:self];
        [btnArray addObject:btn];
        [self addSubview:btn];
    }
    self.btnArray = btnArray;
    
    UIButton *trasitionWordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [trasitionWordBtn setImage:[UIImage imageNamed:@"images.bundle/trasition_normal"] forState:UIControlStateNormal];
    [trasitionWordBtn setImage:[UIImage imageNamed:@"images.bundle/trasition_highlighted"] forState:UIControlStateSelected];
    
    [trasitionWordBtn addTarget:self action:@selector(trasitionWord:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:trasitionWordBtn];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteBtn setImage:[UIImage imageNamed:@"images.bundle/keypadDeleteBtn2"] forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteBtn];
    
    UIButton *numPadCheckBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [numPadCheckBtn setTitle:@"123" forState:UIControlStateNormal];
    [numPadCheckBtn setBackgroundImage:[UIImage imageNamed:@"images.bundle/keypadLongBtn"] forState:UIControlStateNormal];
    [numPadCheckBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    numPadCheckBtn.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    [numPadCheckBtn addTarget:self action:@selector(switchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:numPadCheckBtn];
    
    UIButton *symbolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [symbolBtn setTitle:@"@#%" forState:UIControlStateNormal];
    [symbolBtn setBackgroundImage:[UIImage imageNamed:@"images.bundle/keypadLongBtn"] forState:UIControlStateNormal];
    symbolBtn.titleLabel.textColor = numPadCheckBtn.titleLabel.textColor;
    [symbolBtn addTarget:self action:@selector(switchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:symbolBtn];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [okBtn setTitle:@"完成" forState:UIControlStateNormal];
    [okBtn setBackgroundImage:[UIImage imageNamed:@"images.bundle/keypadLongBtn"] forState:UIControlStateNormal];
    okBtn.titleLabel.textColor = numPadCheckBtn.titleLabel.textColor;
    [okBtn addTarget:self action:@selector(okBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:okBtn];
    
    self.okBtn = okBtn;
    self.symbolBtn = symbolBtn;
    self.numPadCheckBtn = numPadCheckBtn;
    self.deleteBtn = deleteBtn;
    self.trasitionWordBtn = trasitionWordBtn;
    
    
    self.numPadCheckBtn.layer.cornerRadius = 5.0;
    self.numPadCheckBtn.layer.masksToBounds = YES;
    self.okBtn.layer.cornerRadius = 5.0;
    self.okBtn.layer.masksToBounds = YES;
    self.symbolBtn.layer.cornerRadius = 5.0;
    self.symbolBtn.layer.masksToBounds = YES;
    
    self.deleteBtn.layer.cornerRadius = 5.0;
    self.deleteBtn.layer.masksToBounds = YES;
    
    
}

- (void)trasitionWord:(UIButton *)trasitionWordBtn{
    trasitionWordBtn.selected = !trasitionWordBtn.selected;
    if (trasitionWordBtn.selected) {
        for (int i = 0; i<26; i++) {
            XQKeyboardBtn *btn = self.btnArray[i];
            [btn setTitle:self.WORDArray[i] forState:UIControlStateNormal];
        }
    }else{
        for (int i = 0; i<26; i++) {
            XQKeyboardBtn *btn = self.btnArray[i];
            [btn setTitle:self.wordArray[i] forState:UIControlStateNormal];
        }
    }
    
}

- (void)deleteBtnClick{
    if (self.responder.text.length) {
        self.responder.text = [self.responder.text substringToIndex:self.responder.text.length-1];
    }
}

- (void)switchBtnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(KeyboardWordPadDidClickSwitchBtn:)]) {
        [self.delegate KeyboardWordPadDidClickSwitchBtn:btn];
    }
}

- (void)okBtnClick{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat smallBtnW = (self.frame.size.width - 13*margin)/10;
    CGFloat btnH = (self.frame.size.height - 5*margin)/4;
    
    for (int i = 0; i < 10; i++) {
        XQKeyboardBtn *btn = self.btnArray[i];
        btn.frame = CGRectMake(2*margin + i*(smallBtnW + margin), margin, smallBtnW, btnH);
    }
    
    CGFloat margin2 = (self.frame.size.width - 8*margin - 9*smallBtnW)/2;
    for (int i = 10; i < 19; i++) {
        XQKeyboardBtn *btn = self.btnArray[i];
        btn.frame = CGRectMake(margin2 + (i-10)*(smallBtnW + margin), 2*margin + btnH, smallBtnW, btnH);
    }
    
    CGFloat margin3 = (self.frame.size.width - 9.5*smallBtnW - 6*margin)/4;
    self.trasitionWordBtn.frame = CGRectMake(margin3, 3*margin + 2*btnH, smallBtnW, btnH);
    
    self.deleteBtn.frame = CGRectMake(margin3*3 + 6*margin + 8*smallBtnW, 3*margin + 2*btnH, smallBtnW * 1.5, btnH);
    for (int i = 19; i<26; i++) {
        XQKeyboardBtn *btn = self.btnArray[i];
        btn.frame = CGRectMake(2*margin3 + smallBtnW + (i-19)*(smallBtnW + margin), 3*margin + 2*btnH, smallBtnW, btnH);
    }
    CGFloat bigBtnW = (self.frame.size.width - 5*margin)/4;
    self.numPadCheckBtn.frame = CGRectMake(margin, 4*margin + btnH*3, bigBtnW, btnH);
    XQKeyboardBtn *btn = [self.btnArray lastObject];
    btn.frame = CGRectMake(2*margin+bigBtnW, 4*margin + btnH*3, bigBtnW, btnH);
    self.symbolBtn.frame = CGRectMake(3*margin + 2*bigBtnW, 4*margin + btnH*3, bigBtnW, btnH);
    self.okBtn.frame = CGRectMake(4*margin + 3*bigBtnW, 4*margin + btnH*3, bigBtnW, btnH);
    
}

#pragma mark - XQKeyboardBtnDelegate
-(void)KeyboardBtnDidClick:(XQKeyboardBtn *)btn{
    if ([btn.titleLabel.text isEqualToString:@"空格"]) {
        self.responder.text = [self.responder.text stringByAppendingString:@" "];
    }else{
        if (self.trasitionWordBtn.selected) {
            self.responder.text = [self.responder.text stringByAppendingString:self.WORDArray[[self.btnArray indexOfObject:btn]]];
        }else{
            self.responder.text = [self.responder.text stringByAppendingString:self.wordArray[[self.btnArray indexOfObject:btn]]];
        }
    }
}

@end
