//
//  HouseSpaceTableViewCell.m
//  anjuyi1
//
//  Created by apple on 2018/7/17.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "HouseSpaceTableViewCell.h"

@implementation HouseSpaceTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self = [[NSBundle mainBundle] loadNibNamed:@"HouseSpaceTableViewCell" owner:self options:nil].lastObject;
    }
    return self;
}

- (void)bandDataWith:(NSDictionary *)dic{
    
    [self.titleLabel setText:dic[@"name"]];
    [self.numLabel setText:[NSString stringWithFormat:@"%@张",dic[@"img_num"]]];
    
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
