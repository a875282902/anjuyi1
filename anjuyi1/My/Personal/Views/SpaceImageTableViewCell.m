//
//  SpaceImageTableViewCell.m
//  anjuyi1
//
//  Created by apple on 2018/8/2.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "SpaceImageTableViewCell.h"

@implementation SpaceImageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"SpaceImageTableViewCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)bandDataWithDic:(NSDictionary *)dic{
    
    [self.coverImage sd_setImageWithURL:[NSURL URLWithString:dic[@"img_url"]]];
    [self.descLabel setText:dic[@"description"]];
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
