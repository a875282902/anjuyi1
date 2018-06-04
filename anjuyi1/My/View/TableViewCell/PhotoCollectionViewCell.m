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
@property (nonatomic,strong)UIImageView  *   likeImage;
@property (nonatomic,strong)UILabel      *   likeLabel;

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
    
    self.likeImage = [Tools creatImage:CGRectMake(frame.size.width - 50, height+2, 15, 15) image:@"detail_star"];
    [backView addSubview:self.likeImage];
    
    self.likeLabel = [Tools creatLabel:CGRectMake(frame.size.width - 35,height ,35 , 20) font:[UIFont systemFontOfSize:12] color:[UIColor blackColor] alignment:(NSTextAlignmentCenter) title:@"555"];
    [backView addSubview:self.likeLabel];
    
    
}

@end
