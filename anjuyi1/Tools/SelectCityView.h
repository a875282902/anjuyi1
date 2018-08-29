//
//  SelectCityView.h
//  anjuyi1
//
//  Created by apple on 2018/8/29.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SelectCityView;

@protocol SelectCityViewDelegate <NSObject>

- (void)sureProvince:(NSDictionary *)province city:(NSDictionary *)city area:(NSDictionary *)area;

@end
@interface SelectCityView : UIView
- (void)show;

- (void)hidden;

@property (nonatomic,weak)id<SelectCityViewDelegate>delegate;
@end
