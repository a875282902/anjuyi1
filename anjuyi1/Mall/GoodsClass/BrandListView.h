//
//  BrandListView.h
//  anjuyi1
//
//  Created by apple on 2018/6/14.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BrandListView;

@protocol BrandListViewDelegate <NSObject>

- (void)selectBrandWithIndex:(NSInteger)index;

@end

@interface BrandListView : UIView

@property (nonatomic,assign)id<BrandListViewDelegate>delegate;

@end
