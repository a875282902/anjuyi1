//
//  DataView.h
//  anjuyi1
//
//  Created by 李 on 2018/6/8.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DateViewDelegate <NSObject>

- (void)selectCurrentTime:(NSString *)time;

@end

@interface DateView : UIView

@property (nonatomic,weak)id<DateViewDelegate>delegate;

- (void)show;

- (void)hidden;

@end
