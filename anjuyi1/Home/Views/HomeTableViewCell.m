//
//  HomeTableViewCell.m
//  anjuyi1
//
//  Created by 李 on 2018/5/29.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "HomeTableViewCell.h"

@implementation HomeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"HomeTableViewCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
