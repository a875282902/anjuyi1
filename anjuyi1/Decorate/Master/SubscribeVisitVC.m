//
//  SubscribeVisitVC.m
//  anjuyi1
//
//  Created by 李 on 2018/6/9.
//  Copyright © 2018年 lsy. All rights reserved.
//
//  预约参观

#import "SubscribeVisitVC.h"
#import <MapKit/MapKit.h>

@interface SubscribeVisitVC ()

@property (nonatomic , strong)NSMutableArray * mapArr;

@end

@implementation SubscribeVisitVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self baseForDefaultLeftNavButton];
    
    self.mapArr = [NSMutableArray array];
    
    [self.view addSubview:[Tools creatLabel:CGRectMake(30, 50, KScreenWidth-60, 30) font:[UIFont systemFontOfSize:21] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:@"预约参观"]];
    
    UIButton *GPS = [Tools creatButton:CGRectMake(30, 130, 125, 25) font:[UIFont systemFontOfSize:14] color:[UIColor blackColor] title:@" 导航预约位置" image:@"yy_dh"];
    [GPS addTarget:self action:@selector(gpsToLocation) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:GPS];
    
    NSArray *tArr = @[@"工作位置",@"可参观时间",@"工长姓名"];
    
    for (NSInteger i = 0 ; i < 3 ; i++) {
        [self.view addSubview:[Tools creatLabel:CGRectMake(30, 170 + 50*i, 90, 50) font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentLeft) title:tArr[i]]];
        [self.view addSubview:[Tools creatLabel:CGRectMake(120, 170 + 50*i, KScreenWidth - 150, 50) font:[UIFont systemFontOfSize:14] color:[UIColor colorWithHexString:@"#3b3b3b"] alignment:(NSTextAlignmentLeft) title:tArr[i]]];
        
        [self.view addSubview:[Tools setLineView:CGRectMake(30, 219 + 50*i, KScreenWidth - 60, 1)]];
    }
    UIButton *sureBtn = [Tools creatButton:CGRectMake(30, 370 , KScreenWidth - 60,50) font:[UIFont systemFontOfSize:14] color:[UIColor whiteColor] title:@"预约参观" image:@""];
    [sureBtn.layer setCornerRadius:5];
    [sureBtn addTarget:self action:@selector(subscribeVisit) forControlEvents:(UIControlEventTouchUpInside)];
    [sureBtn setBackgroundColor:MDRGBA(255, 181, 0, 1)];
    [self.view addSubview:sureBtn];
}

- (void)subscribeVisit{
    
    
}

- (void)gpsToLocation{
    
    [self daohang];
}

-(void)daohang{
    
//    float myX = [self.location[@"position_x"] floatValue];
//    float myY = [self.location[@"position_y"] floatValue];
//    float latitude = [self.location[@"position_x"] floatValue];
//    float longitude = [self.location[@"position_y"] floatValue];

//    NSLog(@"%f --- %f --- %f --- %f",myX ,myY ,latitude ,longitude);
    CLLocationCoordinate2D coords1 = CLLocationCoordinate2DMake(116.403981, 39.924453);
//    CLLocationCoordinate2D coords2 = CLLocationCoordinate2DMake(latitude, longitude);
    //    //当前的位置 //
    //    //MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    //    MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coords1 addressDictionary:nil]]; //起点
    //    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coords2 addressDictionary:nil]]; //终点
    //    currentLocation.name = @"当前位置";
    //    toLocation.name = self.location[@"name"];
    //    NSArray *items = [NSArray arrayWithObjects:currentLocation, toLocation, nil]; NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES}; //打开苹果自身地图应用，并呈现特定的item
    //    [MKMapItem openMapsWithItems:items launchOptions:options];
    
    
    self.mapArr = [NSMutableArray arrayWithArray:[self getInstalledMapAppWithEndLocation:coords1]];
    
    
    [self creatAlertViewControllerWithMessage:@"地图选择"];
    
}

- (void)creatAlertViewControllerWithMessage:(NSString *)message{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    
    for (NSDictionary *dic in self.mapArr) {
        UIAlertAction *trueA = [UIAlertAction actionWithTitle:dic[@"title"] style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
            if ([dic[@"title"] isEqualToString:@"苹果地图"]) {
                [self selfMap];
            }
            else{
                NSString *urlString = dic[@"url"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            }
            
        }];
        
        [alert addAction:trueA];
    }
    
    UIAlertAction *trueA = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
        
        
    }];
    
    [alert addAction:trueA];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
#pragma mark - 导航方法
- (NSArray *)getInstalledMapAppWithEndLocation:(CLLocationCoordinate2D)endLocation
{
    NSMutableArray *maps = [NSMutableArray array];
    
    //苹果地图
    NSMutableDictionary *iosMapDic = [NSMutableDictionary dictionary];
    iosMapDic[@"title"] = @"苹果地图";
    [maps addObject:iosMapDic];
    
    //百度地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        NSMutableDictionary *baiduMapDic = [NSMutableDictionary dictionary];
        baiduMapDic[@"title"] = @"百度地图";
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=%@&mode=driving&coord_type=gcj02",endLocation.latitude,endLocation.longitude,@"故宫"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        baiduMapDic[@"url"] = urlString;
        [maps addObject:baiduMapDic];
    }
    
    //高德地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        NSMutableDictionary *gaodeMapDic = [NSMutableDictionary dictionary];
        gaodeMapDic[@"title"] = @"高德地图";
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",@"故宫",@"anjuyi",endLocation.latitude,endLocation.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        gaodeMapDic[@"url"] = urlString;
        [maps addObject:gaodeMapDic];
    }
    //    //谷歌地图
    //    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
    //        NSMutableDictionary *googleMapDic = [NSMutableDictionary dictionary];
    //        googleMapDic[@"title"] = @"谷歌地图";
    //        NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",@"导航测试",@"nav123456",endLocation.latitude, endLocation.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //        googleMapDic[@"url"] = urlString;
    //        [maps addObject:googleMapDic];
    //    }
    //
    //    //腾讯地图
    //    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
    //        NSMutableDictionary *qqMapDic = [NSMutableDictionary dictionary];
    //        qqMapDic[@"title"] = @"腾讯地图";
    //        NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%f,%f&to=终点&coord_type=1&policy=0",endLocation.latitude, endLocation.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //        qqMapDic[@"url"] = urlString;
    //        [maps addObject:qqMapDic];
    //    }
    
    return maps;
}

- (void)selfMap{
    
//    float myX = mylocation.latitude;
//    float myY = mylocation.longitude;
//    float latitude = [self.location[@"position_x"] floatValue];
//    float longitude = [self.location[@"position_y"] floatValue];
    
//    NSLog(@"%f --- %f --- %f --- %f",myX ,myY ,latitude ,longitude);
    CLLocationCoordinate2D coords1 = CLLocationCoordinate2DMake(116.403981, 39.924453);
    //116.147677,39.750069
    CLLocationCoordinate2D coords2 = CLLocationCoordinate2DMake(116.147677, 39.750069);
    //当前的位置 //
    //MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coords1 addressDictionary:nil]]; //起点
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coords2 addressDictionary:nil]]; //终点
    currentLocation.name = @"当前位置";
    toLocation.name = @"故宫";
    NSArray *items = [NSArray arrayWithObjects:currentLocation, toLocation, nil]; NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES}; //打开苹果自身地图应用，并呈现特定的item
    [MKMapItem openMapsWithItems:items launchOptions:options];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
