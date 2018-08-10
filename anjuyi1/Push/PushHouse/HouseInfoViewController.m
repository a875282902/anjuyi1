//
//  HouseInfoViewController.m
//  anjuyi1
//
//  Created by apple on 2018/7/17.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "HouseInfoViewController.h"
#import "PhotoSelectController.h"

#import "HouseQA.h"
#import "HouseSpace.h"
#import "HouseCoverView.h"

// 空间
#import "SpaceImageListViewController.h"

//问答
#import "EditHouseQAViewController.h"

#import "TextViewController.h"

#import "MyPushHouseViewController.h"


@interface HouseInfoViewController ()<PhotoSelectControllerDelegate,HouseCoverViewDlegate,UIScrollViewDelegate>
{
    NSString *_cover;
    NSString *_title;
    NSString *_said;
    UIView *_lineView;
    UIButton *_selectBtn;
    BOOL isRefre;
    BOOL isRefre1;
    BOOL isRefre2;
    BOOL isChanageColor;
    NSString *_newSpaceName;
    NSString *_newQAName;
}
@property (nonatomic,strong)UIScrollView         * tmpScrollView;
@property (nonatomic,strong)HouseCoverView       * houseCoverView;
@property (nonatomic,strong)HouseSpace           * houseSpace;
@property (nonatomic,strong)HouseQA              * houseQA;
@property (nonatomic,strong)NSMutableArray       * channelArr;

@end

@implementation HouseInfoViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    UIImage *tmpImage = [UIImage imageWithColor:[UIColor colorWithHexString:@"#47baba"]];
    [self.navigationController.navigationBar setBackgroundImage:tmpImage forBarMetrics:UIBarMetricsDefault];;
    
    if (self.houseCoverView && isRefre) {
        [self.houseCoverView refreData];
    }
    if (self.houseSpace && isRefre1) {
        [self.houseSpace refreData];
    }
    
    if (self.houseQA && isRefre2) {
        [self.houseQA refreData];
    }
    
    isRefre = NO;
    isRefre1 = NO;
    isRefre2 = NO;
    isChanageColor = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    if (isChanageColor) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        UIImage *tmpImage = [UIImage imageWithColor:[UIColor colorWithHexString:@"#ffffff"]];
        [self.navigationController.navigationBar setBackgroundImage:tmpImage forBarMetrics:UIBarMetricsDefault];
    }
    
    isChanageColor = YES;
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpUI];

    
    [self setNavigationLeftBarButtonWithTitle:@"关闭" color:[UIColor whiteColor]];
    
    [self.view addSubview:self.tmpScrollView];
    
    [self setContentView];
    
}


#pragma mark -- nav
- (void)setUpUI{
    

    NSArray *tArr = @[@"删除",@"保存",@"预览"];

    NSMutableArray *bArr = [NSMutableArray array];
    
    for (NSInteger i = 0 ; i < 3; i++) {

        UIButton *btn = [Tools creatButton:CGRectMake(0, 0 , 45, 44) font:[UIFont systemFontOfSize:15] color:[UIColor whiteColor] title:tArr[i] image:@""];
        [btn setTag:i];
        [btn addTarget:self action:@selector(selectHouseStatus:) forControlEvents:(UIControlEventTouchUpInside)];
        
        UIBarButtonItem *bt = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [bArr addObject:bt];
    }
    
    [self.navigationItem setRightBarButtonItems:bArr];
    
    
    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth,  50)];
    [statusView setBackgroundColor:[UIColor colorWithHexString:@"#47baba"]];
    [self.view addSubview:statusView];

    self.channelArr = [NSMutableArray array];
    NSArray *tArr1 = @[@"封面",@"空间",@"回答"];
    for (NSInteger i = 0 ; i < 3; i ++) {
        UIButton *btn = [Tools creatButton:CGRectMake(KScreenWidth*i /3.0, 0 , KScreenWidth/3.0, 50) font:[UIFont systemFontOfSize:15] color:[UIColor whiteColor] title:tArr1[i] image:@""];
        [btn setTag:i];
        [btn setTitleColor:[UIColor colorWithHexString:@"#b0dfdf"] forState:(UIControlStateNormal)];
        [btn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:(UIControlStateSelected)];
        [btn addTarget:self action:@selector(selectView:) forControlEvents:(UIControlEventTouchUpInside)];
        [statusView addSubview:btn];
        if (i==0 ) {
            [btn setSelected:YES];
            _selectBtn =btn ;
        }
        
        [self.channelArr addObject:btn];
    }
    
    _lineView = [Tools setLineView:CGRectMake(0, 48, KScreenWidth/3, 2)];
    [statusView addSubview:_lineView];
}

#pragma mark -- scrollview
-(UIScrollView *)tmpScrollView{
    
    if (!_tmpScrollView) {
        _tmpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, KScreenWidth, KViewHeight - 50)];
        [_tmpScrollView setShowsVerticalScrollIndicator:NO];
        [_tmpScrollView setShowsHorizontalScrollIndicator:NO];
        [_tmpScrollView setPagingEnabled:YES];
        if (@available(iOS 11.0, *)) {
            [_tmpScrollView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpScrollView setContentSize:CGSizeMake(KScreenWidth*3, _tmpScrollView.frame.size.height)];
        [_tmpScrollView setDelegate:self];
        [_tmpScrollView setBounces:NO];
        [_tmpScrollView setScrollEnabled:NO];
    }
    return _tmpScrollView;
}

- (void)setContentView{
    
    self.houseCoverView = [[HouseCoverView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, self.tmpScrollView.frame.size.height)];
    [self.houseCoverView setDelegate:self];
    [self.houseCoverView setHouse_id:self.house_id];
    [self.tmpScrollView addSubview:self.houseCoverView];
    
    self.houseSpace = [[HouseSpace alloc] initWithFrame:CGRectMake(KScreenWidth, 0, KScreenWidth, self.tmpScrollView.frame.size.height)];
    [self.houseSpace setHouse_id:self.house_id];
    [self.tmpScrollView addSubview:self.houseSpace];
    
    __weak typeof(self) weakSelf = self;
    
    [self.houseSpace setSelectHouseSpace:^(NSDictionary *dic) {
        self->isChanageColor = NO;
        self->isRefre1 = YES;
        SpaceImageListViewController *vc = [[SpaceImageListViewController alloc] init];
        vc.spaceDic = dic;
        vc.house_id = weakSelf.house_id;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.houseSpace setAddHouseSpaceToList:^{
        self->isRefre1 = YES;
        [weakSelf creatAddHouseSpace];
    }];
    
    
    self.houseQA = [[HouseQA alloc] initWithFrame:CGRectMake(KScreenWidth*2, 0, KScreenWidth, self.tmpScrollView.frame.size.height)];
    [self.houseQA setHouse_id:self.house_id];
    [self.tmpScrollView addSubview:self.houseQA];
    
    [self.houseQA setSelectHouseQA:^(NSDictionary *dic) {
        self->isChanageColor = NO;
        self->isRefre2 = YES;
        EditHouseQAViewController *vc = [[EditHouseQAViewController alloc] init];
        vc.QADic = dic;
        vc.house_id = weakSelf.house_id;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.houseQA setAddHouseQAToList:^{
        self->isRefre2 = YES;
        
        [weakSelf creatAddHouseQA];
    }];
    
    
}

#pragma mark -- delegate
- (void)addCover{
    
    [self selectCover];//上传封面
}

- (void)pushToController:(BaseViewController *)vc{
    isRefre = YES;
    
    if ([vc isKindOfClass:[TextViewController class]]) {
        isChanageColor = NO;
        isRefre = NO;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)titleChangeValue:(NSString *)text type:(NSInteger)type{
    if (type == 0) {
        _title = text;
    }
    
    if (type == 1) {
        _said = text;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (!decelerate) {
        NSInteger n = scrollView.contentOffset.x/KScreenWidth;
        
        [self selectView:self.channelArr[n]];
    }
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.tmpScrollView) {
        NSInteger n = scrollView.contentOffset.x/KScreenWidth;
        
        [self selectView:self.channelArr[n]];
    }
}


#pragma mark -- 事件
- (void)leftButtonTouchUpInside:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)selectHouseStatus:(UIButton *)sender{
    
    switch (sender.tag) {
        case 0:
        {
            [self creatAlertViewControllerWithMessage:@"确定要删除吗？"];
        }
            break;
        case 1:
        {

            [self insertHouseInfo:1];
        }
            break;
        case 2:
        {
            [self insertHouseInfo:2];
            
        }
            break;
            
        default:
            break;
    }
}

- (void)selectView:(UIButton *)sender{
    
    [_selectBtn setSelected:NO];
    [sender setSelected:YES];
    _selectBtn = sender;
    
    [UIView animateWithDuration:.2 animations:^{
        [self->_lineView setCenter:CGPointMake(sender.center.x, self->_lineView.center.y)];
    }];
    
    [self.tmpScrollView setContentOffset:CGPointMake(sender.tag *KScreenWidth, 0) animated:YES];
}

#pragma mark -- 上传图片
- (void)selectCover{
    PhotoSelectController *vc = [[PhotoSelectController alloc] init];
    [vc setDelegate:self];
    [vc setIsClip:NO];
    [vc setClipSize:CGSizeMake(KScreenWidth, KScreenWidth)];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
    
}

- (void)selectImage:(UIImage *)image{
    
    [self upLoadImage:image];
}

- (void)upLoadImage:(UIImage *)image{
    
    
    NSString *path = [NSString stringWithFormat:@"%@/Upload/upload",KURL];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest uploadFileWithInferface:path parameters:nil fileData:UIImageJPEGRepresentation(image, 0.7) serverName:@"file" saveName:nil mimeType:(MCJPEGImageFileType) progress:^(float progress) {
        NSLog(@"%.2f",progress);
    } success:^(id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            
            if ([responseObject[@"datas"] isKindOfClass:[NSDictionary class]]) {
                if ([responseObject[@"datas"][@"route"] integerValue]==200) {
                    
                    self->_cover = responseObject[@"datas"][@"fullPath"];
                    [weakSelf.houseCoverView.headerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                    [weakSelf.houseCoverView.headerView setImage:image];
                }
                else{
                    [ViewHelps showHUDWithText:@"加载失败，请重新选择图片"];
                }
            }else{
                [ViewHelps showHUDWithText:@"加载失败，请重新选择图片"];
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

#pragma mark -- 预览 保存 删除
- (void)insertHouseInfo:(NSInteger)tag{
    
    if (_cover.length == 0) {
        [ViewHelps showHUDWithText:@"请选择封面"];
        return;
    }
    
    if (_title.length == 0) {
        [ViewHelps showHUDWithText:@"请输入标题"];
        return;
    }
    
    if (_said.length == 0) {
        [ViewHelps showHUDWithText:@"请输入“说在前面”"];
        return;
    }
    
    
    NSString *path = [NSString stringWithFormat:@"%@/WholeHouse/insert_whole_house_info",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    
    NSDictionary *paramet = @{@"house_id":self.house_id,
                              @"cover":_cover,
                              @"title":_title,
                              @"said":_said};
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:paramet success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {

           
            if (tag == 1) {
                [weakSelf saveHouse];
            }
            else{
                
                [weakSelf showHouse];
            }
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];

}

- (void)showHouse{
    
    
    NSString *path = [NSString stringWithFormat:@"%@/WholeHouse/preview_house_status",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *paramet = @{@"house_id":self.house_id};
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:paramet success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [ViewHelps showHUDWithText:@"预览成功"];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];

}

- (void)saveHouse{
    
    NSString *path = [NSString stringWithFormat:@"%@/WholeHouse/save_house_status",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *paramet = @{@"house_id":self.house_id};
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:paramet success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [ViewHelps showHUDWithText:@"保存成功"];
            
            MyPushHouseViewController * vc = [[MyPushHouseViewController alloc] init];
            vc.isPresent = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
}

#pragma mark -- 删除整屋
- (void)creatAlertViewControllerWithMessage:(NSString *)message{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:(UIAlertControllerStyleAlert)];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        [self deleteHouse];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
- (void)deleteHouse{
    
    
    NSString *path = [NSString stringWithFormat:@"%@/WholeHouse/del_house",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    
    NSDictionary *paramet = @{@"house_id":self.house_id};
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:paramet success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            [ViewHelps showHUDWithText:@"删除成功"];
            
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
            
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];

}

#pragma mark -- 创建空间名字

- (void)creatAddHouseSpace{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"新增空间" message:@"" preferredStyle:(UIAlertControllerStyleAlert)];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"保存" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self saveHouseSpaceName];
    }]];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
      
        [textField setPlaceholder:@"最多五个字"];
        
        [textField addTarget:self action:@selector(houseSpaceNameChange:) forControlEvents:(UIControlEventEditingChanged)];
    }];
    
    
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)houseSpaceNameChange:(UITextField *)sender{
    
    if (sender.text.length > 5) {
        [sender setText:[sender.text substringToIndex:5]];
    }
    
    _newSpaceName = sender.text;
}

- (void)saveHouseSpaceName{
    
    if (_newSpaceName.length == 0) {
        [ViewHelps showHUDWithText:@"请输入空间名字"];
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/WholeHouse/add_house_show",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *paramet = @{@"house_id":self.house_id,@"name":_newSpaceName};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:paramet success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
//            self->isRefre1 = YES;
//            SpaceImageListViewController *vc = [[SpaceImageListViewController alloc] init];
//            vc.spaceDic = @{@"":@""};
//            vc.house_id = weakSelf.house_id;
//            [weakSelf.navigationController pushViewController:vc animated:YES];
            
            [weakSelf.houseSpace refreData];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];

}

#pragma mark -- 创建问答
- (void)creatAddHouseQA{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"新增问题" message:@"" preferredStyle:(UIAlertControllerStyleAlert)];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"保存" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        
        [self saveHouseQAName];
        
        
    }]];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        [textField setPlaceholder:@"最多50个字"];
        
        [textField addTarget:self action:@selector(houseQANameChange:) forControlEvents:(UIControlEventEditingChanged)];
    }];
    
    
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)houseQANameChange:(UITextField *)sender{
    
    if (sender.text.length > 50) {
        [sender setText:[sender.text substringToIndex:50]];
    }
    
    _newQAName = sender.text;
}

- (void)saveHouseQAName{
    
    if (_newQAName.length == 0) {
        [ViewHelps showHUDWithText:@"请输入问题"];
        return;
    }
    self->isChanageColor = NO;
    EditHouseQAViewController *vc = [[EditHouseQAViewController alloc] init];
    vc.house_id =self.house_id;
    vc.name = _newQAName;
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
