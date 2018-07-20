//
//  CustomAnnotationView.h
//  anjuyi1
//
//  Created by apple on 2018/7/20.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKAnnotationView.h>
#import "CustomPaopaotView.h"

@interface CustomAnnotationView : BMKAnnotationView

@property (nonatomic, readonly) CustomPaopaotView *paopaoView;

@end
