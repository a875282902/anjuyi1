//
//  MessageListVIew.h
//  anjuyi1
//
//  Created by apple on 2018/10/10.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MessageListVIewDelegate <NSObject>

- (void)pushShowDetail:(NSDictionary *)messageInfo;

@end

@interface MessageListVIew : UIView

@property (nonatomic,strong) NSString * type;

@property (nonatomic,weak) id <MessageListVIewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
