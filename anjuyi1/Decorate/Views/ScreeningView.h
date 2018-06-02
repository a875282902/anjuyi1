//
//  ScreeningView.h
//  anjuyi1
//
//  Created by 李 on 2018/5/31.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScreeningView : UIView

@property (nonatomic,strong)NSMutableArray *typeArr;
@property (nonatomic,strong)NSMutableArray *dataArr;

- (void)show;

- (void)hidden;

@end
