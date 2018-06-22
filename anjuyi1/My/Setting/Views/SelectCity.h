//
//  SelectCity.h
//  anjuyi1
//
//  Created by apple on 2018/6/21.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SelectCity;

@protocol SelectCityDelegate <NSObject>

- (void)selectCityWithInfo:(NSDictionary *)info view:(SelectCity *)selectCity;

@end

@interface SelectCity : UIView

@property (nonatomic,strong)NSMutableArray *dataArr;

- (void)show;

- (void)hidden;

@property (nonatomic,weak)id<SelectCityDelegate>delegate;


@end
