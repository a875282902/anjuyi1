//
//  ScreeningBar.h
//  anjuyi1
//
//  Created by 李 on 2018/5/31.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScreeningBarDelegate <NSObject>

- (void)selectIndex:(NSInteger)index; //声明协议方法

@end

@interface ScreeningBar : UIView

@property (nonatomic,weak)id<ScreeningBarDelegate>delegate;

@end
