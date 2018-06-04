//
//  MyFriendTableViewCell.m
//  anjuyi1
//
//  Created by 李 on 2018/6/3.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "MyFriendTableViewCell.h"

@implementation MyFriendTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"MyFriendTableViewCell" owner:self options:nil] lastObject];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.headerImage.layer setCornerRadius:21.5];
    
    [self.typeLabel.layer setCornerRadius:3];
    
    [self.likeButton.layer setBorderWidth:1];
    [self.likeButton.layer setBorderColor:[UIColor colorWithHexString:@"#ffb638"].CGColor];
    [self.likeButton.layer setCornerRadius:2.5];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
