//
//  PowerStationViewController.m
//  anjuyi1
//
//  Created by apple on 2018/7/19.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "PowerStationViewController.h"

#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
#import <BaiduMapAPI_Map/BMKPinAnnotationView.h>

#import "PowerStatonModel.h"
#import "CustomAnnotationView.h"
#import "PowerStationList.h"
#import "PowerStationDetailsViewController.h"

@interface PowerStationViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate>
{
    CLLocationCoordinate2D _myLocation;
    NSString  * _stationListType;
}

@property (nonatomic,strong)BMKMapView         * mapView;
@property (nonatomic,strong)BMKLocationService * locService;
@property (nonatomic,strong)BMKPointAnnotation * myPoint;
@property (nonatomic,strong)NSMutableArray     * dataArr;
@property (nonatomic,strong)NSMutableArray     * pointArr;
@property (nonatomic,strong)PowerStationList   * powerStationList;

@end

@implementation PowerStationViewController

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
    [self setTitle:@"附近电站"];
    [self.view addSubview:self.mapView];
    
//    _locService = [[BMKLocationService alloc]init];
//    _locService.delegate = self;
//    //启动LocationService
//    [_locService startUserLocationService];
    
    self.powerStationList = [[PowerStationList alloc] initWithFrame:CGRectMake(0, KViewHeight - 290, KScreenWidth, 290)];
    
     __block PowerStationViewController* weakSlef = self;
    
    [self.powerStationList setSelectStaionListType:^(NSInteger index) {
        
        weakSlef-> _stationListType = [NSString stringWithFormat:@"%ld",(1-index)];
        
        [weakSlef getPowerStationData:weakSlef->_myLocation];
    }];
    
    [self.powerStationList setSelectStaionToShowDetails:^(PowerStatonModel *model) {
        PowerStationDetailsViewController *vc = [[PowerStationDetailsViewController alloc] init];
        vc.station_id = model.ID;
        [weakSlef.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.view addSubview:self.powerStationList];
    
}

- (void)getPowerStationData:(CLLocationCoordinate2D)coordinate2D{
    
    if (self.pointArr.count >0) {
        [self.mapView removeAnnotations:self.pointArr];
    }
  
    self.dataArr = [NSMutableArray array];
    self.pointArr = [NSMutableArray array];
    
    NSString *path = [NSString stringWithFormat:@"%@/Charging/charging_store_list",KURL];
    
    NSDictionary * dic = @{@"lng":[NSString stringWithFormat:@"%f",coordinate2D.longitude],@"lat":[NSString stringWithFormat:@"%f",coordinate2D.latitude],@"order":_stationListType,@"page":@"1"};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *dic in responseObject[@"datas"]) {
                    PowerStatonModel *model = [[PowerStatonModel alloc] initWithDictionary:dic];
                    [weakSelf.dataArr addObject:model];
                    
                    BMKPointAnnotation * point = [[BMKPointAnnotation alloc]init];
                    [point setCoordinate:CLLocationCoordinate2DMake([model.lat floatValue], [model.lng floatValue])];
                    [weakSelf.mapView addAnnotation:point];
                    
                    [weakSelf.pointArr addObject:point];
                }
                
                [weakSelf.powerStationList setDataArr:weakSelf.dataArr type:self->_stationListType];
            }
            
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
        _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KViewHeight - 290)];
    }
    return _mapView;
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
        
        
        
        annotationView.image = [UIImage imageNamed:@"direction-icon"];
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
