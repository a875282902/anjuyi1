//
//  OrderCenterTableViewCell.h
//  anjuyi1
//
//  Created by 李 on 2018/6/8.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderCenterModel.h"

@interface OrderCenterTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *ModelLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

- (void)bandDataWithModel:(OrderCenterModel *)model;

@end
