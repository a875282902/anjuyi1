//
//  DesignerTableViewCell.h
//  anjuyi1
//
//  Created by 李 on 2018/5/30.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterModel.h"

@interface DesignerTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *descImage1;
@property (weak, nonatomic) IBOutlet UIImageView *descImage2;
@property (weak, nonatomic) IBOutlet UIImageView *descImage3;
@property (weak, nonatomic) IBOutlet UIView *backView;


- (void)bandDataWithModel:(MasterModel *)model;

@end
