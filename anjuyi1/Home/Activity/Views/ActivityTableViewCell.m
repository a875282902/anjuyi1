//
//  ActivityTableViewCell.m
//  anjuyi1
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "ActivityTableViewCell.h"

@implementation ActivityTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"ActivityTableViewCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.backView.layer setBorderWidth:1];
    [self.backView.layer setBorderColor:[UIColor colorWithHexString:@"#efefef"].CGColor];
    [self.backView.layer setCornerRadius:5];
    [self.backView setClipsToBounds:YES];
}

- (void)bandDataWithModel:(ActivityModel *)model{
    
    [self.coverImage sd_setImageWithURL:[NSURL URLWithString:model.img]];
    [self.titleLabel setText:model.title];
    [self.numLabel setText:[NSString stringWithFormat:@"%@人参与征集",model.user_num]];
    
    [self.userView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat x = 0;
    
    for (NSInteger i = 0 ; i < model.user_list.count; i++) {
        
        if (x+32>self.userView.frame.size.width) {
            [self.userView addSubview:[Tools creatImage:CGRectMake(x, 0, 32, 32) image:@"more_p"]];
            break;
        }
        
        UIImageView *userhead =[Tools creatImage:CGRectMake(x, 0, 32, 32) url:model.user_list[i] image:@""];
        [userhead.layer setCornerRadius:16];
        [userhead.layer setBorderColor:[UIColor whiteColor].CGColor];
        [userhead.layer setBorderWidth:1];
        [self.userView addSubview:userhead];
        
        x += 25;
    }
    
}

- (IBAction)clickOnTheParticipation:(UIButton *)sender {
    
    self.selectToParticipate();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    // Configure the view for the selected state
}

@end
