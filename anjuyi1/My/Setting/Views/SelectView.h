//
//  SelectCity.h
//  anjuyi1
//
//  Created by apple on 2018/6/21.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SelectView;

@protocol SelectViewDelegate <NSObject>

- (void)selectViewWithInfo:(NSDictionary *)info view:(SelectView *)selectView;

@end

@interface SelectView : UIView

@property (nonatomic,strong)NSMutableArray *dataArr;

- (void)show;

- (void)hidden;

@property (nonatomic,weak)id<SelectViewDelegate>delegate;


@end
