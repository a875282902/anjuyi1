//
//  HouseCommentTableViewCell.m
//  anjuyi1
//
//  Created by apple on 2018/7/25.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "HouseCommentTableViewCell.h"
#import "CommentUserModel.h"

@implementation HouseCommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self = [[NSBundle mainBundle] loadNibNamed:@"HouseCommentTableViewCell" owner:self options:nil].lastObject;
    }
    return self;

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.headerImage.layer setCornerRadius:15.5];

}

- (void)bandDataWith:(CommentModel *)model{
    
    CommentUserModel *userModel = [[CommentUserModel alloc] initWithDictionary: model.member_info];
    
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:userModel.head]];
    
    NSString *str = userModel.nick_name;
    
    if ([model.reply_name isKindOfClass:[NSString class]]) {
        str = [NSString stringWithFormat:@"%@回复%@",str,model.reply_name];
    }
    
    NSMutableAttributedString *attS = [[NSMutableAttributedString alloc] initWithString:str];
    
    if ([str rangeOfString:@"回复"].location != NSNotFound) {

        [attS setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"]} range:NSMakeRange([str rangeOfString:@"回复"].location, 2)];
    }

    [self.nameLabel setAttributedText:attS];
    [self.commentLabel setText:model.content];
    [self.timeLabel setText:model.create_time];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    // Configure the view for the selected state
}

@end
