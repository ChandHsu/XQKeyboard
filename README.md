# XQKeyboard
自定义密码键盘,一键即可集成<br>
支持 iPhone 和 iPad,支持横竖屏<br>
效果预览:☆☆☆☆☆☆☆☆☆☆☆☆☆☆<br>
![](https://github.com/qianggeProgramer/XQKeyboard/blob/master/1.gif)
![](https://github.com/qianggeProgramer/XQKeyboard/blob/master/2.gif)

## 用法:
* 导入主头文件：`#import "XQKeyboard.h"`<br>
```objc
XQKeyboard *keyBoard = [[XQKeyboard alloc] init];
textField.inputView = keyBoard;
```

* 支持随机键盘:
```objc
keyBoard.random = YES;
```

* 支持数字键盘限制:
```objc
keyBoard.numberLimit = YES;
```
## 问题
### 1.iOS7 不弹出键盘
### 2.iOS12 高度不稳定
以上问题均为系统响应机制的变化导致,咱们只能去适配它,如果使用下面两个方法初始化,则可避免此类问题:
```objc
+ (instancetype)keyboard;
+ (instancetype)keyboardWithHeight:(CGFloat)height;
```

其中有很多不足的地方,如果有什么建议或意见,还请一起交流探讨,大家共同进步,我的联系方式  QQ:296646879<br>
您的每一次 Star 都是给我的鼓励,如果对你有帮助,请 Star 或 Fork 一下.☺☺☺☺☺
