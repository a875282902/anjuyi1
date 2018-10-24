//
//  FunctionBarView.m
//  anjuyi1
//
//  Created by apple on 2018/10/23.
//  Copyright © 2018 lsy. All rights reserved.
//

#import "FunctionBarView.h"

@implementation FunctionBarView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    self = [[[NSBundle mainBundle] loadNibNamed:@"FunctionBarView" owner:self options:nil] lastObject];
    
    if (self) {
        self.frame = frame;
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
