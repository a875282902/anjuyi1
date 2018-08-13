//
//  TopicListTableViewCell.h
//  anjuyi1
//
//  Created by apple on 2018/8/10.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicModel.h"

@interface TopicListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIView *userList;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
- (void)bandDataWithModel:(TopicModel *)model;
@end
