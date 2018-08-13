//
//  TopicListTableViewCell.m
//  anjuyi1
//
//  Created by apple on 2018/8/10.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "TopicListTableViewCell.h"

@implementation TopicListTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"TopicListTableViewCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)bandDataWithModel:(TopicModel *)model{

    [self.backView setBackgroundColor:model.backColor];
    
    [self.titleLabel setText:model.title];
    [self.descLabel setText:model.content];
    [self.numLabel setText:[NSString stringWithFormat:@"%@人参与征集",model.reply_count]];
    
    [self.userList.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat x = 0;
    
    for (NSInteger i = 0 ; i < model.user_list.count; i++) {
        
        if (x+32>self.userList.frame.size.width) {
            [self.userList addSubview:[Tools creatImage:CGRectMake(x, 0, 32, 32) image:@"more_p"]];
            break;
        }
        
        UIImageView *userhead =[Tools creatImage:CGRectMake(x, 0, 32, 32) url:model.user_list[i] image:@""];
        [userhead.layer setCornerRadius:16];
        [userhead.layer setBorderColor:[UIColor whiteColor].CGColor];
        [userhead.layer setBorderWidth:1];
        [self.userList addSubview:userhead];
        
        x += 25;
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.backView.layer setCornerRadius:5];
    

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    // Configure the view for the selected state
}

@end
