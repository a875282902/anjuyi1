//
//  QuestionTableViewCell.m
//  anjuyi1
//
//  Created by apple on 2018/8/3.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "QuestionTableViewCell.h"

@implementation QuestionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"QuestionTableViewCell" owner:self options:nil] lastObject];
    }
    return self;
}
- (void)bandDataWithDictionary:(NSDictionary *)dic{
    
    [self.titleLabel setText:dic[@"title"]];
    [self.contentLabel setText:dic[@"text"]];
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.backView.layer setBorderColor:[UIColor colorWithHexString:@"#d1d1d1"].CGColor];
    [self.backView.layer setBorderWidth:1];
    [self.backView.layer setCornerRadius:5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    // Configure the view for the selected state
}

@end
