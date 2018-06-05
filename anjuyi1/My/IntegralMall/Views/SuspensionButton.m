//
//  SuspensionButton.m
//  有家云宅
//
//  Created by 李 on 17/3/22.
//  Copyright © 2017年 有家. All rights reserved.
//

#import "SuspensionButton.h"

@interface SuspensionButton ()
{
     CGRect _windowSize;
    CGPoint _originalPosition;
    
    BOOL _isOnLeft;
    CGPoint _tempCenter;
}


@end

@implementation SuspensionButton

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MDXFrom6Height(20), MDXFrom6Height(20))];
        [imageView setCenter:CGPointMake(MDXFrom6Height(25), MDXFrom6Height(20))];
        [imageView setImage:[UIImage imageNamed:@"shop_cart_white"]];
        [self addSubview:imageView];
        
        [self addSubview:[Tools creatLabel:CGRectMake(0, MDXFrom6(30), MDXFrom6(50), MDXFrom6(20)) font:[UIFont systemFontOfSize:MDXFrom6(10)] color:[UIColor whiteColor] alignment:(NSTextAlignmentCenter) title:@"购物车"]];
        
        [self setBackgroundColor:MDRGBA(0, 188, 185, 1)];
        [self.layer setCornerRadius:MDXFrom6Height(25)];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
    }
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"touchBegan");
    
    _originalPosition = [[touches anyObject] locationInView:self];
    _tempCenter = self.center;
    
    //    self.backgroundColor = [UIColor greenColor];//移动过程中的颜色
    
    CGAffineTransform toBig = CGAffineTransformMakeScale(1.2, 1.2);//变大
    
    [UIView animateWithDuration:0.1 animations:^{
        // Translate bigger
        self.transform = toBig;
        
    } completion:^(BOOL finished)   {}];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"touchMove");
    
    CGPoint currentPosition = [[touches anyObject] locationInView:self];
    float detaX = currentPosition.x - _originalPosition.x;
    float detaY = currentPosition.y - _originalPosition.y;
    
    CGPoint targetPositionSelf = self.center;
    targetPositionSelf.x += detaX;
    targetPositionSelf.y += detaY;
    self.center = targetPositionSelf;
    //修改，让_buttonListView.center不跟着button移动
    //    _buttonListView.center = targetPositionButtonList;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"touchCancell");
    
    // 触发touchBegan后，tap手势被识别后会将touchMove和touchEnd的事件截取掉触发自身手势回调，然后运行touchCancell。touchBegan中设置的按钮状态在touchEnd和按钮触发方法两者中分别设置还原。
    
    
    
    CGAffineTransform toNormal = CGAffineTransformTranslate(CGAffineTransformIdentity, 1/1.2, 1/1.2);
    
    [UIView animateWithDuration:.1 animations:^{
        self.transform = toNormal;
    }];
    
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"touchEnd");
    
    CGAffineTransform toNormal = CGAffineTransformTranslate(CGAffineTransformIdentity, 1/1.2, 1/1.2);
    
    [UIView animateWithDuration:.1 animations:^{
       self.transform = toNormal;
    }];
    
//    CGPoint newPosition = [self correctPosition:self.frame.origin];
//
//    [UIView animateWithDuration:0.1 animations:^{
//
//        // Translate normal
//        self.transform = toNormal;
//
//    } completion:^(BOOL finished) {
//
//        [UIView animateWithDuration:0.4 animations:^{
//            self.frame = CGRectMake(newPosition.x, newPosition.y, self.bounds.size.width, self.bounds.size.height);
//            //            [self adjustButtonListView];
//        }];
//
//    }];
}
- (CGPoint)correctPosition:(CGPoint)pos
{
    CGPoint newPosition;
    newPosition = pos;
    if (pos.x< KScreenWidth/2) {
        newPosition.x = 0;
    }else{
        newPosition.x = KScreenWidth-MDXFrom6Height(40);
    }
    
    return newPosition;
}

- (void)tap{

    [self.delegate showProcess];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
