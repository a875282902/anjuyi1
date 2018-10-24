//
//  LaunchADView.h
//  anjuyi1
//
//  Created by apple on 2018/10/18.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LaunchADView : UIImageView
/**
 *
 */
@property(nonatomic,copy)void(^endShowBlock)();

@property(nonatomic,copy)void(^tapAdViewBlock)();

@property(nonatomic,strong)UIImageView * adImageView;


/**
 * 创建广告图
 */
+(instancetype)createADViewWithADImageName:(NSString *)imageName;



@end

NS_ASSUME_NONNULL_END
