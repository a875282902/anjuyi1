//
//  SuspensionButton.h
//  有家云宅
//
//  Created by 李 on 17/3/22.
//  Copyright © 2017年 有家. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SuspensionButton;

@protocol SuspensionButtonDelegate <NSObject>

- (void)showProcess;

@end

@interface SuspensionButton : UIView
@property (nonatomic,weak)id<SuspensionButtonDelegate>delegate;
@end
