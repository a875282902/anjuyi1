//
//  HouseTableViewCell.m
//  anjuyi1
//
//  Created by apple on 2018/9/26.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "HouseTableViewCell.h"

@implementation HouseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"HouseTableViewCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)bandDataWithModel:(NSDictionary *)dic{
    
    [self.nameLabel setText:dic[@"username"]];
    [self.titleLabel setText:dic[@"title"]];
    [self.areaLabel setText:[NSString stringWithFormat:@"%@m²",dic[@"proportion"]]];
    [self.coverImage sd_setImageWithURL:[NSURL URLWithString:dic[@"img"]]];
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
