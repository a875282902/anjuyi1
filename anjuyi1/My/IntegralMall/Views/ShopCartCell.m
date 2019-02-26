//
//  ShopCartCell.m
//  anjuyi1
//
//  Created by 李 on 2018/6/5.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "ShopCartCell.h"

@implementation ShopCartCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ShopCartCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (IBAction)selectShop:(UIButton *)sender {

    [sender setSelected:!sender.selected];

}

- (IBAction)subtractShopNumber:(UIButton *)sender {
    
    if ([self.numTextField.text integerValue] > 1) {
        [self.numTextField setText:[NSString stringWithFormat:@"%ld",(long)([self.numTextField.text intValue]-1)]];
    }
    
    
    
}
- (IBAction)addShopNumber:(UIButton *)sender {
    
     [self.numTextField setText:[NSString stringWithFormat:@"%ld",(long)([self.numTextField.text intValue]+1)]];
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
