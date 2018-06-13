//
//  ViewHelps.m
//  Demo_1网络练习
//
//  Created by Micheal on 15/10/22.
//  Copyright © 2015年 Medalands. All rights reserved.
//

#import "ViewHelps.h"

@implementation ViewHelps

+ (void)showHUDWithText:(NSString *)message{
    
    [[self class] showHUDWithText:message completionBlock:nil];
}

+ (void)showHUDWithText:(NSString *)message
        completionBlock:(void (^)(void))completionBlock{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:window];
    
    [window addSubview:hud];
    
    [hud setMode:MBProgressHUDModeCustomView];
    
    [hud setDetailsLabelText:message];
    
    [hud show:YES];
    
    [hud hide:YES afterDelay:2];
    
    hud.completionBlock = completionBlock;
}

@end
