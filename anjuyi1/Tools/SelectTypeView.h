//
//  SelectTypeView.h
//  anjuyi1
//
//  Created by apple on 2018/8/29.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SelectTypeView;

@protocol SelectTypeViewDelegate <NSObject>

- (void)selectTypeWithInfo:(NSDictionary *)info view:(SelectTypeView *)selectView;

@end

@interface SelectTypeView : UIView

@property (nonatomic,strong)NSArray *dataArr;

- (void)show;

- (void)hidden;

@property (nonatomic,weak)id<SelectTypeViewDelegate>delegate;
@end
