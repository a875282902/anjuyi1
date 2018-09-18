//
//  ScreeningView.h
//  anjuyi1
//
//  Created by 李 on 2018/5/31.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScreeningViewDelegate <NSObject>

- (void)sureScreenData:(NSMutableArray *)sureArr; //声明协议方法

@end

@interface ScreeningView : UIView

@property (nonatomic,strong)NSMutableArray *typeArr;
@property (nonatomic,strong)NSMutableArray *dataArr;

@property (nonatomic,weak)id<ScreeningViewDelegate>delegate;

- (void)show;

- (void)hidden;

@end
