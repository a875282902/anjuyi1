//
//  TopicCommentTableViewCell.m
//  anjuyi1
//
//  Created by apple on 2018/8/10.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "TopicCommentTableViewCell.h"
#import "CommentUserModel.h"

@implementation TopicCommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"TopicCommentTableViewCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)bandDataWithModel:(TopicCommentModel *)model{
    
    CommentUserModel *userModel = [[CommentUserModel alloc] initWithDictionary:model.member_info];
    
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:userModel.head]];
    [self.nameLabel setText:userModel.nick_name];
    [self.levelLabel setText:userModel.level];
    
    [self.timeLabel setText:model.create_time];
    [self.adoptButton setSelected:[model.isBest integerValue]==0?YES:NO];
    [self.cainaImage setHidden:[model.isBest integerValue]==0?YES:NO];
    
    [self.descLabel setText:model.content];
    
    [self.likeButton setTitle:[NSString stringWithFormat:@"%@",model.zan_num] forState:(UIControlStateNormal)];
    [self.likeButton setSelected:[model.is_zan integerValue]==1?YES:NO];
    
    [self.collectButton setTitle:[NSString stringWithFormat:@"%@",model.collect_num] forState:(UIControlStateNormal)];
    [self.collectButton setSelected:[model.is_collect integerValue]==1?YES:NO];
    
//    [self.descLabel setNumberOfLines:model.isShow?0:3];
//    [self.showAll setSelected:model.isShow];
//    [self.showAll setHidden:model.isShowAllButton];
    [self.showAll setHidden:YES];
    [self.descLabel setNumberOfLines:0];
}

- (IBAction)adopt:(UIButton *)sender {

    [self.delegate adoptWithCell:self];
}
- (IBAction)showAll:(UIButton *)sender {
    
    [self.delegate showAllWithCell:self];
}

- (IBAction)like:(UIButton *)sender {
    
    [self.delegate likeWithCell:self];
}

- (IBAction)collect:(UIButton *)sender {
    
    [self.delegate collectWithCell:self];
}

- (IBAction)share:(UIButton *)sender {
    
    [self.delegate shareWithCell:self];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.levelLabel.layer setCornerRadius:5];
    [self.headerImage.layer setCornerRadius:21.5];
    [self.adoptButton.layer setCornerRadius:16.5];
    [self.adoptButton.layer setBorderWidth:1];
    [self.adoptButton.layer setBorderColor:[UIColor colorWithHexString:@"#5cc6c6"].CGColor];
    
    [self.cainaImage setHidden:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    // Configure the view for the selected state
}

@end
