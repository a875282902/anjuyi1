//
//  ActivityTableViewCell.h
//  anjuyi1
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ActivityModel.h"

@interface ActivityTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UIView *userView;

@property (nonatomic,copy)void(^selectToParticipate)();

- (void)bandDataWithModel:(ActivityModel *)model;

@end
