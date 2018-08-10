//
//  PowerStationList.m
//  anjuyi1
//
//  Created by apple on 2018/7/20.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "ProwerStationDetails.h"
#import "SDPhotoBrowserd.h"

#define padding 15

@interface ProwerStationDetails ()<UIScrollViewDelegate,SDPhotoBrowserDelegate>
{
    UIButton *_selectBtn;
    NSString *_seletType;
}

@property (nonatomic,strong)UIScrollView       * tmpScrollView;



@end

@implementation ProwerStationDetails

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
        [self addSubview:self.tmpScrollView];
    }
    return self;
}

- (void)setStationData:(NSMutableDictionary *)stationData{
    _stationData = stationData;
    
    [self setUpUI];
}

#pragma mark -- scrollview
-(UIScrollView *)tmpScrollView{
    
    if (!_tmpScrollView) {
        _tmpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KViewHeight)];
        if (@available(iOS 11.0, *)) {
            [_tmpScrollView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpScrollView setShowsVerticalScrollIndicator:NO];
        [_tmpScrollView setShowsHorizontalScrollIndicator:NO];
        [_tmpScrollView setDelegate:self];
    }
    return _tmpScrollView;
}

- (void)setUpUI{
    
    [self.tmpScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat height = 0;
    
    [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(padding, height, KScreenWidth - padding - 85, 70) font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#212121"] alignment:(NSTextAlignmentLeft) title:self.stationData[@"name"]]];
    
    height += 70;
    
    [self.tmpScrollView addSubview:[Tools creatImage:CGRectMake(padding, height, 14, 14) image:@"add_add"]];
    
    [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(padding + 20, height, KScreenWidth - padding - 85, 14) font:[UIFont systemFontOfSize:14] color:[UIColor colorWithHexString:@"#000000"] alignment:(NSTextAlignmentLeft) title:self.stationData[@"address"]]];
    
    height += 24;
    
    UILabel *details = [Tools creatLabel:CGRectMake(padding, height, KScreenWidth - padding - 85, 15) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentLeft) title:@""];
    [self.tmpScrollView addSubview:details];
    
    NSString *str = [NSString stringWithFormat:@"%@      %@",self.stationData[@"distance"],self.stationData[@"business"]];
    
    NSMutableAttributedString *arrs = [[NSMutableAttributedString alloc] initWithString:str];
    [arrs addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, [self.stationData[@"distance"] length])];
    [arrs addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FF9500"] range:NSMakeRange(0, [self.stationData[@"distance"] length])];
    [details setAttributedText:arrs];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth - 75, 50,75 , 50)];
    [backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone)]];
    [self addSubview:backView];
    
    [backView addSubview:[Tools creatImage:CGRectMake(15, 0, 20, 20) image:@"map-phone"]];
    [backView addSubview:[Tools creatLabel:CGRectMake(0, 25, 50, 12) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#5cc6c6"] alignment:(NSTextAlignmentCenter) title:@"打电话"]];
    
    height += 30;
    
    [self.tmpScrollView addSubview:[Tools setLineView:CGRectMake(0, height, KScreenWidth, 1)]];
    
    height += 20;
    
    [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(padding , height, KScreenWidth - padding*2, 18) font:[UIFont systemFontOfSize:18] color:[UIColor colorWithHexString:@"#000000"] alignment:(NSTextAlignmentLeft) title:@"门店照片"]];
    
    height += 38;
    
    CGFloat w = (KScreenWidth - padding *3)/2;
    
    if ([self.stationData[@"img"] isKindOfClass:[NSArray class]]) {
        for (NSInteger i = 0 ; i < [self.stationData[@"img"] count] ; i ++) {
            NSDictionary *dic = self.stationData[@"img"][i];
            UIImageView *imageView = [Tools creatImage:CGRectMake(padding +(w +padding)*(i%2), height + (w +padding)*(i/2), w, w) url:dic[@"img"] image:@""];
            [imageView setClipsToBounds:YES];
            [imageView.layer setCornerRadius:5];
            [imageView setTag:i];
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImage:)]];
            [self.tmpScrollView addSubview:imageView];
        }
        
        height += (w+padding)*ceil([self.stationData[@"img"] count]/2);
    }
    
   
    
    [self.tmpScrollView setContentSize:CGSizeMake(KScreenWidth, height)];
    
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    
//    if (scrollView.contentOffset.y > 0 ) {
//        [UIView animateWithDuration:.2 animations:^{
//            [self setFrame:CGRectMake(0, 0, KScreenWidth, KViewHeight)];
//            [self.tmpScrollView setFrame:CGRectMake(0, 0, KScreenWidth, KViewHeight)];
//        }];
//    }
//    
//    if (scrollView.contentOffset.y < 0 ) {
//        [UIView animateWithDuration:.2 animations:^{
//            [self setFrame:CGRectMake(0, MDXFrom6(200), KScreenWidth, KViewHeight - MDXFrom6(200))];
//            [self.tmpScrollView setFrame:CGRectMake(0, 0, KScreenWidth, KViewHeight - MDXFrom6(200))];
//        }];
//    }
//}

- (void)callPhone{
    
    NSString *cleanedString =[[self.stationData[@"phone"] componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    NSString *escapedPhoneNumber = [cleanedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *str_url = [[NSString alloc]initWithFormat:@"tel://%@", escapedPhoneNumber];
    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:str_url, escapedPhoneNumber]];
    UIWebView *mCallWebview = [[UIWebView alloc] init] ;
    [self addSubview:mCallWebview];
    [mCallWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
}

-(void)showImage:(UITapGestureRecognizer *)sender{
    
    SDPhotoBrowserd *browser = [[SDPhotoBrowserd alloc] init];
    browser.imageCount = [self.stationData[@"img"] count]; // 图片总数
    browser.currentImageIndex = sender.view.tag;
    browser.sourceImagesContainerView = self.superview; // 原图的父控件
    browser.delegate = self;
    [browser show];
}
// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowserd *)browser highQualityImageURLForIndex:(NSInteger)index {
    
    
    return [NSURL URLWithString:self.stationData[@"img"][index][@"img"]];
    
}


@end
