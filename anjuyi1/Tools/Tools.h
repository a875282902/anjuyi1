//
//  Tools.h
//  anjuyi1
//
//  Created by 李 on 2018/5/29.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject

+(UILabel *)creatLabel:(CGRect)rect font:(UIFont *)font color:(UIColor*)color alignment:(NSTextAlignment)alignment title:(NSString *)title;
+(UILabel *)creatAttributedLabel:(CGRect)rect font:(UIFont *)font color:(UIColor*)color  title:(NSString *)title image:(NSString *)imageName alignment:(NSTextAlignment)alignment;



+ (UIView *)setLineView:(CGRect)rect;

+ (UIButton *)creatButton:(CGRect)rect font:(UIFont *)font color:(UIColor *)color title:(NSString *)title image:(NSString *)imageName;

+ (UIImageView *)creatImage:(CGRect)rect image:(NSString *)imageName;

+ (UIImageView *)creatImage:(CGRect)rect url:(NSString *)imageUrl image:(NSString *)imageName;


+(NSString*)getCurrentTimes;


@end
