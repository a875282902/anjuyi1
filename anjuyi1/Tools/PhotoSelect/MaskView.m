//
//  MaskView.m
//  photoSelect
//
//  Created by apple on 2018/6/27.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MaskView.h"

@implementation MaskView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [super drawRect:rect];
    
    [self setBackgroundColor:[UIColor clearColor]];
    
    CGContextRef ref = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBFillColor(ref, 0.15, 0.15, 0.15, 0.6);
    CGContextFillRect(ref, rect);
    
    CGFloat w = rect.size.width;
    
    //中间矩形
    CGRect clearRect = CGRectMake(0, w/4, w, w/2);
    CGContextClearRect(ref, clearRect);
    
    CGContextStrokeRect(ref, clearRect);
    CGContextSetRGBStrokeColor(ref, 1, 1, 1, 1);
//    CGContextSetLineCap(ref, kCGLineCapRound);
    CGFloat lengths[] = {10,5};
    CGContextSetLineDash(ref, 4, lengths, 2);
    CGContextSetLineWidth(ref, 1);
    CGContextAddRect(ref, clearRect);
    CGContextStrokePath(ref);
}


@end
