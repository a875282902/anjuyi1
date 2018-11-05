//
//  SpaceImageListViewController.m
//  anjuyi1
//
//  Created by apple on 2018/7/17.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "SpaceImageListViewController.h"
#import "SpaceImageListTableViewCell.h"
#import "AddSpaceImageViewController.h"
#import "EditSpaceImageViewController.h"

@interface SpaceImageListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray  * dataArr;
@property (nonatomic,strong)UITableView     * tmpTableView;
@property (nonatomic,strong)UIView          * footView;

@end

@implementation SpaceImageListViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    UIImage *tmpImage = [UIImage imageWithColor:[UIColor colorWithHexString:@"#47baba"]];
    [self.navigationController.navigationBar setBackgroundImage:tmpImage forBarMetrics:UIBarMetricsDefault];;
    
    [self getData];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.\
    
    [self setUpBackButton];
    [self setUpAlert];
    
    [self.view addSubview:self.tmpTableView];
    
    [self dragButtonClick];

}
#pragma mark -- nav
- (void)setUpBackButton{
    
    UIButton *btn = [Tools creatButton:CGRectMake(0, 0 , 40+([self.spaceDic[@"name"] length] *15), 44) font:[UIFont systemFontOfSize:15] color:[UIColor whiteColor] title:[NSString stringWithFormat:@"    %@",self.spaceDic[@"name"]] image:@"my_back"];
    [btn addTarget:self action:@selector(back) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIBarButtonItem *bt = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [self.navigationItem setLeftBarButtonItem:bt];
}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUpAlert{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    [view setBackgroundColor:MDRGBA(239, 239, 239, 1)];
    
    [view addSubview:[Tools creatLabel:CGRectMake(15, 0, KScreenWidth-30, 40) font:[UIFont systemFontOfSize:14] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentLeft) title:@"左滑可删除图片，长按对图片排序"]];
    
    [self.view addSubview:view];
}

#pragma mark -- 获取数据
- (void)getData{
    
    self.dataArr = [NSMutableArray array];

    NSString *path = [NSString stringWithFormat:@"%@/WholeHouse/house_show_image_list",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *paramet = @{@"house_id":self.house_id,@"show_id":self.spaceDic[@"id"]};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:paramet success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                [weakSelf.dataArr removeAllObjects];
                
                for (NSDictionary *dic  in responseObject[@"datas"]) {
                    [weakSelf.dataArr addObject:dic];
                }
                
                [weakSelf.tmpTableView reloadData];
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

#pragma mark -- tableView
- (UIView *)footView{
    if (!_footView) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 80)];
        [_footView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImage)]];
        
        UIView *back = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth - 85, 15, 50, 50)];
        [back.layer setCornerRadius:5];
        [back setBackgroundColor:MDRGBA(239, 239, 239, 1)];
        [_footView addSubview:back];
        
        [back addSubview:[Tools creatImage:CGRectMake(16.5, 10, 17, 14) image:@"up_photo"]];
        
        [back addSubview:[Tools creatLabel:CGRectMake(0, 30, 50, 10) font:[UIFont systemFontOfSize:9] color:[UIColor colorWithHexString:@"#3b3b3b"] alignment:(NSTextAlignmentCenter) title:@"添加图片"]];
        
        [_footView addSubview:[Tools setLineView:CGRectMake(0, 78, KScreenWidth, 2)]];
        
    }
    return _footView;
}

- (UITableView *)tmpTableView{
    
    if (!_tmpTableView) {
        _tmpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, KScreenWidth, KViewHeight - 40) style:(UITableViewStylePlain)];
        [_tmpTableView setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
        if (@available(iOS 11.0, *)) {
            [_tmpTableView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpTableView setShowsVerticalScrollIndicator:NO];
        [_tmpTableView setShowsHorizontalScrollIndicator:NO];
        [_tmpTableView setTableFooterView:self.footView];
        [_tmpTableView setDataSource:self];
        [_tmpTableView setDelegate:self];
    }
    return _tmpTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SpaceImageListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SpaceImageListTableViewCell"];
    if (!cell) {
        cell = [[SpaceImageListTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"SpaceImageListTableViewCell"];
    }
    
    
    [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    
    if (indexPath.row < self.dataArr.count) {
        [cell bandDataWith:self.dataArr[indexPath.row]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 85;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EditSpaceImageViewController *vc = [[EditSpaceImageViewController alloc] init];
    vc.img_id = self.dataArr[indexPath.row][@"id"];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -- 右划删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteSpaceImage:indexPath];
    }

}

- (void)deleteSpaceImage:(NSIndexPath *)indexPath{
    
    
    NSString *path = [NSString stringWithFormat:@"%@/WholeHouse/del_show_image",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *paramet = @{@"id":self.dataArr[indexPath.row][@"id"]};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:paramet success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [weakSelf.dataArr removeObjectAtIndex:indexPath.row];
            
            [weakSelf.tmpTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationLeft)];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];

}

#pragma mark -- cell 长按排序
- (void)dragButtonClick{
    //添加长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressRecognizer:)];
    //    self.longPress = longPress;
    longPress.minimumPressDuration = 0.3;
    [self.tmpTableView addGestureRecognizer:longPress];
}
- (void)longPressRecognizer:(UILongPressGestureRecognizer *)longPress{
    //获取长按的点及cell
    CGPoint location = [longPress locationInView:self.tmpTableView];
    NSIndexPath *indexPath = [self.tmpTableView indexPathForRowAtPoint:location];
    UIGestureRecognizerState state = longPress.state;
    
    static UIView *snapView = nil;
    static NSIndexPath *sourceIndex = nil;
    switch (state) {
        case UIGestureRecognizerStateBegan:{
            if (indexPath) {
                sourceIndex = indexPath;
                UITableViewCell *cell = [self.tmpTableView cellForRowAtIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                snapView = [self customViewWithTargetView:cell];
                
                __block CGPoint center = cell.center;
                snapView.center = center;
                snapView.alpha = 0.0;
                [self.tmpTableView addSubview:snapView];
                
                [UIView animateWithDuration:0.1 animations:^{
                    center.y = location.y;
                    snapView.center = center;
                    snapView.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapView.alpha = 0.5;
                    
                    cell.alpha = 0.0;
                }];
            }
        }
            break;
            
        case UIGestureRecognizerStateChanged:{
            CGPoint center = snapView.center;
            center.y = location.y;
            snapView.center = center;
            
            UITableViewCell *cell = [self.tmpTableView cellForRowAtIndexPath:sourceIndex];
            cell.alpha = 0.0;
            
            if (indexPath && ![indexPath isEqual:sourceIndex]) {
                
                [self.dataArr exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndex.row];
                
                [self.tmpTableView moveRowAtIndexPath:sourceIndex toIndexPath:indexPath];
                
                sourceIndex = indexPath;
            }
            
        }
            break;
            
        default:{
            UITableViewCell *cell = [self.tmpTableView cellForRowAtIndexPath:sourceIndex];
            [UIView animateWithDuration:0.25 animations:^{
                snapView.center = cell.center;
                snapView.transform = CGAffineTransformIdentity;
                snapView.alpha = 0.0;
                
                cell.alpha = 1.0;
            } completion:^(BOOL finished) {
                [snapView removeFromSuperview];
                snapView = nil;
            }];
            sourceIndex = nil;
        }
            break;
    }
}

//截取选中cell
- (UIView *)customViewWithTargetView:(UIView *)target{
    UIGraphicsBeginImageContextWithOptions(target.bounds.size, NO, 0);
    [target.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

#pragma mark -- 事件
- (void)addImage{
    AddSpaceImageViewController *vc = [[AddSpaceImageViewController alloc] init];
    vc.house_id= self.house_id;
    vc.show_id =self.spaceDic[@"id"];
    [self.navigationController pushViewController:vc animated:YES];
    
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
