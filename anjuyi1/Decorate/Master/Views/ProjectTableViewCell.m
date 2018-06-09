//
//  ProjectTableViewCell.m
//  anjuyi1
//
//  Created by 李 on 2018/6/1.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "ProjectTableViewCell.h"

@implementation ProjectTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ProjectTableViewCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.coverImage.layer setCornerRadius:5];
    [self.headerImgea.layer setCornerRadius:20];
    [self.visitBtn.layer setBorderColor:[UIColor colorWithHexString:@"#34bab8"].CGColor];
    [self.visitBtn.layer setBorderWidth:1];
    [self.visitBtn.layer setCornerRadius:2.5];
    
    [self.checkBtn.layer setBorderColor:[UIColor colorWithHexString:@"#34bab8"].CGColor];
    [self.checkBtn.layer setBorderWidth:1];
    [self.checkBtn.layer setCornerRadius:2.5];
    
}
- (IBAction)subscribeVisit:(UIButton *)sender {
    
    [self.delegate subscribeVisitWithCell:self];
}
- (IBAction)checkCase:(UIButton *)sender {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
