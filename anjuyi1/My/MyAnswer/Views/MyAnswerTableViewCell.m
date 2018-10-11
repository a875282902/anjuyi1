//
//  MyAnswerTableViewCell.m
//  anjuyi1
//
//  Created by 李 on 2018/6/3.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "MyAnswerTableViewCell.h"

@implementation MyAnswerTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"MyAnswerTableViewCell" owner:self options:nil] lastObject];
    }
    return self;
}
- (void)bandDataWithModel:(AnswerModel *)model{
    
    [self.titleLabel setText:model.topic_title];
    [self.answerLabel setText:model.content];
    [self.timeLabel setText:model.add_time];
    [self.likeView setText:[NSString stringWithFormat:@"赞 %@ 收藏 %@",model.zan_num,model.collect_num]];
    
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
