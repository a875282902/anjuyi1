//
//  HouseTableViewCell.m
//  anjuyi1
//
//  Created by apple on 2018/9/26.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "HouseTableViewCell.h"

@implementation HouseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"HouseTableViewCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)bandDataWithModel:(NSDictionary *)dic{
    
    [self.nameLabel setAttributedText:[self stringToAttribute:dic[@"username"]]];
    [self.titleLabel setAttributedText:[self stringToAttribute:dic[@"title"]]];
    if (dic[@"proportion"]) {
        [self.areaLabel setHidden:NO];
        [self.areaLabel setText:[NSString stringWithFormat:@"%@m²",dic[@"proportion"]]];
    }
    
    [self.coverImage sd_setImageWithURL:[NSURL URLWithString:dic[@"img"]]];
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
    [self.areaLabel setHidden:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
