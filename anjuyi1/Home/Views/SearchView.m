//
//  SearchView.m
//  anjuyi1
//
//  Created by 李 on 2018/5/29.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "SearchView.h"

@implementation SearchView

- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title{
    
    if (self == [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        
        [self setUpViewWithFrame:frame title:title];
        
        
    }
    return self;
}

- (void)setUpViewWithFrame:(CGRect)frame title:(NSString *)title{
    
    [self setFrame:frame];
    [self.layer setBorderWidth:2.0f];
    [self.layer setBorderColor:[UIColor colorWithHexString:@"#d1d1d1"].CGColor];
    [self.layer setCornerRadius:2.5f];
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 19, 18)];
    [icon setImage:[UIImage imageNamed:@"search"]];
    [icon setCenter:CGPointMake(20, 15)];
    [self addSubview:icon];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, MDXFrom6(320)-40, 30)];
    [label setText:title];
    [label setTextColor:[UIColor colorWithHexString:@"#999999"]];
    [label setFont:[UIFont systemFontOfSize:12]];
    [self addSubview:label];
    
    
    
}

-(void)addTarget:(id)target action:(SEL)action
{
    self.target = target;
    self.action = action;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //如果self.target表示的对象中, self.action表示的方法存在的话
    if([self.target respondsToSelector:self.action])
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:self.action withObject:self];
#pragma clang diagnostic pop
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
