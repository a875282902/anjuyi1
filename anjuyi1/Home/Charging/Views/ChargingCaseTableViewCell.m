//
//  ChargingCaseTableViewCell.m
//  anjuyi1
//
//  Created by apple on 2018/7/19.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "ChargingCaseTableViewCell.h"

@implementation ChargingCaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ChargingCaseTableViewCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)bandDataWithDictionary:(NSDictionary *)dic{
    
    [self.titleLabel setText:dic[@"title"]];
    [self.descLabel setText:dic[@"create_time"]];
    [self.coverImage sd_setImageWithURL:[NSURL URLWithString:dic[@"img"]]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.backView.layer setBorderColor:[UIColor colorWithHexString:@"#EEEEEE"].CGColor];
    [self.backView.layer setBorderWidth:1];
    [self.backView.layer setCornerRadius:5];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
