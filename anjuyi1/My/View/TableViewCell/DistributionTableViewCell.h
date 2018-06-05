//
//  DistributionTableViewCell.h
//  anjuyi1
//
//  Created by 李 on 2018/6/2.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DistributionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
