//
//  CommentTableViewCell.m
//  anjuyi1
//
//  Created by 李 on 2018/6/2.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "CommentTableViewCell.h"

@interface CommentTableViewCell ()

@property (nonatomic,strong) UILabel     * titleLabel;
@property (nonatomic,strong) UILabel     * typeLabel;
@property (nonatomic,strong) UILabel     * timeLabel;
@property (nonatomic,strong) UIView      * lineView;
@property (nonatomic,strong) UIImageView * arrowImage;

@end

@implementation CommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    
    self.titleLabel = [Tools creatLabel:CGRectMake(MDXFrom6(15), MDXFrom6(15), MDXFrom6(290), 20) font:[UIFont systemFontOfSize:16] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:@""];
    [self addSubview:self.titleLabel];
    
    self.typeLabel = [Tools creatLabel:CGRectMake(MDXFrom6(15), MDXFrom6(15), MDXFrom6(40), MDXFrom6(20)) font:[UIFont systemFontOfSize:12] color:[UIColor whiteColor] alignment:(NSTextAlignmentCenter) title:@"风格"];
    [self.typeLabel setBackgroundColor:[UIColor colorWithHexString:@"#ffb638"]];
    [self.typeLabel.layer setCornerRadius:2];
    [self.typeLabel setClipsToBounds:YES];
    [self addSubview:self.typeLabel];
    
    self.timeLabel = [Tools creatLabel:CGRectMake(MDXFrom6(15), MDXFrom6(15), MDXFrom6(290), 20) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentLeft) title:@"2018年4月28号"];
    [self addSubview:self.timeLabel];
    
    self.lineView = [Tools setLineView:CGRectMake(0,0 , KScreenWidth, 1)];
    [self addSubview:self.lineView];
    
    self.arrowImage = [Tools creatImage:CGRectMake(MDXFrom6(350), 0, MDXFrom6(6), MDXFrom6(10)) image:@"arrow_dark"];
    [self addSubview:self.arrowImage];
    
}

- (void)bandDataWith:(NSDictionary *)dic{
    
    [self.titleLabel setFrame:CGRectMake(MDXFrom6(15), MDXFrom6(15), MDXFrom6(290),[dic[@"titleHight"] floatValue])];
    [self.titleLabel setText:dic[@"title"]];
    
    NSInteger h = [dic[@"titleWidth"] floatValue]/MDXFrom6(290);
    
    CGFloat wid = [dic[@"titleWidth"] floatValue] -  MDXFrom6(290) *h;
    
    if (wid > MDXFrom6(240)) {
        [self.typeLabel setFrame:CGRectMake(MDXFrom6(15), [dic[@"titleHight"] floatValue]+MDXFrom6(20), MDXFrom6(40),16)];
        
        [self.timeLabel setFrame:CGRectMake(MDXFrom6(15), [dic[@"titleHight"] floatValue]+MDXFrom6(26)+16, MDXFrom6(290),MDXFrom6(20))];
        
        [self.lineView setFrame:CGRectMake(0, [dic[@"titleHight"] floatValue]+MDXFrom6(46)+31 , KScreenWidth, 1)];
        
        [self.arrowImage setFrame:CGRectMake(MDXFrom6(350), ([dic[@"titleHight"] floatValue]+MDXFrom6(36)+31)/2, MDXFrom6(6), MDXFrom6(10))];
    }
    else{
   
        [self.typeLabel setFrame:CGRectMake(MDXFrom6(15)+wid,MDXFrom6(15)+([dic[@"titleHight"] floatValue] -16), MDXFrom6(40),16)];
        
        [self.timeLabel setFrame:CGRectMake(MDXFrom6(15),[dic[@"titleHight"] floatValue]+MDXFrom6(25), MDXFrom6(290),MDXFrom6(20))];
        
        self.lineView.frame =CGRectMake(0, [dic[@"titleHight"] floatValue]+MDXFrom6(45)+15 , KScreenWidth, 1);
        
        [self.arrowImage setFrame:CGRectMake(MDXFrom6(350), ([dic[@"titleHight"] floatValue]+MDXFrom6(35)+15)/2, MDXFrom6(6), MDXFrom6(10))];
        
    }
   
    
    [self.typeLabel setText:dic[@"type_name"]];
    [self.timeLabel setText:dic[@"create_time"]];
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    // Configure the view for the selected state
}

@end
