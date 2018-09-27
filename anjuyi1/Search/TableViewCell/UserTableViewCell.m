//
//  UserTableViewCell.m
//  anjuyi1
//
//  Created by apple on 2018/9/26.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "UserTableViewCell.h"

@implementation UserTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"UserTableViewCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)bandDataWithDictionary:(NSDictionary *)dic{
    
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:dic[@"userhead"]]];
    [self.nameLabel setText:dic[@"username"]];
    [self.numLabel setText:dic[@"address"]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.headImage.layer setCornerRadius:21.5];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
