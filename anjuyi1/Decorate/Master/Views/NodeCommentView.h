//
//  NodeCommentView.h
//  anjuyi1
//
//  Created by apple on 2018/9/19.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NodeCommentView : UIView
@property (nonatomic,strong)NSString *nodeid;

- (void)openDisplay;

- (void)addComment;
@end
