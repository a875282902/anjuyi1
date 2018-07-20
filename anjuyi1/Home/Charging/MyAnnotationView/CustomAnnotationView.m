//
//  CustomAnnotationView.m
//  anjuyi1
//
//  Created by apple on 2018/7/20.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "CustomAnnotationView.h"
#import <BaiduMapAPI_Map/BMKAnnotation.h>

#define kCalloutWidth 200.0
#define kCalloutHeight  70.0

@interface CustomAnnotationView ()
@property (nonatomic, strong, readwrite) CustomPaopaotView *paopaoView;
@end

@implementation CustomAnnotationView

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.paopaoView];
    }
    return self;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
    
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected)
    {
        if (self.paopaoView == nil)
        {
            
            /* Construct custom callout. */
            self.paopaoView = [[CustomPaopaotView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
            self.paopaoView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                 -CGRectGetHeight(self.paopaoView.bounds) / 2.f + self.calloutOffset.y);
            
            self.paopaoView.image = [UIImage imageNamed:@"ht_cn"];
            self.paopaoView.title = self.annotation.title;
            self.paopaoView.subtitle = self.annotation.subtitle;
        }
        
        [self addSubview:self.paopaoView];
    }
    else
    {
        [self.paopaoView removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
}

@end
