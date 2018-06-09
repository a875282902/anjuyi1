//
//  StandardView.h
//  anjuyi1
//
//  Created by 李 on 2018/5/31.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StandardView;

@protocol StandardViewDelegate <NSObject>

- (void)sureBuyWithDictionary:(NSDictionary *)dic;

@end

@interface StandardView : UIView

@property (nonatomic,strong)NSMutableArray *typeArr;
@property (nonatomic,strong)NSMutableArray *dataArr;

- (void)show;

- (void)hidden;

@property (nonatomic,weak)id<StandardViewDelegate>delegate;

@end
