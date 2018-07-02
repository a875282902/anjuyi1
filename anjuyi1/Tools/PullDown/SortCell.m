//
//  SortCell.m
//  anjuyi1
//
//  Created by apple on 2018/6/26.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "SortCell.h"

@interface SortCell ()

@property (nonatomic, strong) UIImageView *cheakView;

@end

@implementation SortCell

- (UIImageView *)cheakView
{
    if (_cheakView == nil) {
        _cheakView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xiala_select"]];
        self.accessoryView = _cheakView;
    }
    return _cheakView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    self.cheakView.hidden = !selected;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


@end
