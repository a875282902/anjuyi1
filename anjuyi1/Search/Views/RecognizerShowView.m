//
//  RecognizerShowView.m
//  anjuyi1
//
//  Created by apple on 2019/2/20.
//  Copyright © 2019 lsy. All rights reserved.
//

#import "RecognizerShowView.h"
#import "SpectrumView.h"

@interface RecognizerShowView ()
{
    BOOL isStart;
}

@property (nonatomic,strong) SpectrumView *spectrumView1;

@property (nonatomic,strong) UILabel  * promptLabel;

@end

@implementation RecognizerShowView


- (instancetype)init{
    
    if (self == [super init]) {
        isStart = NO;
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self setUpUIWithFrame:frame];
}

- (void)setUpUIWithFrame:(CGRect)frame{
    
    //Example 1
    if (!self.spectrumView1) {
        self.promptLabel = [Tools creatLabel:CGRectMake(0, 0, KScreenWidth, frame.size.height - 60) font:[UIFont systemFontOfSize:25] color:GRAYCOLOR alignment:(NSTextAlignmentCenter) title:@"请说，我在聆听..."];
        [self addSubview:self.promptLabel];
        
        self.spectrumView1 = [[SpectrumView alloc] initWithFrame:CGRectMake((KScreenWidth  - 220)/2,frame.size.height -  60,220, 40.0)];
        self.spectrumView1.text = [NSString stringWithFormat:@"%d",0];
        __weak SpectrumView * weakSpectrum = self.spectrumView1;
        
        __block typeof(self) weakSelf = self;
        self.spectrumView1.itemLevelCallback = ^() {
            float power  = 0;
            if (weakSelf->isStart) {
                power  = - arc4random()%80;
            }
            else{
                power = 0;
            }
            weakSpectrum.level = power;
        };
        [self addSubview:self.spectrumView1];
    }
    
    [self.spectrumView1 setFrame:CGRectMake((KScreenWidth  - 220)/2,frame.size.height -  60,220, 40.0)];
    [self.promptLabel setFrame:CGRectMake(0, 0, KScreenWidth, frame.size.height - 60)];
}

- (void)start{
    isStart = YES;
    [self.spectrumView1 start];
}
- (void)stop{
    isStart = NO;
    [self.spectrumView1 stop];
}
@end
