//
//  PhotoCollectionViewCell.m
//  anjuyi1
//
//  Created by 李 on 2018/6/3.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@interface PhotoCollectionViewCell ()

@property (nonatomic,strong)UIImageView  *   coverImage;
@property (nonatomic,strong)UILabel      *   titleLabel;
@property (nonatomic,strong)UIImageView  *   headerImage;
@property (nonatomic,strong)UILabel      *   nameLabel;

@end

@implementation PhotoCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
        [self setUpUI:frame];
    }
    return self;
    
}

- (void)setUpUI:(CGRect)frame{
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [backView.layer setCornerRadius:4];
    [backView.layer setBorderColor:[UIColor colorWithHexString:@"#efefef"].CGColor];
    [backView.layer setBorderWidth:1.5];
    [backView setClipsToBounds:YES];
    [self addSubview:backView];
    
    self.coverImage = [Tools creatImage:CGRectMake(0, 0, frame.size.width,frame.size.width/( 170/113.0f)) image:@"myimg_case"];
    [backView addSubview:self.coverImage];
    
    CGFloat height = frame.size.width/( 170/113.0f)+10;
    
    
    self.titleLabel = [Tools creatLabel:CGRectMake(5,height ,frame.size.width - 10 , 30) font:[UIFont systemFontOfSize:12] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:@"好看的皮囊和有趣的灵魂要兼顾，这才是我想要的生活的样子"];
    [backView addSubview:self.titleLabel];
    
    height += 40;
    
    self.headerImage = [Tools creatImage:CGRectMake(5, height, 19, 19) image:@"leader_tx_img"];
    [self.headerImage.layer setCornerRadius:9.5];
    [backView addSubview:self.headerImage];
    
    self.nameLabel = [Tools creatLabel:CGRectMake(35,height ,frame.size.width - 40 , 20) font:[UIFont systemFontOfSize:12] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:@"九溪设计"];
    [backView addSubview:self.nameLabel];
    
    self.collectButton = [Tools creatButton:CGRectMake(frame.size.width - 50, height, 50, 20) font:[UIFont systemFontOfSize:12] color:[UIColor blackColor] title:@"" image:@"colle"];
    [self.collectButton setImage:[UIImage imageNamed:@"colle_xz"] forState:(UIControlStateSelected)];
    [self.collectButton setSelected:NO];
    [self.collectButton addTarget:self action:@selector(collect:) forControlEvents:(UIControlEventTouchUpInside)];
    [backView addSubview:self.collectButton];
    

    
}

- (void)bandDataWithModel:(MyPhotoModel *)model{
    
    [self.coverImage sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    [self.titleLabel setAttributedText:[self stringToAttribute:model.text]];
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:model.head]];
    [self.nameLabel setAttributedText:[self stringToAttribute:model.nick_name]];
    [self.collectButton setTitle:[NSString stringWithFormat:@" %@",model.collect_num] forState:(UIControlStateNormal)];
    [self.collectButton setSelected:[model.is_collect integerValue]==1?YES:NO];
    if (model.member_info) {
        [self.headerImage sd_setImageWithURL:[NSURL URLWithString:model.member_info[@"head"]]];
        [self.nameLabel setAttributedText:[self stringToAttribute:model.member_info[@"nickname"]]];
    }
}

- (void)collect:(UIButton *)sender{
    
    self.selectPhotoToCollect(sender);
}

- (NSMutableAttributedString *)stringToAttribute:(NSString *)str{
    
    if (str == nil) {
        str = @"";
    }
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:str];
    
    if ([str length] > 9 && [str rangeOfString:@"<em>"].location != NSNotFound) {
        
        NSArray * startArr = [str componentsSeparatedByString:@"<em>"];
        NSArray * endArr = [startArr[1] componentsSeparatedByString:@"</em>"];
        
        attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@",startArr[0],endArr[0],endArr[1]]];
        [attri addAttribute:NSForegroundColorAttributeName value:GCOLOR range:NSMakeRange([startArr[0] length], [endArr[0] length])];
        
    }
    return attri;
}
@end
