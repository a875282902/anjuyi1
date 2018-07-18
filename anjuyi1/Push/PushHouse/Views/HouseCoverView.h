//
//  HouseCoverView.h
//  anjuyi1
//
//  Created by apple on 2018/7/17.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HouseCoverViewDlegate <NSObject>

- (void)addCover;

- (void)pushToController:(UIViewController *)vc;

@end

@interface HouseCoverView : UIView

@property (nonatomic,weak)id<HouseCoverViewDlegate>delegate;

@property (nonatomic,strong)NSString        * house_id;
@property (nonatomic,strong)UIImageView     * headerView;

- (void)refreData;


@end
