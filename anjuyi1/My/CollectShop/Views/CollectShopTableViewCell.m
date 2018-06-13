//
//  CollectShopTableViewCell.m
//  anjuyi1
//
//  Created by 李 on 2018/6/4.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "CollectShopTableViewCell.h"

@implementation CollectShopTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"CollectShopTableViewCell" owner:self options:nil] lastObject];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.likeButton setTitleEdgeInsets:UIEdgeInsetsMake(20, -self.likeButton.imageView.frame.size.width-5, 0, 0)];
    [self.likeButton setImageEdgeInsets:UIEdgeInsetsMake(5, 15, 25, 15)];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
