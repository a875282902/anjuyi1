//
//  AddressTableViewCell.m
//  anjuyi1
//
//  Created by 李 on 2018/6/7.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "AddressTableViewCell.h"

@implementation AddressTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"AddressTableViewCell" owner:self options:nil] lastObject];
    }
    return self;
}
- (IBAction)setDefault:(UIButton *)sender {
    
    [sender setSelected:!sender.selected];
    [self.delegate setDefaultTableViewWithCell:self];
    
}
- (IBAction)delete:(UIButton *)sender {
    
    [self.delegate deleteTableViewWithCell:self];
}
- (IBAction)eidt:(UIButton *)sender {
 
    [self.delegate editTableViewWithCell:self];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.backView.layer setCornerRadius:5];
    [self.backView.layer setBorderWidth:1];
    [self.backView.layer setBorderColor:[UIColor colorWithHexString:@"#e3e3e3"].CGColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
