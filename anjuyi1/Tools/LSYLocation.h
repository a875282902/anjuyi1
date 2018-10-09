//
//  LSYLocation.h
//  anjuyi1
//
//  Created by apple on 2018/8/5.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>

@protocol LSYLocationDelegta <NSObject>

- (void)loctionWithProvince:(NSDictionary *)province city:(NSDictionary *)city area:(NSDictionary *)area;
@end

@interface LSYLocation : NSObject

@property (nonatomic, weak) id<LSYLocationDelegta> delegate;

/*
 * 开始定位
 */
- (void)beginUpdatingLocation;

- (void)endLocation;

@end
