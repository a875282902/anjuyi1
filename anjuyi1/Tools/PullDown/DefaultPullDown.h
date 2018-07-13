//
//  DefaultPullDown.h
//  anjuyi1
//
//  Created by 李 on 2018/6/4.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DefaultPullDown;

@protocol DefaultPullDownDelegate <NSObject>

- (void)dafalutPullDownSelect:(NSInteger)index;

@end

@interface DefaultPullDown : UITableViewController

@property (nonatomic, copy) NSArray *titleArray;

@property (nonatomic ,weak) id<DefaultPullDownDelegate>delegate;

@end
