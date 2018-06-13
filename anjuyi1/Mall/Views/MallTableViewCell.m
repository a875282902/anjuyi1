//
//  MallTableViewCell.m
//  anjuyi1
//
//  Created by 李 on 2018/5/30.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "MallTableViewCell.h"

@implementation MallTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"MallTableViewCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.addBtn.layer setCornerRadius:15];
    [self.addBtn.layer setBorderColor:[UIColor colorWithHexString:@"#E77C03"].CGColor];
    [self.addBtn.layer setBorderWidth:1];
    
    [self.coverImage.layer setCornerRadius:5];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
