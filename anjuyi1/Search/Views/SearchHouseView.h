//
//  SearchHouseView.h
//  anjuyi1
//
//  Created by apple on 2018/9/26.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchHouseView : UIView
@property (nonatomic , strong) NSString *keyword;
@property (nonatomic , copy) void (^selectHouseToShowDetalis)(UIViewController *vc);
@end
