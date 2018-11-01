//
//  NodeCommentView.h
//  anjuyi1
//
//  Created by apple on 2018/9/19.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NodeCommentView : UIView

@property (nonatomic,copy) void (^showCommentDetali)(NSString *eva_id);
@property (nonatomic,copy) void (^showReviewerDetail)(BaseViewController *vc);
@property (nonatomic,strong)NSString *commit_id;
@property (nonatomic,strong)NSString *nodeid;

- (void)openDisplay;

- (void)addComment;
@end
