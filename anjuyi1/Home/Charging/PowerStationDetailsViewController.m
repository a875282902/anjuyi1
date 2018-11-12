//
//  PowerStationDetailsViewController.m
//  anjuyi1
//
//  Created by apple on 2018/7/19.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "PowerStationDetailsViewController.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
#import <BaiduMapAPI_Map/BMKPinAnnotationView.h>
#import "PowerStatonModel.h"
#import "CustomAnnotationView.h"
#import "ProwerStationDetails.h"
#import <MapKit/MapKit.h>

@interface PowerStationDetailsViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate>
{
    CLLocationCoordinate2D _myLocation;
    NSString  * _stationListType;
}

@property (nonatomic,strong)BMKMapView              * mapView;
@property (nonatomic,strong)BMKLocationService      * locService;
@property (nonatomic,strong)BMKPointAnnotation      * myPoint;
@property (nonatomic,strong)NSMutableArray          * dataArr;
@property (nonatomic,strong)NSMutableArray          * pointArr;
@property (nonatomic,strong)NSMutableDictionary     * data;
@property (nonatomic,strong)ProwerStationDetails    * stationDetails;
@property (nonatomic,strong)UIView                  * GPSView;
@property (nonatomic,strong)NSMutableArray          * mapArr;

@end

@implementation PowerStationDetailsViewController

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;// 此处记得不用的时候需要置nil，否则影响内存的释放
    _myPoint = [[BMKPointAnnotation alloc]init];
    _myPoint.coordinate = CLLocationCoordinate2DMake(39.915, 116.404);
    _myLocation = CLLocationCoordinate2DMake(39.915, 116.404);
    _myPoint.title = @"这里是北京";
    _myPoint.subtitle = @"subtitle";
    [_mapView addAnnotation:_myPoint];
    
    _stationListType = @"1";
    
    [self getPowerStationData:_myLocation];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil; // 不用时，置nil
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self baseForDefaultLeftNavButton];
    [self setTitle:@"电站详情"];
    [self.view addSubview:self.mapView];
    
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    [self.view addSubview:self.stationDetails];
    [self.view addSubview:self.GPSView];
    
}

- (ProwerStationDetails *)stationDetails{
    if (!_stationDetails) {
        _stationDetails = [[ProwerStationDetails alloc] initWithFrame:CGRectMake(0, MDXFrom6(200), KScreenWidth, KViewHeight - MDXFrom6(200))];
    }
    return _stationDetails;
}

-(UIView *)GPSView{
    
    if (!_GPSView) {
        _GPSView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        [_GPSView setBackgroundColor:GCOLOR];
        [_GPSView.layer setCornerRadius:30];
        [_GPSView setClipsToBounds:YES];
        [_GPSView setCenter:CGPointMake(KScreenWidth - 50, MDXFrom6(200))];
        
        [_GPSView addSubview:[Tools creatImage:CGRectMake(17.4, 10, 25, 25) image:@"direction-w"]];
        [_GPSView addSubview:[Tools creatLabel:CGRectMake(0, 38, 60, 12) font:[UIFont systemFontOfSize:12] color:[UIColor whiteColor] alignment:(NSTextAlignmentCenter) title:@"到这去"]];
        
        [_GPSView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dohang)]];
        
    }
    return _GPSView;
}
#pragma mark -- 获取电站信息
- (void)getPowerStationData:(CLLocationCoordinate2D)coordinate2D{
    
    if (self.pointArr.count >0) {
        [self.mapView removeAnnotations:self.pointArr];
    }
    
    self.dataArr = [NSMutableArray array];
    self.pointArr = [NSMutableArray array];
    
    NSString *path = [NSString stringWithFormat:@"%@/Charging/charging_detail",KURL];
    
    NSDictionary * dic = @{@"lng":[NSString stringWithFormat:@"%f",coordinate2D.longitude],@"lat":[NSString stringWithFormat:@"%f",coordinate2D.latitude],@"id":self.station_id};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            if ([responseObject[@"datas"] isKindOfClass:[NSDictionary class]]) {
                
                weakSelf.data = [NSMutableDictionary dictionaryWithDictionary:responseObject[@"datas"]];
            }
            
            [weakSelf.stationDetails setStationData:weakSelf.data];
            
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
    
}

- (BMKMapView *)mapView{
    
    if (!_mapView) {
        _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth,MDXFrom6(200))];
    }
    return _mapView;
}

#pragma mark - 导航方法
- (void)dohang{
    
    
    self.mapArr = [NSMutableArray arrayWithArray:[self getInstalledMapAppWithEndLocation:CLLocationCoordinate2DMake([self.data[@"lat"] floatValue], [self.data[@"lng"] floatValue])]];


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
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=%@&mode=driving&coord_type=gcj02",endLocation.latitude,endLocation.longitude,@"222"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        baiduMapDic[@"url"] = urlString;
        [maps addObject:baiduMapDic];
    }
    
    //高德地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        NSMutableDictionary *gaodeMapDic = [NSMutableDictionary dictionary];
        gaodeMapDic[@"title"] = @"高德地图";
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",@"2222",@"anjuyi",endLocation.latitude,endLocation.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        gaodeMapDic[@"url"] = urlString;
        [maps addObject:gaodeMapDic];
    }
//        //谷歌地图
//        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
//            NSMutableDictionary *googleMapDic = [NSMutableDictionary dictionary];
//            googleMapDic[@"title"] = @"谷歌地图";
//            NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",@"导航测试",@"nav123456",endLocation.latitude, endLocation.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            googleMapDic[@"url"] = urlString;
//            [maps addObject:googleMapDic];
//        }
    
        //腾讯地图
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
            NSMutableDictionary *qqMapDic = [NSMutableDictionary dictionary];
            qqMapDic[@"title"] = @"腾讯地图";
            NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%f,%f&to=终点&coord_type=1&policy=0",endLocation.latitude, endLocation.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            qqMapDic[@"url"] = urlString;
            [maps addObject:qqMapDic];
        }
    
    return maps;
}

- (void)selfMap{
    
    float myX = _myLocation.latitude;
    float myY = _myLocation.longitude;
    float latitude = [self.data[@"lat"] floatValue];
    float longitude = [self.data[@"lng"] floatValue];
    
    NSLog(@"%f --- %f --- %f --- %f",myX ,myY ,latitude ,longitude);
    CLLocationCoordinate2D coords1 = CLLocationCoordinate2DMake(myX, myY);
    CLLocationCoordinate2D coords2 = CLLocationCoordinate2DMake(latitude, longitude);
    //当前的位置 //
    //MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coords1 addressDictionary:nil]]; //起点
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coords2 addressDictionary:nil]]; //终点
    currentLocation.name = @"当前位置";
    toLocation.name = self.data[@"name"];
    NSArray *items = [NSArray arrayWithObjects:currentLocation, toLocation, nil]; NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES}; //打开苹果自身地图应用，并呈现特定的item
    [MKMapItem openMapsWithItems:items launchOptions:options];
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
    
    _myPoint.coordinate = userLocation.location.coordinate;
    _myLocation = userLocation.location.coordinate;
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [self.mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    
    [self getPowerStationData:userLocation.location.coordinate];
    
    [self.locService stopUserLocationService];
}


- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[BMKPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        
        if (![annotation isEqual:_myPoint]) {
            annotationView.image = [UIImage imageNamed:@"fj_cdz"];
        }
        annotationView.canShowCallout = YES;
        return annotationView;
    }
    
    
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
