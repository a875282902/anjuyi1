//
//  ActivityList.h
//  anjuyi1
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ActivityListDelegate <NSObject>

- (void)backViewScroll:(CGFloat)y;

- (void)selectPhotoToShow:(NSString *)photoId;

@end

@interface ActivityList : UIView

- (void)setDataWitIndex:(NSInteger)index withActivityid:(NSString *)activity_id;

@property (nonatomic,weak)id<ActivityListDelegate>delegate;

- (void)refreFrame;

@end
