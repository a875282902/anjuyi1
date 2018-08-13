//
//  TopicCommentTableViewCell.h
//  anjuyi1
//
//  Created by apple on 2018/8/10.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TopicCommentModel.h"

@class TopicCommentTableViewCell;

@protocol TopicCommentTableViewCellDelegate <NSObject>

- (void)likeWithCell:(TopicCommentTableViewCell *)cell;
- (void)collectWithCell:(TopicCommentTableViewCell *)cell;
- (void)shareWithCell:(TopicCommentTableViewCell *)cell;
- (void)adoptWithCell:(TopicCommentTableViewCell *)cell;
- (void)showAllWithCell:(TopicCommentTableViewCell *)cell;

@end

@interface TopicCommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UIImageView *cainaImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *adoptButton;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIButton *showAll;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (nonatomic, weak) id<TopicCommentTableViewCellDelegate>delegate;

- (void)bandDataWithModel:(TopicCommentModel *)model;


@end
