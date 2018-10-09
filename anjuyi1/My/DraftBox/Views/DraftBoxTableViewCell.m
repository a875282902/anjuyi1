//
//  DraftBoxTableViewCell.m
//  anjuyi1
//
//  Created by 李 on 2018/6/3.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "DraftBoxTableViewCell.h"
#import "HouseModel.h"
#import "CommentUserModel.h"
#import "StrategyModel.h"

@implementation DraftBoxTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"DraftBoxTableViewCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)bandDataWithModel:(BaseModel *)model{
    
    if ([model isKindOfClass:[HouseModel class]]) {
        
        HouseModel *houseModel = (HouseModel *)model;
        
        CommentUserModel *userModel = [[CommentUserModel alloc] initWithDictionary:houseModel.member_info];
        
        [self.coverImage sd_setImageWithURL:[NSURL URLWithString:houseModel.cover]];
        [self.headerImage sd_setImageWithURL:[NSURL URLWithString:userModel.head]];
        [self.nameLabel setText:userModel.nick_name];
        [self.titleLabel setText:houseModel.title];
        [self.descLabel setText:[NSString stringWithFormat:@"%@   %@平米",houseModel.door,houseModel.proportion]];
        [self.typeLabel setText:userModel.level];
    }
    
    if ([model isKindOfClass:[StrategyModel class]]) {
        
        StrategyModel *strategyModel = (StrategyModel *)model;
        
        CommentUserModel *userModel = [[CommentUserModel alloc] initWithDictionary:strategyModel.member_info];
        
        [self.coverImage sd_setImageWithURL:[NSURL URLWithString:strategyModel.img]];
        [self.headerImage sd_setImageWithURL:[NSURL URLWithString:userModel.head]];
        [self.nameLabel setText:userModel.nick_name];
        [self.titleLabel setText:strategyModel.title];
        [self.descLabel setText:strategyModel.door];
        [self.typeLabel setHidden:YES];
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.backView.layer setBorderColor:[UIColor colorWithHexString:@"#EEEEEE"].CGColor];
    [self.backView.layer setBorderWidth:1];
    [self.backView.layer setCornerRadius:5];
    
    [self.typeLabel.layer setCornerRadius:2];
    [self.headerImage.layer setCornerRadius:20];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    // Configure the view for the selected state
}

@end
