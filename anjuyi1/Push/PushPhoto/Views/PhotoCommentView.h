//
//  PhotoCommentView.h
//  anjuyi1
//
//  Created by apple on 2018/8/3.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCommentView : UIView

@property (nonatomic,strong)NSString *photo_id;
@property (nonatomic,strong)NSString *commit_id;

@property (nonatomic,copy)void(^selectCommentDetails)(NSString *eva_id);

@property (nonatomic,copy)void(^showReviewerDetail)(BaseViewController *vc);

@property (nonatomic,copy)void(^updateCommentData)(NSInteger num);

- (void)openDisplay;

- (void)addComment;
@end
