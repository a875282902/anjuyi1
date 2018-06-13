//
//  ProjectCollectionViewCell.m
//  anjuyi1
//
//  Created by 李 on 2018/6/2.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "ProjectCollectionViewCell.h"

@interface ProjectCollectionViewCell ()

@property (nonatomic,strong) UIImageView   * coverImage;
@property (nonatomic,strong) UILabel       * titleLabel;
@property (nonatomic,strong) UILabel       * timeLabel;

@end

@implementation ProjectCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
        [self setUpUI:frame];
    }
    return self;
}

- (void)setUpUI:(CGRect)frame{
    
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [backView.layer setBorderWidth:1];
    [backView.layer setBorderColor:[UIColor colorWithHexString:@"#efefef"].CGColor];
    [backView setClipsToBounds:YES];
    [backView.layer setCornerRadius:5];
    [self addSubview:backView];
    
    self.coverImage = [Tools creatImage:CGRectMake(0, 0, width , width) image:@"project_process_case"];
    [backView addSubview:self.coverImage];
    
    self.titleLabel = [Tools creatLabel:CGRectMake(MDXFrom6(10), width+MDXFrom6(10), width - MDXFrom6(20), MDXFrom6(20)) font:[UIFont systemFontOfSize:MDXFrom6(16)] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:@"水电部工作也"];
    [backView addSubview:self.titleLabel];
    
    self.timeLabel = [Tools creatLabel:CGRectMake(MDXFrom6(10), width+MDXFrom6(35), width - MDXFrom6(20), MDXFrom6(20)) font:[UIFont systemFontOfSize:MDXFrom6(12)] color:[UIColor colorWithHexString:@"#666666"] alignment:(NSTextAlignmentLeft) title:@"发布于04-12"];
    [backView addSubview:self.timeLabel];
}

@end
