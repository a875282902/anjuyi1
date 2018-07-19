//
//  HouseCoverView.m
//  anjuyi1
//
//  Created by apple on 2018/7/17.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "HouseCoverView.h"

#import "PushHouseViewController.h"
#import "HouseAreaViewController.h"
#import "HouseCityViewController.h"
#import "HousePriceViewController.h"
#import "TextViewController.h"

@interface HouseCoverView ()<UITableViewDelegate,UITableViewDataSource,TextViewControllerDelegat>
{
    NSString *_title ;
    NSString *_desc;
}

@property (nonatomic,strong)UITableView          * tmpTableView;
@property (nonatomic,strong)NSMutableDictionary  * houseData;

@end

@implementation HouseCoverView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
        _title = @"";
        _desc = @"";
        [self addSubview:self.tmpTableView];
    }
    return self;
}

- (void)setHouse_id:(NSString *)house_id{
    
    _house_id = house_id;
    
    [self getHouseInfo];
}

- (void)refreData{
    
    [self getHouseInfo];
}

- (void)getHouseInfo{

    NSString *path = [NSString stringWithFormat:@"%@/WholeHouse/get_house_info",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:@{@"house_id":self.house_id} success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            weakSelf.houseData = [NSMutableDictionary dictionaryWithDictionary:responseObject[@"datas"]];
            
            [weakSelf.tmpTableView reloadData];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self animated:YES];
        [RequestSever showMsgWithError:error];
    }];
    
}


#pragma mark -- tableView
- (UIImageView *)headerView{
    
    if (!_headerView) {
        _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth , KScreenWidth)];
        [_headerView setUserInteractionEnabled:YES];
        [_headerView setBackgroundColor:MDRGBA(119, 119, 119, 1)];
        
        [_headerView addSubview:[Tools creatImage:CGRectMake((KScreenWidth - 37)/2, MDXFrom6(162), 37, 33) image:@"hdjx_up_w"]];
        [_headerView addSubview:[Tools creatLabel:CGRectMake(0, MDXFrom6(172)+33, KScreenWidth, 15) font:[UIFont systemFontOfSize:15] color:[UIColor whiteColor] alignment:(NSTextAlignmentCenter) title:@"添加封面"]];
        
        [_headerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCover)]];
        
        
    }
    return _headerView;
}

- (UITableView *)tmpTableView{
    
    if (!_tmpTableView) {
        _tmpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth,self.frame.size.height ) style:(UITableViewStylePlain)];
        if (@available(iOS 11.0, *)) {
            [_tmpTableView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpTableView setShowsVerticalScrollIndicator:NO];
        [_tmpTableView setShowsHorizontalScrollIndicator:NO];
        [_tmpTableView setTableHeaderView:self.headerView];
        [_tmpTableView setTableFooterView:[UIView new]];
        [_tmpTableView setDataSource:self];
        [_tmpTableView setDelegate:self];
    }
    return _tmpTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HouseInfoViewControllercell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"HouseInfoViewControllercell"];
    }
    
    NSArray *tArr = @[@"标题",@"说在前面",@"户型",@"使用面积",@"房屋位置",@"装修花费"];
    
    [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    [cell.textLabel setText:tArr[indexPath.row]];
    [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:14]];
    [cell.detailTextLabel setTextColor:[UIColor colorWithHexString:@"#666666"]];
    [cell setAccessoryType:(UITableViewCellAccessoryDisclosureIndicator)];
    
    if (self.houseData) {
        NSArray *dArr = @[_title,_desc,self.houseData[@"door"],[NSString stringWithFormat:@"%@平米",self.houseData[@"proportion"]],[NSString stringWithFormat:@"%@ %@ %@",self.houseData[@"province_name"],self.houseData[@"city_name"],self.houseData[@"area_name"]],[NSString stringWithFormat:@"%@万元",self.houseData[@"cost"]]];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@",dArr[indexPath.row]]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 75;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 2:
        {
            PushHouseViewController * vc = [[PushHouseViewController alloc] init];
            vc.house_id = self.house_id;
            [self.delegate pushToController:vc];
            
        }
            break;
        case 3:
        {
            HouseAreaViewController * vc = [[HouseAreaViewController alloc] init];
            vc.house_id = self.house_id;
            [self.delegate pushToController:vc];
        }
            break;
        case 4:
        {
            HouseCityViewController * vc = [[HouseCityViewController alloc] init];
            vc.house_id = self.house_id;
           [self.delegate pushToController:vc];
        }
            break;
        case 5:
        {
            HousePriceViewController * vc = [[HousePriceViewController alloc] init];
            vc.house_id = self.house_id;
            [self.delegate pushToController:vc];
        }
            break;
        case 0:
        {
            TextViewController * vc = [[TextViewController alloc] init];
            vc.type = 0;
            vc.text = _title;
            vc.placeHolder = @"请输入标题";
            [vc setDelegate:self];
            [self.delegate pushToController:vc];
        }
            break;
        case 1:
        {
            TextViewController * vc = [[TextViewController alloc] init];
            vc.type = 1;
            vc.text = _desc;
            vc.placeHolder = @"说在前面";
            [vc setDelegate:self];
            [self.delegate pushToController:vc];
        }
            break;
            
            
        default:
            break;
    }
}

- (void)textViewInputText:(NSString *)text type:(NSInteger)type{
    if (type == 0) {
        _title = text;
    }
    
    if (type == 1) {
        _desc = text;
    }
    
    [self.delegate titleChangeValue:text type:type];
    
    
    [self.tmpTableView reloadData];
    
}

- (void)selectCover{
    
    [self.delegate addCover];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
