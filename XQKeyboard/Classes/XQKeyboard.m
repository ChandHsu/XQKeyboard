//
//  XQKeyboard.m
//  XQKeyboard
//
//  Created by 徐强 on 15/8/15.
//  Copyright (c) 2015年 xuqiang. All rights reserved.
//

#import "XQKeyboard.h"

#define iPhoneX ([UIScreen mainScreen].bounds.size.height==812||[UIScreen mainScreen].bounds.size.width == 812)

#define margin 5


@interface UIButton (XQExtension)

- (void)setCornerCutType:(UIRectCorner)corner;
- (void)resetCornerCut;

@end

@interface XQKeyboardBasePad:UIView

@property (nonatomic, weak  ) UITextField *responder;
@property (nonatomic, weak  ) UIButton    *deleteBtn;
@property (nonatomic, weak  ) UIButton    *okBtn;
@property (nonatomic, strong) NSMutableArray *btnArray;

- (void)deleteBtnClick;
- (void)okBtnClick;

@end

@interface XQKeyboardTool : NSObject

+ (NSRange)rangeFromTextRange:(UITextRange *)textRange inTextField:(UITextField *)textField;
+ (UITextRange *)textRangeFromRange:(NSRange)range inTextField:(UITextField *)textField;
+ (void)setSelectedRange:(NSRange)range ofTextField:(UITextField *)textField;
+ (void)appendString:(NSString *)newString forResponder:(UITextField *)textField;
+ (void)deleteStringForResponder:(UITextField *)textField;

@end

@class XQKeyboardBtn;
@protocol XQKeyboardBtnDelegate <NSObject>

@required
- (void)keyboardBtnDidClick:(XQKeyboardBtn *)btn;

@end

@interface XQKeyboardBtn : UIButton

@property (nonatomic, assign) id <XQKeyboardBtnDelegate> delegate;

+ (XQKeyboardBtn *)buttonWithTitle:(NSString *)title tag:(NSInteger)tag  delegate:(id)delegate;

@end

@protocol XQKeyboardNumPadDelegate  <NSObject>

@required
- (void)keyboardNumPadDidClickSwitchBtn:(UIButton *)btn;

@end

typedef enum{
    XQKeyboardNumPadDefault,
    XQKeyboardNumPadOnly
} XQKeyboardNumPadType;

@interface XQKeyboardNumPad : XQKeyboardBasePad <XQKeyboardBtnDelegate>

@property (nonatomic, assign) BOOL random;
@property (nonatomic, assign) id <XQKeyboardNumPadDelegate> delegate;
@property (nonatomic, strong) NSArray *numArray;
@property (nonatomic, assign) NSRange selectedRange;
@property (nonatomic, assign) XQKeyboardNumPadType padType;

@end

@protocol XQKeyboardSymbolPadDelegate  <NSObject>

@required
- (void)keyboardSymbolPadDidClickSwitchBtn:(UIButton *)btn;

@end

@interface XQKeyboardSymbolPad : XQKeyboardBasePad <XQKeyboardBtnDelegate>

@property (nonatomic, assign) BOOL random;
@property (nonatomic, assign) id <XQKeyboardSymbolPadDelegate> delegate;
@property (nonatomic, strong) NSArray *symbolArray;
@property (nonatomic, weak)   UIButton *numPadCheckBtn;
@property (nonatomic, weak)   UIButton *wordBtn;

@end

@protocol XQKeyboardWordPadDelegate <NSObject>

@required
- (void)keyboardWordPadDidClickSwitchBtn:(UIButton *)btn;

@end

@interface XQKeyboardWordPad : XQKeyboardBasePad <XQKeyboardBtnDelegate>

@property (nonatomic, assign) BOOL random;
@property (nonatomic, assign) id <XQKeyboardWordPadDelegate> delegate;
@property (nonatomic, strong) NSArray  *wordArray;
@property (nonatomic, strong) NSArray  *WORDArray;
@property (nonatomic, weak)   UIButton *trasitionWordBtn;
@property (nonatomic, weak)   UIButton *numPadCheckBtn;
@property (nonatomic, weak)   UIButton *symbolBtn;

@end

@implementation XQKeyboardBasePad

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return self;
}
- (UITextField *)responder{
    //    if (!_responder) {  // 防止多个输入框采用同一个inputview
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *firstResponder = [keyWindow valueForKey:@"firstResponder"];
    _responder = (UITextField *)firstResponder;
    //    }
    return _responder;
}
- (void)deleteBtnClick{
    [XQKeyboardTool deleteStringForResponder:self.responder];
}
- (void)okBtnClick{
    BOOL canReturn = YES;
    if ([self.responder respondsToSelector:@selector(textFieldShouldReturn:)]) {
        canReturn = [self.responder.delegate textFieldShouldReturn:self.responder];
    }
    
    if (!canReturn) return;
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

@end

@implementation XQKeyboardTool

+ (NSRange)rangeFromTextRange:(UITextRange *)textRange inTextField:(UITextField *)textField{
    
    UITextPosition* beginning = textField.beginningOfDocument;
    UITextPosition* start = textRange.start;
    UITextPosition* end = textRange.end;
    
    const NSInteger location = [textField offsetFromPosition:beginning toPosition:start];
    const NSInteger length = [textField offsetFromPosition:start toPosition:end];
    
    return NSMakeRange(location, length);
}
+ (UITextRange *)textRangeFromRange:(NSRange)range inTextField:(UITextField *)textField{
    UITextPosition *beginning = textField.beginningOfDocument;
    UITextPosition *startPosition = [textField positionFromPosition:beginning offset:range.location];
    UITextPosition *endPosition = [textField positionFromPosition:beginning offset:range.location + range.length];
    UITextRange* selectionRange = [textField textRangeFromPosition:startPosition toPosition:endPosition];
    return selectionRange;
}
+ (void)setSelectedRange:(NSRange)range ofTextField:(UITextField *)textField{
    
     UITextRange *selectionRange = [self textRangeFromRange:range inTextField:textField];
    [textField setSelectedTextRange:selectionRange];
}
+ (void)appendString:(NSString *)newString forResponder :(UITextField *)textField{
    
    NSRange selectRange = [XQKeyboardTool rangeFromTextRange:textField.selectedTextRange inTextField:textField];
    
    BOOL shouldChange = YES;
    if ([textField.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        shouldChange = [textField.delegate textField:textField shouldChangeCharactersInRange:selectRange replacementString:newString];
    }
    if (!shouldChange) return;
    
    [textField insertText:newString];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:textField userInfo:nil];
}
+ (void)deleteStringForResponder:(UITextField *)textField{
    
    [textField deleteBackward];
}

@end

@implementation UIButton (XQExtension)

- (void)setCornerCutType:(UIRectCorner)corner{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.layer.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(30, 30)];
    CAShapeLayer * maskLayer = [CAShapeLayer new];
    maskLayer.frame = self.layer.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
- (void)resetCornerCut{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.layer.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(1, 1)];
    CAShapeLayer * maskLayer = [CAShapeLayer new];
    maskLayer.frame = self.layer.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = true;
}

@end

@implementation XQKeyboardBtn

+ (XQKeyboardBtn *)buttonWithTitle:(NSString *)title tag:(NSInteger)tag delegate:(id)delegate{
    XQKeyboardBtn *btn = [XQKeyboardBtn buttonWithType:UIButtonTypeCustom];
    btn.tag = tag;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:btn action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [btn setBackgroundImage:[UIImage imageNamed:@"images.bundle/keypadBtn"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"images.bundle/keypadBtnHighLighted"] forState:UIControlStateHighlighted];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    btn.delegate = delegate;
    
    return btn;
}
- (void)btnClick:(XQKeyboardBtn *)btn{
    if ([self.delegate respondsToSelector:@selector(keyboardBtnDidClick:)]) {
        [self.delegate keyboardBtnDidClick:btn];
    }
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.frame = self.bounds;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

@end

@implementation XQKeyboardSymbolPad

- (NSArray *)symbolArray{
    if (!_symbolArray) {
        _symbolArray = @[@"*",@"/",@":",@";",@"(",@")",@"[",@"]",@"$",@"=",@"!",@"^",@"&",@"%",@"+",@"-",@"￥",@"?",@"{",@"}",@"#",@"_",@"\\",@"|",@"~",@"`",@"∑",@"€",@"£",@"。"];
    }
    return _symbolArray;
}
- (void)setRandom:(BOOL)random{
    _random = random = random;
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
    
}
- (void)switchBtnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(keyboardSymbolPadDidClickSwitchBtn:)]) {
        [self.delegate keyboardSymbolPadDidClickSwitchBtn:btn];
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize currentSize = self.bounds.size;
    int padMargin = 0;
    UIDeviceOrientation currentOri = [UIDevice currentDevice].orientation;
    if (iPhoneX && currentOri != UIDeviceOrientationPortrait) {
        currentSize = CGSizeMake(currentSize.width-60, currentSize.height);
        padMargin = currentOri == UIDeviceOrientationLandscapeLeft ||  currentOri == UIDeviceOrientationLandscapeRight? 30 : 0;
    }
    
    CGFloat btnW = (currentSize.width - 13*margin)/10;
    CGFloat btnH = (currentSize.height - 5*margin)/4;
    
    for (int i = 0; i < 30; i++) {
        XQKeyboardBtn *btn = self.btnArray[i];
        btn.frame = CGRectMake(padMargin + 2*margin + (i%10)*(btnW + margin), margin + (i/10)*(margin + btnH), btnW, btnH);
    }
    
    CGFloat bigBtnW = (currentSize.width - 7*margin)/4;
    self.numPadCheckBtn.frame = CGRectMake(padMargin + 2*margin, 4*margin + btnH*3, bigBtnW, btnH);
    self.wordBtn.frame = CGRectMake(padMargin + 3*margin+bigBtnW, 4*margin + btnH*3, bigBtnW, btnH);
    self.deleteBtn.frame = CGRectMake(padMargin + 4*margin + 2*bigBtnW, 4*margin + btnH*3, bigBtnW, btnH);
    self.okBtn.frame = CGRectMake(padMargin + 5*margin + 3*bigBtnW, 4*margin + btnH*3, bigBtnW, btnH);
    
    if (iPhoneX && currentOri == UIDeviceOrientationPortrait) {
        [self.numPadCheckBtn setCornerCutType:UIRectCornerBottomLeft];
        [self.okBtn setCornerCutType:UIRectCornerBottomRight];
    }else if(iPhoneX){
        [self.numPadCheckBtn resetCornerCut];
        [self.okBtn resetCornerCut];
    }
}

#pragma mark - XQKeyboardBtnDelegate
-(void)keyboardBtnDidClick:(XQKeyboardBtn *)btn{
    
    [XQKeyboardTool appendString:btn.titleLabel.text forResponder:self.responder];
}

@end

@implementation XQKeyboardNumPad

- (NSArray *)numArray{
    if (!_numArray) {
        _numArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",@"@",@"."];
    }
    return _numArray;
}
- (void)setRandom:(BOOL)random{
    _random = random = random;
    if (random) {
        
        NSMutableArray *newArray = [NSMutableArray arrayWithArray:self.numArray];
        for(int i = 0; i< self.numArray.count; i++)
        {
            int m = (arc4random() % (self.numArray.count - i)) + i;
            [newArray exchangeObjectAtIndex:i withObjectAtIndex: m];
        }
        self.numArray = newArray;
        [self removeAllBtns];
        [self addControl];
    }
    
}
- (void)switchBtnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(keyboardNumPadDidClickSwitchBtn:)]) {
        [self.delegate keyboardNumPadDidClickSwitchBtn:btn];
    }
}
- (void)setPadType:(XQKeyboardNumPadType)padType{
    
    if (padType == XQKeyboardNumPadOnly) {
        self.numArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    }else{
        self.numArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",@"@",@"."];
    }
    if (_padType != padType) {
        _padType = padType;
        [self removeAllBtns];
        [self addControl];
    }
}
- (void)removeAllBtns{
    for (UIButton *btn in self.subviews) {
        [btn removeFromSuperview];
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
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"images.bundle/keypadDeleteBtn"] forState:UIControlStateNormal];
    [self addSubview:deleteBtn];
    deleteBtn.tag = 11;
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [okBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self addSubview:okBtn];
    [okBtn setBackgroundImage:[UIImage imageNamed:@"images.bundle/keypadLongBtn"] forState:UIControlStateNormal];
    okBtn.tag = 15;
    
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
    [self.btnArray addObject:deleteBtn];
    [self.btnArray addObject:btn0];
    [self.btnArray addObject:okBtn];
    
    
    if (self.padType == XQKeyboardNumPadDefault) {
        
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
        
        [wordSwitchBtn addTarget:self action:@selector(switchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [symbolSwitchBtn addTarget:self action:@selector(switchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.btnArray addObject:btnAT];
        [self.btnArray addObject:pointBtn];
        [self.btnArray addObject:symbolSwitchBtn];
        [self.btnArray addObject:wordSwitchBtn];
        
        for (int i = 11; i<16; i++) {
            UIButton *btn = self.btnArray[i];
            btn.layer.cornerRadius = 5;
            btn.layer.masksToBounds = YES;
        }
    }else if(self.padType == XQKeyboardNumPadOnly){
        for (int i = 0; i<self.btnArray.count; i++) {
            UIButton *btn = self.btnArray[i];
            btn.tag = i;
        }
    }
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGSize currentSize = self.bounds.size;
    int padMargin = 0;
    UIDeviceOrientation currentOri = [UIDevice currentDevice].orientation;
    if (iPhoneX && currentOri != UIDeviceOrientationPortrait) {
        currentSize = CGSizeMake(currentSize.width-60, currentSize.height);
        padMargin = currentOri == UIDeviceOrientationLandscapeLeft ||  currentOri == UIDeviceOrientationLandscapeRight? 30 : 0;
    }
    
    if (self.padType == XQKeyboardNumPadOnly) {
        
        int rowNum = 4;//行
        int lineNum = 3;//列
        
        UIButton *btnTag8 = self.btnArray[8];
        UIButton *btnTag10 = self.btnArray[9];
        if (currentOri != UIDeviceOrientationPortrait ) {
            rowNum = 3;
            lineNum = 4;
            if (btnTag8.tag==8) {
                btnTag8.tag = 9;
                btnTag10.tag = 8;
            }
        }else{
            if (btnTag8.tag!=8) {
                btnTag8.tag = 8;
                btnTag10.tag = 9;
            }
        }
        
        CGFloat btnW = (currentSize.width - (lineNum+1)*margin)/lineNum;
        CGFloat btnH = (currentSize.height - (rowNum+1)*margin)/rowNum;
        
        for (XQKeyboardBtn *btn in self.btnArray) {
            btn.frame = CGRectMake(padMargin +margin + btn.tag % lineNum * (btnW + margin), margin + btn.tag / lineNum * (btnH + margin), btnW, btnH);
            if ((btn.tag == (rowNum-1)*lineNum)  && iPhoneX) {
                if (currentOri == UIDeviceOrientationPortrait) [btn setCornerCutType:UIRectCornerBottomLeft];
                else [btn resetCornerCut];
            }else if (btn.tag == 11 && iPhoneX){
                if (currentOri == UIDeviceOrientationPortrait) [btn setCornerCutType:UIRectCornerBottomRight];
                else [btn resetCornerCut];
            }
        }
    }else{
        
        CGFloat btnW = (currentSize.width - 5*margin)/4;
        CGFloat btnH = (currentSize.height - 5*margin)/4;
        for (XQKeyboardBtn *btn in self.btnArray) {
            btn.frame = CGRectMake(padMargin +margin + btn.tag % 4 * (btnW + margin), margin + btn.tag / 4 * (btnH + margin), btnW, btnH);
            if (btn.tag == 12 && iPhoneX) {
                if (currentOri == UIDeviceOrientationPortrait) [btn setCornerCutType:UIRectCornerBottomLeft];
                else [btn resetCornerCut];
            }else if (btn.tag == 15 && iPhoneX){
                if (currentOri == UIDeviceOrientationPortrait) [btn setCornerCutType:UIRectCornerBottomRight];
                else [btn resetCornerCut];
            }
        }
    }
}
#pragma mark - XQKeyboardBtnDelegate
-(void)keyboardBtnDidClick:(XQKeyboardBtn *)btn{
    if (btn.tag % 4 == 3) return;
    
    [XQKeyboardTool appendString:btn.titleLabel.text forResponder:self.responder];
}

@end

@implementation XQKeyboardWordPad

- (NSArray *)wordArray{
    if (!_wordArray) {
        _wordArray = @[@"q",@"w",@"e",@"r",@"t",@"y",@"u",@"i",@"o",@"p",@"a",@"s",@"d",@"f",@"g",@"h",@"j",@"k",@"l",@"z",@"x",@"c",@"v",@"b",@"n",@"m"];
    }
    return _wordArray;
}
- (void)setRandom:(BOOL)random{
    _random = random = random;
    if (random) {
        
        NSMutableArray *newArray = [NSMutableArray arrayWithArray:self.wordArray];
        for(int i = 0; i< self.wordArray.count; i++)
        {
            int m = (arc4random() % (self.wordArray.count - i)) + i;
            [newArray exchangeObjectAtIndex:i withObjectAtIndex: m];
        }
        self.wordArray = newArray;
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
    for (int i = 0; i< 26; i++) {// 添加26个英文字母
        XQKeyboardBtn *btn = [XQKeyboardBtn buttonWithTitle:self.wordArray[i] tag:i delegate:self];
        [btnArray addObject:btn];
        [self addSubview:btn];
    }
    self.btnArray = btnArray;
    
    XQKeyboardBtn *blankBtn = [XQKeyboardBtn buttonWithTitle:@"空格" tag:26 delegate:self];
    [btnArray addObject:blankBtn];
    [self addSubview:blankBtn];
    
    UIButton *trasitionWordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [trasitionWordBtn setImage:[UIImage imageNamed:@"images.bundle/trasition_normal"] forState:UIControlStateNormal];
    [trasitionWordBtn setImage:[UIImage imageNamed:@"images.bundle/trasition_highlighted"] forState:UIControlStateSelected];
    
    [trasitionWordBtn addTarget:self action:@selector(trasitionWord:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:trasitionWordBtn];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"images.bundle/keypadDeleteBtn2"] forState:UIControlStateNormal];
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
            [btn setTitle:[btn.titleLabel.text uppercaseString] forState:UIControlStateNormal];
        }
    }else{
        for (int i = 0; i<26; i++) {
            XQKeyboardBtn *btn = self.btnArray[i];
            [btn setTitle:[btn.titleLabel.text lowercaseString] forState:UIControlStateNormal];
        }
    }
    
}
- (void)switchBtnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(keyboardWordPadDidClickSwitchBtn:)]) {
        [self.delegate keyboardWordPadDidClickSwitchBtn:btn];
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGSize currentSize = self.bounds.size;
    int padMargin = 0;
    UIDeviceOrientation currentOri = [UIDevice currentDevice].orientation;
    if (iPhoneX && currentOri != UIDeviceOrientationPortrait) {
        currentSize = CGSizeMake(currentSize.width-60, currentSize.height);
        padMargin = currentOri == UIDeviceOrientationLandscapeLeft ||  currentOri == UIDeviceOrientationLandscapeRight? 30 : 0;
    }
    
    CGFloat smallBtnW = (currentSize.width - 13*margin)/10;
    CGFloat btnH = (currentSize.height - 5*margin)/4;
    
    for (int i = 0; i < 10; i++) {
        XQKeyboardBtn *btn = self.btnArray[i];
        btn.frame = CGRectMake(padMargin + 2*margin + i*(smallBtnW + margin), margin, smallBtnW, btnH);
    }
    
    CGFloat margin2 = (currentSize.width - 8*margin - 9*smallBtnW)/2;
    for (int i = 10; i < 19; i++) {
        XQKeyboardBtn *btn = self.btnArray[i];
        btn.frame = CGRectMake(padMargin + margin2 + (i-10)*(smallBtnW + margin), 2*margin + btnH, smallBtnW, btnH);
    }
    
    CGFloat margin3 = (currentSize.width - 9.5*smallBtnW - 6*margin)/4;
    self.trasitionWordBtn.frame = CGRectMake(padMargin + margin3, 3*margin + 2*btnH, smallBtnW, btnH);
    
    self.deleteBtn.frame = CGRectMake(padMargin + margin3*3 + 6*margin + 8*smallBtnW, 3*margin + 2*btnH, smallBtnW*1.5, btnH);
    for (int i = 19; i<26; i++) {
        XQKeyboardBtn *btn = self.btnArray[i];
        btn.frame = CGRectMake(padMargin + 2*margin3 + smallBtnW + (i-19)*(smallBtnW + margin), 3*margin + 2*btnH, smallBtnW, btnH);
    }
    CGFloat bigBtnW = (currentSize.width - 5*margin)/4;
    self.numPadCheckBtn.frame = CGRectMake(padMargin + margin, 4*margin + btnH*3, bigBtnW, btnH);
    XQKeyboardBtn *btn = [self.btnArray lastObject];
    btn.frame = CGRectMake(padMargin + 2*margin+bigBtnW, 4*margin + btnH*3, bigBtnW, btnH);
    self.symbolBtn.frame = CGRectMake(padMargin + 3*margin + 2*bigBtnW, 4*margin + btnH*3, bigBtnW, btnH);
    self.okBtn.frame = CGRectMake(padMargin + 4*margin + 3*bigBtnW, 4*margin + btnH*3, bigBtnW, btnH);
    
    if (iPhoneX) {
        if (currentOri == UIDeviceOrientationPortrait) {
            [self.numPadCheckBtn setCornerCutType:UIRectCornerBottomLeft];
            [self.okBtn setCornerCutType:UIRectCornerBottomRight];
        }else{
            [self.numPadCheckBtn resetCornerCut];
            [self.okBtn resetCornerCut];
        }
    }
    
}

#pragma mark - XQKeyboardBtnDelegate
- (void)keyboardBtnDidClick:(XQKeyboardBtn *)btn{
    
    NSString *newText = btn.titleLabel.text;
    if ([btn.titleLabel.text isEqualToString:@"空格"]) {
        newText = @" ";
    }
    
    [XQKeyboardTool appendString:newText forResponder:self.responder];
}

@end

@interface XQKeyboard ()<XQKeyboardNumPadDelegate,XQKeyboardWordPadDelegate,XQKeyboardSymbolPadDelegate>

@property (nonatomic, strong) XQKeyboardNumPad    *numPad;
@property (nonatomic, strong) XQKeyboardWordPad   *wordPad;
@property (nonatomic, strong) XQKeyboardSymbolPad *symbolPad;

@end

@implementation XQKeyboard

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:116/255.0 green:144/255.0 blue:194/255.0 alpha:0.2];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        XQKeyboardNumPad *numPad = [[XQKeyboardNumPad alloc] initWithFrame:self.bounds];
        numPad.delegate = self;
        numPad.padType = XQKeyboardNumPadOnly;
        self.numPad = numPad;
        [self addSubview:numPad];
    }
    return self;
}
- (XQKeyboardNumPad *)numPad{
    if (!_numPad) {
        _numPad = [[XQKeyboardNumPad alloc] initWithFrame:self.bounds];
        if (self.random) _wordPad.random = YES;
        _numPad.delegate = self;
    }
    return _numPad;
}
- (XQKeyboardWordPad *)wordPad{
    if (!_wordPad) {
        _wordPad = [[XQKeyboardWordPad alloc] initWithFrame:self.bounds];
        if (self.random) _wordPad.random = YES;
        _wordPad.delegate = self;
    }
    return _wordPad;
}
- (XQKeyboardSymbolPad *)symbolPad{
    if (!_symbolPad) {
        _symbolPad =  [[XQKeyboardSymbolPad alloc] initWithFrame:self.bounds];
        if (self.random) _symbolPad.random = YES;
        _symbolPad.delegate = self;
    }
    return _symbolPad;
}
- (void)keyboardNumPadDidClickSwitchBtn:(UIButton *)btn{
    if ([btn.titleLabel.text isEqualToString:@"ABC"]) {
        [self addSubview:self.wordPad];
        self.wordPad.frame = self.bounds;
        [self.numPad removeFromSuperview];
    }else{
        [self addSubview:self.symbolPad];
        self.symbolPad.frame = self.bounds;
        [self.numPad removeFromSuperview];
    }
}
- (void)keyboardWordPadDidClickSwitchBtn:(UIButton *)btn{
    if ([btn.titleLabel.text isEqualToString:@"123"]) {
        [self addSubview:self.numPad];
        self.numPad.frame = self.bounds;
        [self.wordPad removeFromSuperview];
    }else{
        [self addSubview:self.symbolPad];
        self.symbolPad.frame = self.bounds;
        [self.wordPad removeFromSuperview];
    }
}
- (void)keyboardSymbolPadDidClickSwitchBtn:(UIButton *)btn{
    if ([btn.titleLabel.text isEqualToString:@"123"]) {
        [self addSubview:self.numPad];
        self.numPad.frame = self.bounds;
        [self.symbolPad removeFromSuperview];
    }else{
        [self addSubview:self.wordPad];
        self.wordPad.frame = self.bounds;
        [self.symbolPad removeFromSuperview];
    }
}
- (void)setRandom:(BOOL)random{
    _random = random;
    self.numPad.random = random;
}
- (void)setNumberLimit:(BOOL)numberLimit{
    _numberLimit = numberLimit;
    self.numPad.padType = numberLimit?XQKeyboardNumPadOnly:XQKeyboardNumPadDefault;
}

@end


