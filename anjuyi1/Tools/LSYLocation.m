//
//  LSYLocation.m
//  anjuyi1
//
//  Created by apple on 2018/8/5.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "LSYLocation.h"


@interface LSYLocation ()<BMKLocationServiceDelegate>

@property (nonatomic,strong)BMKLocationService * locService;

@end

@implementation LSYLocation

- (void)beginUpdatingLocation{
    
    //启动LocationService
    [self.locService startUserLocationService];
}

- (void)endLocation{
    [self.locService stopUserLocationService];
}

- (BMKLocationService *)locService{
    
    if (!_locService) {
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
        
    }
    return _locService;
    
}
#pragma mark -- BMKLocationServiceDelegate
//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    
    [self locationDidEndUpdatingLocation:userLocation];
    
    [self.locService stopUserLocationService];
}

- (void)locationDidEndUpdatingLocation:(BMKUserLocation *)location{
    
    NSString *path = [NSString stringWithFormat:@"%@/currency/getLocation",KURL];
    
    NSDictionary * dic = @{@"lat":[NSString stringWithFormat:@"%f",location.location.coordinate.latitude],
                           @"lng":[NSString stringWithFormat:@"%f",location.location.coordinate.longitude]};
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:dic success:^(id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [weakSelf.delegate loctionWithProvince:@{@"key":responseObject[@"datas"][@"province_id"],@"value":responseObject[@"datas"][@"province"]} city:@{@"key":responseObject[@"datas"][@"city_id"],@"value":responseObject[@"datas"][@"city"]} area:@{@"key":responseObject[@"datas"][@"area_id"],@"value":responseObject[@"datas"][@"area"]}];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [RequestSever showMsgWithError:error];
    }];
    
}



@end
