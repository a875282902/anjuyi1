//
//  PhotoListViewController.m
//  anjuyi1
//
//  Created by 李 on 2018/6/3.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "PhotoListViewController.h"
#import "LSYCollerctionViewLayout.h"
#import "PhotoCollectionViewCell.h"
#import "MyPhotoModel.h"
#import "PhotoDetailsViewController.h"

@interface PhotoListViewController ()<UICollectionViewDataSource , LSYCollerctionViewLayoutDelegate,UICollectionViewDelegate>


@property (nonatomic , strong) UICollectionView * tmpCollertionView;
@property (nonatomic , strong) NSMutableArray   * dataArr;
@property (nonatomic , strong) NavTwoTitle      * navTwoTitle;
@property (nonatomic , assign) NSInteger          page;
@end

@implementation PhotoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self baseForDefaultLeftNavButton];
    self.navTwoTitle = [[NavTwoTitle alloc] initWithFrame:CGRectMake(0, 0, MDXFrom6(200), 44) WithTitle1:@"图片列表" WithTitle2:@"0张"];
    [self.navigationItem setTitleView:self.navTwoTitle];
    self.dataArr = [NSMutableArray array];
    self.page = 1;
    
    [self.view addSubview:self.tmpCollertionView];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1.5)]];
    
    [self load];
    
    [self.tmpCollertionView.mj_header beginRefreshing];
}

#pragma mark -- refresh
- (void)load{
    __weak typeof(self) weakSelf = self;
    
    self.tmpCollertionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf.dataArr removeAllObjects];
        [weakSelf.tmpCollertionView.mj_footer resetNoMoreData];
        [weakSelf pullDownRefresh];
    }];
    
    self.tmpCollertionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf pullUpLoadMore];
    }];
    
}
//下拉刷新
- (void)pullDownRefresh{
    
    NSString *path = [NSString stringWithFormat:@"%@/Image/user_image_list",KURL];
    
    NSDictionary *parameter = @{@"user_id":self.user_id,@"page":[NSString stringWithFormat:@"%ld",self.page]};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:parameter success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            if ([responseObject[@"datas"][@"img_list"] isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *dic in responseObject[@"datas"][@"img_list"]) {
                    MyPhotoModel *model = [[MyPhotoModel alloc] initWithDictionary:dic];
                    [weakSelf.dataArr addObject:model];
                }
                
                [weakSelf.navTwoTitle refreNum:[NSString stringWithFormat:@"%@张",responseObject[@"datas"][@"image_count"]]];
            }
            
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        if (weakSelf.dataArr.count < weakSelf.page *10) {
            [weakSelf.tmpCollertionView.mj_footer endRefreshingWithNoMoreData];
        }
       
        [weakSelf.tmpCollertionView.mj_header endRefreshing];
        
        [weakSelf.tmpCollertionView reloadData];
        
    } failure:^(NSError * _Nullable error) {
        [weakSelf.tmpCollertionView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
    
}
//上拉加载
- (void)pullUpLoadMore{
    
    NSString *path = [NSString stringWithFormat:@"%@/Image/user_image_list",KURL];
    
    NSDictionary *parameter = @{@"user_id":self.user_id,@"page":[NSString stringWithFormat:@"%ld",self.page]};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:parameter success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            if ([responseObject[@"datas"][@"img_list"] isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *dic in responseObject[@"datas"][@"img_list"]) {
                    MyPhotoModel *model = [[MyPhotoModel alloc] initWithDictionary:dic];
                    [weakSelf.dataArr addObject:model];
                }
                
                [weakSelf.navTwoTitle refreNum:[NSString stringWithFormat:@"%@张",responseObject[@"datas"][@"image_count"]]];
                [weakSelf.tmpCollertionView.mj_footer endRefreshing];
            }
           
        }
        else{
            weakSelf.page --;
            [weakSelf.tmpCollertionView.mj_footer endRefreshing];
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        if (weakSelf.dataArr.count < weakSelf.page *10) {
            [weakSelf.tmpCollertionView.mj_footer endRefreshingWithNoMoreData];
        }
        else{
            [weakSelf.tmpCollertionView.mj_footer endRefreshing];
        }
        
        [weakSelf.tmpCollertionView reloadData];
        
    } failure:^(NSError * _Nullable error) {
        [weakSelf.tmpCollertionView.mj_footer endRefreshing];
        weakSelf.page --;
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
    
}



#pragma mark -- UI

- (UICollectionView *)tmpCollertionView{
    
    if (!_tmpCollertionView) {
        
        LSYCollerctionViewLayout *layout = [[LSYCollerctionViewLayout alloc] init];
        
        [layout setDelegate:self];
        
        _tmpCollertionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KViewHeight) collectionViewLayout:layout];
        [_tmpCollertionView setBackgroundColor:[UIColor whiteColor]];
        [_tmpCollertionView setDataSource:self];
        [_tmpCollertionView setDelegate:self];
        [_tmpCollertionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"PhotoListViewController"];
    }
    return _tmpCollertionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoListViewController" forIndexPath:indexPath];
    
    if (indexPath.item < self.dataArr.count) {
        MyPhotoModel *model  = self.dataArr[indexPath.item];
        [cell bandDataWithModel:model];
        [cell setSelectPhotoToCollect:^(UIButton *collectButotn) {
            
            [self collectPhoto:collectButotn photo_id:model.ID];
            
        }];
    }
    
    return cell;
}

//收藏
- (void)collectPhoto:(UIButton *)sender photo_id:(NSString *)photo_id {
    LOGIN
    NSString *path = [NSString stringWithFormat:@"%@/MemberImage/member_collect",KURL];
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *dic = @{@"id":photo_id};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            [ViewHelps showHUDWithText:@"收藏成功"];
            [sender setTitle:[NSString stringWithFormat:@" %ld",[sender.titleLabel.text integerValue] + 1] forState:(UIControlStateNormal)];
            [sender setSelected:YES];
        }
        else if ([responseObject[@"code"] integerValue] == 201){
            [sender setTitle:[NSString stringWithFormat:@" %ld",[sender.titleLabel.text integerValue] - 1] forState:(UIControlStateNormal)];
            [sender setSelected:NO];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
}

- (CGFloat)waterflowLayout:(LSYCollerctionViewLayout *)waterflowLayout heightForItemAtIndexPath:(NSInteger)index itemWidth:(CGFloat)itemWidth{
    
    return (KScreenWidth-30)/2.0 /( 170/113.0f)+90;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotoDetailsViewController *VC = [[PhotoDetailsViewController alloc] init];
    MyPhotoModel *model  = self.dataArr[indexPath.row];
    VC.photo_id = model.ID;
    [self.navigationController pushViewController:VC animated:YES];
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
