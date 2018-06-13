//
//  MyCouponsTableViewCell.m
//  anjuyi1
//
//  Created by 李 on 2018/6/4.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "MyCouponsTableViewCell.h"

@implementation MyCouponsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"MyCouponsTableViewCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
