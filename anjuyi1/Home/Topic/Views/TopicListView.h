//
//  ChannelListView.h
//  anjuyi1
//
//  Created by apple on 2018/8/10.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TopicListViewDelegate <NSObject>

- (void)jumpToTopicDetails:(UIViewController *)vc;

@end

@interface TopicListView : UIView

@property (nonatomic,weak)id<TopicListViewDelegate>delegate;

@property (nonatomic,strong) NSString *cate_id;
- (void) autoRefreshIfNeed;
@end
