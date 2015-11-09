# XQKeyboard
##自定义密码键盘,一键即可集成<br>
##效果预览:
![](https://github.com/qianggeProgramer/XQKeyboard/blob/master/1.gif)
![](https://github.com/qianggeProgramer/XQKeyboard/blob/master/2.gif)

##用法:
* 导入主头文件：`#import "XQKeyboard.h"`<br>
```objc

    XQKeyboard *keyBoard = [[XQKeyboard alloc] init];
    textField.inputView = keyBoard;

```

###支持随机键盘:
```objc
    keyBoard.random = NO;
```
