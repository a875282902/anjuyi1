//
//  NSString+Predicate.m
//  iOS-Category
//
//  Created by 庄BB的MacBook on 16/7/20.
//  Copyright © 2016年 BBFC. All rights reserved.
//

#import "NSString+Predicate.h"

@implementation NSString (Predicate)
- (BOOL) isValidMobileNumber {
    NSString* const MOBILE = @"^1(3|4|5|7|8)\\d{9}$";
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [predicate evaluateWithObject:self];
}

- (BOOL) isValidVerifyCode
{
    NSString *pattern = @"^[0-9]{4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [predicate evaluateWithObject:self];
}

- (BOOL) isValidRealName

{
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{2,8}$";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    
    return [predicate evaluateWithObject:self];
}

- (BOOL) isOnlyChinese
{
    NSString * chineseTest=@"^[\u4e00-\u9fa5]{0,}$";
    NSPredicate*chinesePredicate=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",chineseTest];
    return [chinesePredicate evaluateWithObject:self];
}


- (BOOL) isValidBankCardNumber {
    NSString* const BANKCARD = @"^(\\d{16}|\\d{19})$";
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", BANKCARD];
    return [predicate evaluateWithObject:self];
}


- (BOOL) isValidEmail
{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:self];
    
}
- (BOOL) validateNickName
{
    NSString *userNameRegex = @"^[A-Za-z0-9\u4e00-\u9fa5]{1,24}+$";
    
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    
    return [userNamePredicate evaluateWithObject:self];
}
- (BOOL) isValidAlphaNumberPassword
{
    NSString *regex = @"^(?!\\d+$|[a-zA-Z]+$)\\w{0,100}$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [identityCardPredicate evaluateWithObject:self];
}

- (BOOL)isValidNumberAndLetterPassword{
    
    //数字条件
    NSRegularExpression *tNumRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    //符合数字条件的有几个字节
    NSUInteger tNumMatchCount = [tNumRegularExpression numberOfMatchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length)];
    
    //英文字条件
    NSRegularExpression *tLetterRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    //符合英文字条件的有几个字节
    NSUInteger tLetterMatchCount = [tLetterRegularExpression numberOfMatchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length)];
    
    if (tNumMatchCount == self.length ) {
        //全部符合数字，表示沒有英文
        return YES;
    } else if (tLetterMatchCount == self.length ) {
        //全部符合英文，表示沒有数字
        return YES;
    } else if (tNumMatchCount + tLetterMatchCount == self.length ) {
        //符合英文和符合数字条件的相加等于密码长度
        return YES;
    } else {
        return NO;
        //可能包含标点符号的情況，或是包含非英文的文字，这里再依照需求详细判断想呈现的错误
    }
}


- (BOOL) isValidIdentifyFifteen
{
    NSString * identifyTest=@"^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$";
    NSPredicate*identifyPredicate=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",identifyTest];
    return [identifyPredicate evaluateWithObject:self];
}

- (BOOL) isValidIdentifyEighteen
{
    NSString * identifyTest=@"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X)$";
    NSPredicate*identifyPredicate=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",identifyTest];
    return [identifyPredicate evaluateWithObject:self];
}


- (BOOL) isOnlyNumber
{
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < self.length) {
        NSString * string = [self substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    
    return res;
}


@end
