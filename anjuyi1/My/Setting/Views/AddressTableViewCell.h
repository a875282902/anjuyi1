//
//  AddressTableViewCell.h
//  anjuyi1
//
//  Created by 李 on 2018/6/7.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"

@class AddressTableViewCell;

@protocol AddressTableViewCellDelegate <NSObject>

- (void)deleteTableViewWithCell:(AddressTableViewCell *)cell;
- (void)editTableViewWithCell:(AddressTableViewCell *)cell;
- (void)setDefaultTableViewWithCell:(AddressTableViewCell *)cell;

@end

@interface AddressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIButton *defaultButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (nonatomic,assign)id<AddressTableViewCellDelegate>delegate;

- (void)bandDataWith:(AddressModel *)model;

@end
