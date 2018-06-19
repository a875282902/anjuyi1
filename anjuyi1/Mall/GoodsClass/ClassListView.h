//
//  ClassListView.h
//  anjuyi1
//
//  Created by apple on 2018/6/14.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClassListView;

@protocol ClassListViewDelegate <NSObject>

- (void)selectClassWithIndex:(NSInteger)index;

@end

@interface ClassListView : UIView

@property (nonatomic,assign)id<ClassListViewDelegate>delegate;

@end
