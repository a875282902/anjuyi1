//
//  CommentTableViewCell.m
//  anjuyi1
//
//  Created by 李 on 2018/6/2.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "MessageTableViewCell.h"

@interface MessageTableViewCell ()

@property (nonatomic,strong) UIView      * backView;
@property (nonatomic,strong) UILabel     * titleLabel;
@property (nonatomic,strong) UILabel     * typeLabel;
@property (nonatomic,strong) UILabel     * detailLabel;
@property (nonatomic,strong) UILabel     * timeLabel;
@property (nonatomic,strong) UIView      * redView;

@end

@implementation MessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(MDXFrom6(10), MDXFrom6(15), KScreenWidth - MDXFrom6(20), 40)];
    [self.backView.layer setCornerRadius:5];
    [self.backView.layer setBorderWidth:1];
    [self.backView.layer setBorderColor:[UIColor colorWithHexString:@"#eeeeee"].CGColor];
    [self addSubview:self.backView];
    
    self.titleLabel = [Tools creatLabel:CGRectMake(MDXFrom6(15), MDXFrom6(15), MDXFrom6(315), 20) font:[UIFont systemFontOfSize:16] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:@""];
    [self.backView addSubview:self.titleLabel];
    
    self.typeLabel = [Tools creatLabel:CGRectMake(MDXFrom6(15), MDXFrom6(15), MDXFrom6(40), MDXFrom6(20)) font:[UIFont systemFontOfSize:12] color:[UIColor whiteColor] alignment:(NSTextAlignmentCenter) title:@"风格"];
    [self.typeLabel setBackgroundColor:GCOLOR];
    [self.typeLabel.layer setCornerRadius:2];
    [self.typeLabel setClipsToBounds:YES];
    [self.backView addSubview:self.typeLabel];
    
    self.detailLabel = [Tools creatLabel:CGRectMake(MDXFrom6(15), MDXFrom6(15), MDXFrom6(315), 20) font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentLeft) title:@""];
    [self.backView addSubview:self.detailLabel];
    
    self.timeLabel = [Tools creatLabel:CGRectMake(MDXFrom6(15), MDXFrom6(15), MDXFrom6(315), 20) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentLeft) title:@""];
    [self.backView addSubview:self.timeLabel];
    
    self.redView = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth-MDXFrom6(20)-8, 0, 8, 8)];
    [self.redView setHidden:YES];
    [self.redView setBackgroundColor:[UIColor redColor]];
    [self.redView.layer setCornerRadius:4];
    [self.backView addSubview:self.redView];
    
}

- (void)bandDataWith:(NSDictionary *)dic{
    
    [self.titleLabel setFrame:CGRectMake(MDXFrom6(15), MDXFrom6(15), MDXFrom6(315),[dic[@"titleHight"] floatValue])];
    [self.titleLabel setText:dic[@"title"]];
    
    NSInteger h = [dic[@"titleWidth"] floatValue]/MDXFrom6(315);
    
    CGFloat wid = [dic[@"titleWidth"] floatValue] -  MDXFrom6(315) *h;
    
    h = [dic[@"titleHight"] floatValue];
    
    if (wid > MDXFrom6(255)) {
        
        h += MDXFrom6(20);
        
        [self.typeLabel setFrame:CGRectMake(MDXFrom6(15),h , MDXFrom6(40),16)];
        
        h += MDXFrom6(10)+16;
        
        [self.detailLabel setFrame:CGRectMake(MDXFrom6(15),h, MDXFrom6(315),[dic[@"detailHight"] floatValue])];
        [self.detailLabel setText:dic[@"detail"]];
        
        h += MDXFrom6(6) + [dic[@"detailHight"] floatValue];
        
        [self.timeLabel setFrame:CGRectMake(MDXFrom6(15), h, MDXFrom6(315),MDXFrom6(20))];
        
        h += MDXFrom6(20)+15;

    }
    else{

        [self.typeLabel setFrame:CGRectMake(MDXFrom6(15)+wid,h-16+MDXFrom6(15), MDXFrom6(40),16)];
        
        h += MDXFrom6(10) + 16;
        
        [self.detailLabel setFrame:CGRectMake(MDXFrom6(15), h, MDXFrom6(315),[dic[@"detailHight"] floatValue])];
        [self.detailLabel setText:dic[@"detail"]];
        
        h += MDXFrom6(25) + [dic[@"detailHight"] floatValue];
        
        [self.timeLabel setFrame:CGRectMake(MDXFrom6(15),h, MDXFrom6(315),MDXFrom6(20))];
        
        h += MDXFrom6(20) +15;
    
    }
    
    [self.backView setFrame:CGRectMake(MDXFrom6(10), MDXFrom6(15), KScreenWidth - MDXFrom6(20), h)];
    
    NSArray *arr = @[@"",@"系统",@"评论",@"点赞",@"收藏"];
    [self.typeLabel setText:arr[[dic[@"type"] integerValue]]];
    [self.timeLabel setText:dic[@"pdate"]];
    if ([dic[@"status"] integerValue] == 1) {
        [self.redView setHidden:NO];
    }
    else {
        [self.redView setHidden:YES];
    }
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
