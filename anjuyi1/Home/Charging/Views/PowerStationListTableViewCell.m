//
//  PowerStationListTableViewCell.m
//  anjuyi1
//
//  Created by apple on 2018/7/20.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "PowerStationListTableViewCell.h"

@implementation PowerStationListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"PowerStationListTableViewCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)bandDataWithModel:(PowerStatonModel *)model{
    [self.nameLabel setText:model.name];
    [self.timeLabel setText:model.business];
    [self.addressLabel setText:model.address];
    [self.distanceLabel setText:model.distance];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    // Configure the view for the selected state
}

@end
