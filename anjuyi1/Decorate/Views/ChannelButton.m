//
//  ChannelButton.m
//  anjuyi1
//
//  Created by 李 on 2018/5/31.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "ChannelButton.h"

@interface ChannelButton ()

@property (nonatomic,strong)UIImageView *yesImageView;

@end


@implementation ChannelButton

- (void)setFrame:(CGRect)frame{
    self.yesImageView = [Tools creatImage:CGRectMake(frame.size.width-17, frame.size.height-17, 17, 17) image:@"designer_jb"];
    [self.yesImageView setHidden:YES];
    [self addSubview:self.yesImageView];
    [super setFrame:frame];

}

- (void)setSelected:(BOOL)selected{
    
    [self.yesImageView setHidden:!selected];
    
    [super setSelected:selected];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
