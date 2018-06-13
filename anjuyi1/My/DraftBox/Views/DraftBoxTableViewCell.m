//
//  DraftBoxTableViewCell.m
//  anjuyi1
//
//  Created by 李 on 2018/6/3.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "DraftBoxTableViewCell.h"

@implementation DraftBoxTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"DraftBoxTableViewCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.backView.layer setBorderColor:[UIColor colorWithHexString:@"#EEEEEE"].CGColor];
    [self.backView.layer setBorderWidth:1];
    [self.backView.layer setCornerRadius:5];
    
    [self.typeLabel.layer setCornerRadius:2];
    [self.headerImage.layer setCornerRadius:20];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
