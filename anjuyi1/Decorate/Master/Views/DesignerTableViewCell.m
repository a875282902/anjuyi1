//
//  DesignerTableViewCell.m
//  anjuyi1
//
//  Created by 李 on 2018/5/30.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "DesignerTableViewCell.h"

@implementation DesignerTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"DesignerTableViewCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)bandDataWithModel:(MasterModel *)model{
    
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:model.head]];
    
    [self.nameLabel setText:model.nickname];
    
    [self.priceLabel setText:[NSString stringWithFormat:@"设计报价%@-%@元/m²",model.guestLow,model.guestHigh]];
    
    [self.typeLabel setText:model.type];
    if (model.image_list.count >0) {
         [self.descImage1 sd_setImageWithURL:[NSURL URLWithString:model.image_list[0]]];
    }
   
    if (model.image_list.count>1) {
       [self.descImage2 sd_setImageWithURL:[NSURL URLWithString:model.image_list[1]]];
    }
    if (model.image_list.count >2) {
        [self.descImage3 sd_setImageWithURL:[NSURL URLWithString:model.image_list[2]]];
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.backView.layer setBorderWidth:1];
    [self.backView.layer setBorderColor:[UIColor colorWithHexString:@"#efefef"].CGColor];
    [self.backView.layer setCornerRadius:5];
    [self.backView setClipsToBounds:YES];
    
    [self.typeLabel.layer setCornerRadius:10];
    [self.headerImage.layer setCornerRadius:30];
    [self.descImage1.layer setCornerRadius:5];
    [self.descImage2.layer setCornerRadius:5];
    [self.descImage3.layer setCornerRadius:5];
    
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    [self setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    // Configure the view for the selected state
}

@end
