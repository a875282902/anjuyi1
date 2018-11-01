//
//  Tools.h
//  anjuyi1
//
//  Created by 李 on 2018/5/29.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject

/**
 创建label
 *
 *  @param rect label位置
 *  @param font 字体
 *  @param color 颜色
 *  @param alignment 文字位置
 *  @param title 文字
 */
+(UILabel *)creatLabel:(CGRect)rect font:(UIFont *)font color:(UIColor*)color alignment:(NSTextAlignment)alignment title:(NSString *)title;

/**
 创建内容为Attributed后为图片的label
 *
 *  @param rect label位置
 *  @param font 字体
 *  @param color 颜色
 *  @param title 文字
 *  @param imageName 图片名称
 *  @param alignment 文字位置
 */
+(UILabel *)creatAttributedLabel:(CGRect)rect font:(UIFont *)font color:(UIColor*)color  title:(NSString *)title image:(NSString *)imageName alignment:(NSTextAlignment)alignment;


/**
 创建线条
 *
 *  @param rect 线条位置
 */
+ (UIView *)setLineView:(CGRect)rect;

/**
 创建内容button
 *
 *  @param rect button位置
 *  @param font 字体
 *  @param color 颜色
 *  @param title 文字
 *  @param imageName 图片名称
 */
+ (UIButton *)creatButton:(CGRect)rect font:(UIFont *)font color:(UIColor *)color title:(NSString *)title image:(NSString *)imageName;

/**
 创建图片视图
 *
 *  @param rect 图片视图位置
 *  @param imageName 图片名称
 */
+ (UIImageView *)creatImage:(CGRect)rect image:(NSString *)imageName;

/**
 创建网路图片视图
 *
 *  @param rect 图片视图位置
 *  @param imageUrl 图片地址
 *  @param imageName 默认图片名称
 */
+ (UIImageView *)creatImage:(CGRect)rect url:(NSString *)imageUrl image:(NSString *)imageName;


+(NSString*)getCurrentTimes;

/**
 当前ViewController
 */
+ (UIViewController *)getCurrentVC;

@end
