//
//  XQKeyboardTool.m
//  XQKeyboard
//
//  Created by Apple on 15/12/14.
//  Copyright © 2015年 xuqiang. All rights reserved.
//

#import "XQKeyboardTool.h"

@implementation XQKeyboardTool

+ (NSRange)rangeFromTextRange:(UITextRange *)textRange inTextField:(UITextField *)textField{
    
    UITextPosition* beginning = textField.beginningOfDocument;
    UITextPosition* start = textRange.start;
    UITextPosition* end = textRange.end;
    
    const NSInteger location = [textField offsetFromPosition:beginning toPosition:start];
    const NSInteger length = [textField offsetFromPosition:start toPosition:end];
    
    return NSMakeRange(location, length);
}

+ (void)setSelectedRange:(NSRange)range ofTextField:(UITextField *)textField{
    
    UITextPosition* beginning = textField.beginningOfDocument;
    UITextPosition* startPosition = [textField positionFromPosition:beginning offset:range.location];
    UITextPosition* endPosition = [textField positionFromPosition:beginning offset:range.location + range.length];
    UITextRange* selectionRange = [textField textRangeFromPosition:startPosition toPosition:endPosition];
    [textField setSelectedTextRange:selectionRange];
}

+ (void)appendString:(NSString *)newString forResponder :(UITextField *)textField{
    
    NSRange selectRange = [XQKeyboardTool rangeFromTextRange:textField.selectedTextRange inTextField:textField];
    
    NSString *prefixStr = [textField.text substringToIndex:selectRange.location];
    NSString *suffixStr = [textField.text substringWithRange:NSMakeRange(selectRange.length+selectRange.location, textField.text.length-selectRange.length-selectRange.location)];
    
    textField.text = [NSString stringWithFormat:@"%@%@%@",prefixStr,newString,suffixStr];
    
    NSRange newRange = NSMakeRange(selectRange.location+1, 0);
    
    [self setSelectedRange:newRange ofTextField:textField];
}

+(void)deleteStringForResponder:(UITextField *)textField{
    
    NSRange selectRange = [XQKeyboardTool rangeFromTextRange:textField.selectedTextRange inTextField:textField];
    
    if (selectRange.location==0&&selectRange.length==0) return;
    
    NSString *prefixStr;
    NSString *suffixStr = [textField.text substringWithRange:NSMakeRange(selectRange.length+selectRange.location, textField.text.length-selectRange.length-selectRange.location)];
    NSRange newRange;
    
    if (selectRange.length==0) {
        prefixStr = [textField.text substringToIndex:selectRange.location-1];
        textField.text = [prefixStr stringByAppendingString:suffixStr];
        newRange = NSMakeRange(prefixStr.length, 0);
    }else{
        textField.text = [textField.text stringByReplacingOccurrencesOfString:[textField.text substringWithRange:selectRange] withString:@""];
        newRange = NSMakeRange(selectRange.location, 0);
    }
    
    [self setSelectedRange:newRange ofTextField:textField];
    
}


@end
