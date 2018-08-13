//
//  ChannelView.h
//  anjuyi1
//
//  Created by apple on 2018/8/10.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChannelViewDelegate <NSObject>

- (void)clickBtnIndex:(NSInteger)index; //声明协议方法

@end

@interface ChannelView : UIView

@property (nonatomic,strong)NSArray *cateArr;

@property (nonatomic,weak)id<ChannelViewDelegate>delegate;

- (void)selectBtnIndex:(NSInteger)index;

@end
