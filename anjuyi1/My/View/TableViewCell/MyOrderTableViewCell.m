//
//  MyOrderTableViewCell.m
//  anjuyi1
//
//  Created by 李 on 2018/6/5.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "MyOrderTableViewCell.h"

@implementation MyOrderTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"MyOrderTableViewCell" owner:self options:nil] lastObject];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.firstButton.layer setBorderWidth:1];
    [self.firstButton.layer setBorderColor:[UIColor colorWithHexString:@"#666666"].CGColor];
    [self.firstButton.layer setCornerRadius:15];
    
    [self.secondButton.layer setBorderWidth:1];
    [self.secondButton.layer setBorderColor:[UIColor colorWithHexString:@"#ff5941"].CGColor];
    [self.secondButton.layer setCornerRadius:15];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
