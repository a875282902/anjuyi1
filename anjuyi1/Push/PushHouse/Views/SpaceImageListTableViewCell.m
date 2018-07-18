//
//  SpaceImageListTableViewCell.m
//  anjuyi1
//
//  Created by apple on 2018/7/17.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "SpaceImageListTableViewCell.h"

@implementation SpaceImageListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self = [[NSBundle mainBundle] loadNibNamed:@"SpaceImageListTableViewCell" owner:self options:nil].lastObject;
    }
    return self;
}


- (void)bandDataWith:(NSDictionary *)dic{
    
    [self.coverImage sd_setImageWithURL:[NSURL URLWithString:dic[@"img_url"]]];
    
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
