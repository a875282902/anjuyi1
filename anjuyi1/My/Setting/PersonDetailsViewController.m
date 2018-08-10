//
//  PersonDetailsViewController.m
//  anjuyi1
//
//  Created by 李 on 2018/6/7.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "PersonDetailsViewController.h"
#import "ChangeNameViewController.h"
#import "PersonalProfileVC.h"
#import "DateView.h"
#import "PhotoSelectController.h"

@interface PersonDetailsViewController ()<UIScrollViewDelegate,PhotoSelectControllerDelegate,DateViewDelegate>
{
    UIImageView *headerImage;
    NSString * _image_url;
    NSString * _time;
    BOOL isRefre;
}
@property (nonatomic,strong)UIScrollView        *tmpScrollView;
@property (nonatomic,strong)DateView            *dateView;
@property (nonatomic,strong)NSMutableDictionary *data;

@end

@implementation PersonDetailsViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!isRefre) {
        [self getPersonInfo];
    }
    isRefre = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"个人资料"];
    [self baseForDefaultLeftNavButton];
    
    [self.view addSubview:self.tmpScrollView];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1.5)]];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.dateView];
    
   
}

- (void)getPersonInfo{


    NSString *path = [NSString stringWithFormat:@"%@/Member/get_member_info",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:nil success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            if ([responseObject[@"datas"] isKindOfClass:[NSDictionary class]]) {
            
                weakSelf.data = [NSMutableDictionary dictionaryWithDictionary:responseObject[@"datas"]];
                [self setUpUI];
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

-(UIScrollView *)tmpScrollView{
    
    if (!_tmpScrollView) {
        _tmpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-KTopHeight)];
        if (@available(iOS 11.0, *)) {
            [_tmpScrollView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpScrollView setShowsVerticalScrollIndicator:NO];
        [_tmpScrollView setShowsHorizontalScrollIndicator:NO];
        [_tmpScrollView setContentSize:CGSizeMake(KScreenWidth, 270)];
        [_tmpScrollView setDelegate:self];
    }
    return _tmpScrollView;
}

- (void)setUpUI{
    
    [self.tmpScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat height = 0;
    
    NSArray *tArr = @[@"头像",@"昵称",@"位置",@"生日",@"个人简历"];
    
    NSArray * dArr ;
    
    if (self.data) {
        dArr = @[self.data[@"head"],self.data[@"nickname"],self.data[@"address"],self.data[@"birthday"],self.data[@"personal"]];
    }
    
    for (NSInteger i = 0 ; i < 5 ; i++) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, height, KScreenWidth, i==0?60:50)];
        [backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
        [backView setTag:i];
        [self.tmpScrollView addSubview:backView];
        
        height += backView.frame.size.height;
        
        [backView addSubview:[Tools creatLabel:CGRectMake(15, 0, 200 , backView.frame.size.height) font:[UIFont systemFontOfSize:15] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:tArr[i]]];
        
        if (i==0) {
            
            headerImage = [Tools creatImage:CGRectMake(KScreenWidth - 80, 10, 40, 40) url:@"" image:@"grzl_tx_img"];
            [headerImage.layer setCornerRadius:20];
            [backView addSubview:headerImage];
            
            if ([dArr[0] isKindOfClass:[NSString class]]) {
                if (_image_url) {
                     [headerImage sd_setImageWithURL:[NSURL URLWithString:_image_url]];
                }else{
                    [headerImage sd_setImageWithURL:[NSURL URLWithString:dArr[0]]];
                }
            }
           
        }
        else{
            if (dArr.count>0) {
                
                if ([dArr[i] isKindOfClass:[NSString class]]) {
                    [backView addSubview:[Tools creatLabel:CGRectMake(15, 0, KScreenWidth - 60 , backView.frame.size.height) font:[UIFont systemFontOfSize:15] color:[UIColor blackColor] alignment:(NSTextAlignmentRight) title:dArr[i]]];
                }
            }
        }
        
        [backView addSubview:[Tools creatImage:CGRectMake(KScreenWidth - 35, (backView.frame.size.height -10 )/2, 6, 10) image:@"jilu_rili_arrow"]];
        
        [backView addSubview:[Tools setLineView:CGRectMake(15, backView.frame.size.height - 1, KScreenWidth - 30, 1)]];
        
    }
}

- (DateView *)dateView{
    
    if (!_dateView) {
        
        _dateView = [[DateView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        [_dateView setDelegate:self];
    }
    return _dateView;
}

- (void)selectCurrentTime:(NSString *)time{
    
    _time = time;
    
    [self changeBirthday];
}

- (void)changeBirthday{
    
    
    NSString *path = [NSString stringWithFormat:@"%@/Member/update_birthday",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *dic =@{@"birthday":_time};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [weakSelf getPersonInfo];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];

}

- (void)tap:(UITapGestureRecognizer *)sender{
    
    switch (sender.view.tag) {
        case 0:
        {
            [self chooseImageFromIphone];
        }
            break;
        case 1:
        {
            ChangeNameViewController *controller = [[ChangeNameViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 3:
        {
            [self.dateView show];
        }
            break;
            
        case 4:
        {
            PersonalProfileVC *controller = [[PersonalProfileVC alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        default:
            break;
    }
    
}


#pragma mark -- 选择照片
- (void)chooseImageFromIphone{
    isRefre = YES;
    PhotoSelectController *vc = [[PhotoSelectController alloc] init];
    [vc setDelegate:self];
    [vc setIsClip:NO];
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
    
    [HttpRequest uploadFileWithInferface:path parameters:nil fileData:UIImageJPEGRepresentation(image, 0.7) serverName:@"file" saveName:@"232323.png" mimeType:(MCPNGImageFileType) progress:^(float progress) {
        
    } success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            
            if ([responseObject[@"datas"][@"route"] integerValue]==200) {
                
                self->_image_url =responseObject[@"datas"][@"fullPath"];
                
                [weakSelf editPersonHeader];
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

- (void)editPersonHeader{
    
    
    NSString *path = [NSString stringWithFormat:@"%@/Member/update_head",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *paramet = @{@"head":_image_url};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    

    [HttpRequest POSTWithHeader:header url:path parameters:paramet success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [self->headerImage sd_setImageWithURL:[NSURL URLWithString:self->_image_url]];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];

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
