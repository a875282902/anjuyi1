//
//  StrategyCommentView.h
//  anjuyi1
//
//  Created by apple on 2018/9/30.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StrategyCommentView : UIView

@property (nonatomic,strong)NSString *strategy_id;
@property (nonatomic,strong)NSString *commit_id;
@property (nonatomic,copy) void (^selectShowDetails)(NSString *eva_id);
@property (nonatomic,copy) void (^showReviewerDetail)(BaseViewController *vc);

- (void)openDisplay;

- (void)addComment;
@end
