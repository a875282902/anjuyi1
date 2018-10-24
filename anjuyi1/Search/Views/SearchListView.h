//
//  SearchListView.h
//  anjuyi1
//
//  Created by apple on 2018/9/26.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchListView : UIView

@property (nonatomic , copy) void (^selectHouseToShowDetalis)(UIViewController *vc);

- (void)setUpKeyWord:(NSString *)keyword type:(NSString *)type;

@end
