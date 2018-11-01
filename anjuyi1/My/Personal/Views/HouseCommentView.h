//
//  HouseCommentView.h
//  anjuyi1
//
//  Created by apple on 2018/7/25.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HouseCommentView : UIView

@property (nonatomic,strong)NSString *commit_id;
@property (nonatomic,strong)NSString *house_id;
@property (nonatomic,copy) void(^selectCommentToshow)(UIViewController *vc);
@property (nonatomic,copy) void(^showReviewerDetail)(BaseViewController *vc);
- (void)openDisplay;

- (void)addComment;

@end
