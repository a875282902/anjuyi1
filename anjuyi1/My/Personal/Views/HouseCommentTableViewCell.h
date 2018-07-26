//
//  HouseCommentTableViewCell.h
//  anjuyi1
//
//  Created by apple on 2018/7/25.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@interface HouseCommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

- (void)bandDataWith:(CommentModel *)model;

@end
