//
//  OrderCenterTableViewCell.m
//  anjuyi1
//
//  Created by 李 on 2018/6/8.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "OrderCenterTableViewCell.h"

@implementation OrderCenterTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"OrderCenterTableViewCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)bandDataWithModel:(OrderCenterModel *)model{

    [self.typeLabel setText:[NSString stringWithFormat:@"类型：%@",model.type]];
    
    [self.ModelLabel setText:[NSString stringWithFormat:@"户型：%@%@",model.room,model.hall]];
    
    [self.moneyLabel setText:[NSString stringWithFormat:@"预算：%@",model.budget]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.backView.layer setCornerRadius:5];
    [self.backView.layer setBorderColor:[UIColor colorWithHexString:@"#e3e3e3"].CGColor];
    [self.backView.layer setBorderWidth:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
