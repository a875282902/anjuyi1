//
//  ChargingCaseTableViewCell.h
//  anjuyi1
//
//  Created by apple on 2018/7/19.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChargingCaseTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;


- (void)bandDataWithDictionary:(NSDictionary *)dic;

@end
