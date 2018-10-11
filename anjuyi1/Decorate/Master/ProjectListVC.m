//
//  ProjectListVC.m
//  anjuyi1
//
//  Created by 李 on 2018/6/1.
//  Copyright © 2018年 lsy. All rights reserved.
//
// 项目列表

#import "ProjectListVC.h"
#import "ProjectTableViewCell.h"
#import "ProjectDetailsVC.h"
#import "SubscribeVisitVC.h"//预约参观
#import "ProjectModel.h"

@interface ProjectListVC ()<UITableViewDelegate , UITableViewDataSource,ProjectTableViewCellDelegate>

@property (nonatomic,strong) UITableView    * tmpTableView;
@property (nonatomic,strong) NSMutableArray * dataArr;

@end

@implementation ProjectListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationLeftBarButtonWithImageNamed:@"ss_back"];
    [self setNavigationRightBarButtonWithImageNamed:@"fw"];
    
    self.dataArr = [NSMutableArray array];
    
    [self setTitle:@"项目列表"];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0f]}];
    
    [self.view addSubview:self.tmpTableView];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1)]];
    
    [self getProjectListData];
    
}

#pragma mark -- 获取数据
- (void)getProjectListData{
    
    NSString *path = [NSString stringWithFormat:@"%@/project_info/project_list",KURL];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:@{@"user_id":self.user_id} success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in responseObject[@"datas"]) {
                    ProjectModel *model = [[ProjectModel alloc] initWithDictionary:dic];
                    [weakSelf.dataArr addObject:model];
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
- (UITableView *)tmpTableView{
    
    if (!_tmpTableView) {
        _tmpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-KTopHeight) style:(UITableViewStylePlain)];
        [_tmpTableView setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
        if (@available(iOS 11.0, *)) {
            [_tmpTableView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpTableView setShowsVerticalScrollIndicator:NO];
        [_tmpTableView setShowsHorizontalScrollIndicator:NO];
        [_tmpTableView setDataSource:self];
        [_tmpTableView setDelegate:self];
    }
    return _tmpTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ProjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProjectTableViewCell"];
    if (!cell) {
        cell = [[ProjectTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"ProjectTableViewCell"];
    }
    
    [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    [cell setDelegate:self];

    if (indexPath.row < self.dataArr.count) {
        [cell bandDataWithModel:self.dataArr[indexPath.row]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 355;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ProjectModel *model = self.dataArr[indexPath.row];
    
    ProjectDetailsVC *controll = [[ProjectDetailsVC alloc] init];
    controll.projectID = model.ID;
    [self.navigationController pushViewController:controll animated:YES];
}

- (void)subscribeVisitWithCell:(UITableViewCell *)cell{
    LOGIN
    SubscribeVisitVC *controll = [[SubscribeVisitVC alloc] init];
    [self.navigationController pushViewController:controll animated:YES];
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
