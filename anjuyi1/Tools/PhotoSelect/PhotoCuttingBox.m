//
//  PhotoCuttingBox.m
//  photoSelect
//
//  Created by apple on 2018/6/27.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "PhotoCuttingBox.h"
#import "MaskView.h"

@interface PhotoCuttingBox ()<UIScrollViewDelegate>
{
    BOOL _isMove;//具有剪切范围
    CGFloat _moveHeight; // 可以出的范围
}

@property (nonatomic,strong) UIScrollView  * imageBack;
@property (nonatomic,strong) UIImageView   * selectImage;

@end

@implementation PhotoCuttingBox

- (instancetype)initWithFrame:(CGRect)frame withIsClip:(BOOL)isClip WithSize:(CGSize)clipSize{
    
    if (self == [super initWithFrame:frame]) {
        _isMove = isClip;
        _moveHeight = (frame.size.height - clipSize.height)/2;
        
        [self creatImageViewWithFrame:frame withIsClip:isClip WithSize:clipSize];
    }
    return self;
}

#pragma mark -- 选中的图片
- (void)creatImageViewWithFrame:(CGRect)frame withIsClip:(BOOL)isClip WithSize:(CGSize)clipSize{
    
    self.imageBack = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
    [self.imageBack setShowsHorizontalScrollIndicator:NO];
    [self.imageBack setShowsVerticalScrollIndicator:NO];
    [self.imageBack setMinimumZoomScale:1.0f];
    [self.imageBack setMaximumZoomScale:2.0f];
    [self.imageBack setZoomScale:1.0f animated:YES];
    [self.imageBack setDelegate:self];
    [self addSubview:self.imageBack];
    
    self.selectImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
    [self.selectImage setClipsToBounds:YES];
    [self.selectImage setContentMode:(UIViewContentModeScaleAspectFit)];
    [self.imageBack addSubview:self.selectImage];
    
    if (isClip) {
        MaskView *v = [[MaskView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
        [v setUserInteractionEnabled:NO];
        [v setBackgroundColor:[UIColor clearColor]];
        [self addSubview:v];
    }
    
}

- (void)changeImage:(UIImage *)image{
    
    [self.imageBack setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self.imageBack setContentSize:[self scrollViewContentSize:image]];
    [self.selectImage setFrame:CGRectMake(0, 0, [self scrollViewContentSize:image].width, [self scrollViewContentSize:image].height)];
    
    [self.selectImage setImage:image];

}

- (CGSize)scrollViewContentSize:(UIImage *)image{
    
    CGSize size;
    
    CGFloat width = self.frame.size.width;
    
    if (image.size.height > image.size.width) {
        
        size = CGSizeMake(_isMove?width+1:width , width *((CGFloat)image.size.height/(CGFloat)image.size.width));
    }
    else{
        
        size = CGSizeMake(width *((CGFloat)image.size.width/(CGFloat)image.size.height), _isMove?width+1:width);
    }
    
    return size;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (_isMove) {
        if (scrollView.contentOffset.y > -_moveHeight && scrollView.contentOffset.y <= 0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        }
        
        if (scrollView.contentOffset.y < scrollView.contentSize.height +_moveHeight - scrollView.frame.size.height &&  scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height) {
            
            if (scrollView.contentSize.height - scrollView.frame.size.height == 1 ) {
                
                scrollView.contentInset = UIEdgeInsetsMake(0, 0, scrollView.contentOffset.y, 0);
            }
            else{
                scrollView.contentInset = UIEdgeInsetsMake(0, 0, - (scrollView.contentOffset.y - scrollView.frame.size.height ), 0);
                
                NSLog(@"%f", scrollView.contentOffset.y - scrollView.frame.size.height);
            }
        }
        
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.selectImage;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale

{
    //把当前的缩放比例设进ZoomScale，以便下次缩放时实在现有的比例的基础上
    NSLog(@"scale is %f",scale);
    [scrollView setZoomScale:scale animated:NO];
}

// 缩放时调用
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    // 可以实时监测缩放比例
//    NSLog(@"......scale is %f",scrollView.zoomScale);
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
