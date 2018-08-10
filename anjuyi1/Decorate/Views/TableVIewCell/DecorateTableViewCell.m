//
//  DecorateTableViewCell.m
//  anjuyi1
//
//  Created by 李 on 2018/5/30.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "DecorateTableViewCell.h"
#import "CommentUserModel.h"

@implementation DecorateTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"DecorateTableViewCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.headerImage.layer setCornerRadius:15];
    
    // Initialization code
}

- (void)bandDataWithModel:(DecorateModel *)model{
    
    [self.coverImage sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    [self.titleLabel setText:model.title];
    
    CommentUserModel *userModel = [[CommentUserModel alloc] initWithDictionary:model.house_own_info];
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:userModel.head]];
    [self.nameLabel setText:userModel.position];
    [self.descLabel setText:model.said];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
[self setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    // Configure the view for the selected state
}

@end
