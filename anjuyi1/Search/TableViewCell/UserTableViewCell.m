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
    [self.nameLabel setAttributedText:[self stringToAttribute:dic[@"username"]]];
    [self.numLabel setText:[NSString stringWithFormat:@"被关注数%@",dic[@"fan_num"]]];
}

- (NSMutableAttributedString *)stringToAttribute:(NSString *)str{
    
    if (str == nil) {
        str = @"";
    }
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:str];
    
    if ([str length] > 9 && [str rangeOfString:@"<em>"].location != NSNotFound) {
        
        NSArray * startArr = [str componentsSeparatedByString:@"<em>"];
        NSArray * endArr = [startArr[1] componentsSeparatedByString:@"</em>"];
        
        attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@",startArr[0],endArr[0],endArr[1]]];
        [attri addAttribute:NSForegroundColorAttributeName value:GCOLOR range:NSMakeRange([startArr[0] length], [endArr[0] length])];
        
    }
    return attri;
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
