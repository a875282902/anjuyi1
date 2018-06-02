//
//  SearchView.h
//  anjuyi1
//
//  Created by 李 on 2018/5/29.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SearchView : UIView

- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title;

@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;
-(void)addTarget:(id)target action:(SEL)action;

@end
