//
//  RecognizerView.h
//  anjuyi1
//
//  Created by apple on 2019/2/20.
//  Copyright © 2019 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RecognizerViewDelegate <NSObject>

- (void)speechRecognitionWithSuccess:(BOOL)isSuccess withString:(NSString *)result;
- (void)speechRecognitionIsShow:(BOOL)isShow;

@end

@interface RecognizerView : UIView

@property (nonatomic,weak)id<RecognizerViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
