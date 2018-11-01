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

@interface PersonDetailsViewController ()<UIScrollViewDelegate,PhotoSelectControllerDelegate,DateViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImageView *headerImage;//头像视图
    NSString * _image_url;//头像地址
    NSString * _file_url;//个人介绍文件地址
    NSString * _time;//生日
    BOOL isRefre;//判断是否更改了内容 是否刷新
    
}
@property (nonatomic,strong)UIScrollView        *tmpScrollView;
@property (nonatomic,strong)DateView            *dateView;
@property (nonatomic,strong)NSMutableDictionary *data;
@property (nonatomic,strong)UIImagePickerController * imagePickerController;

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
    
    NSArray *tArr = @[@"头像",@"昵称",@"位置",@"生日",@"个人简介",@"个人介绍"];
    
    NSArray * dArr ;
    
    if (self.data) {
        dArr = @[self.data[@"head"],self.data[@"nickname"],self.data[@"address"],self.data[@"birthday"],self.data[@"personal"],self.data[@"personal"]];
    }
    
    for (NSInteger i = 0 ; i < 6 ; i++) {
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
            isRefre = YES;
            PhotoSelectController *vc = [[PhotoSelectController alloc] init];
            [vc setDelegate:self];
            [vc setIsClip:NO];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:nil];
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
        case 5:
        {
            [self chooseImageFromIphone];
        }
            break;
        default:
            break;
    }
    
}


#pragma mark -- 选择照片
- (void)chooseImageFromIphone{
    
    // 判断有没有访问相册的权限
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        
        NSLog(@"没有访问相册的权限");
        return;
        
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]) {
        
        [self creatAlertViewControllerWithMessage:@"2"];
        
    }
    else{
        
        [self creatAlertViewControllerWithMessage:@"1"];
    }
    
    
    
}

- (void)creatAlertViewControllerWithMessage:(NSString *)message{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择" message:@"" preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction *trueA = [UIAlertAction actionWithTitle:@"相册" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        self.imagePickerController = [[UIImagePickerController alloc] init];
        
        [self.imagePickerController setDelegate:self];
        // 设置来自相册
        [self.imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self.imagePickerController setMediaTypes:@[(NSString *)kUTTypeMovie]];
        // 设置允许编辑
        [self.imagePickerController setAllowsEditing:YES];
        
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
        
    }];
    
    UIAlertAction *trueB = [UIAlertAction actionWithTitle:@"相机" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        self.imagePickerController = [[UIImagePickerController alloc] init];
        
        [self.imagePickerController setDelegate:self];
        // 设置来自相机
        [self.imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self.imagePickerController setMediaTypes:@[(NSString *)kUTTypeMovie]];
        
        // 设置允许编辑
        [self.imagePickerController setAllowsEditing:YES];
        
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
        
    }];
    
    UIAlertAction *falseA = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    
    if ([message isEqualToString:@"2"]) {
        
        [alert addAction:trueB];
    }
    
    [alert addAction:trueA];
    [alert addAction:falseA];
    [self presentViewController:alert animated:YES completion:nil];
    
}

// 选择图片的回调
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    
    // 返回（结束模态对话窗体）
    WKSELF;
    if([mediaType isEqualToString:@"public.movie"])
    {
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        CGFloat offset = 1024 * 1024 *5.0;
        NSData *file = [NSData dataWithContentsOfURL:videoURL];
        CGFloat fileNum = (unsigned long)[file length]/offset;
        
        [picker dismissViewControllerAnimated:YES completion:^{
            if (fileNum > 200) {
                [ViewHelps showHUDWithText:@"该视频过大，请选择其他视频"];
            }
            else{
                [weakSelf upLoadImage:videoURL mimeType:(MCMP4FileType) type:2];
            }
            
        }];
        
    }else{
        
        // 图片类型是修改后的图片
        UIImage *selectedImage = [info objectForKey:UIImagePickerControllerEditedImage];
        
        [picker dismissViewControllerAnimated:YES completion:^{
            [weakSelf upLoadImage:selectedImage mimeType:(MCJPEGImageFileType) type:2];
        }];
    }
    
   
}


/**
     PhotoSelectControllerDelegate
 *
 *  @param image  返回图片
 */
- (void)selectImage:(UIImage *)image{
    
    [self upLoadImage:image mimeType:(MCJPEGImageFileType) type:1];
    
}


/**
    上传文件
 *
 *  @param file  文件
 *  @param mimeFiletype  文件属性
 *  @param type  type 1为上传头像  2上传介绍
 */
- (void)upLoadImage:(id)file mimeType:(mimeFileType)mimeFiletype type:(NSInteger)type{
    
    NSData *data = nil;
    
    if ([file isKindOfClass:[UIImage class]]) {
        
        data = UIImageJPEGRepresentation(file, 0.7);
    }
    else{
        
        data = [NSData dataWithContentsOfURL:(NSURL *)file];
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/upload/upload_file",KURL];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest uploadFileWithInferface:path parameters:nil fileData:data serverName:@"file" saveName:@"232323.png" mimeType:(mimeFiletype) progress:^(float progress) {
        
    } success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            if (type == 1) {
                self->_image_url =responseObject[@"datas"][@"fullPath"];
                
                [weakSelf editPersonHeader];
            }
            else if (type == 2){
                
                self->_file_url =responseObject[@"datas"][@"fullPath"];
                
                [weakSelf editPersonalIntroduce];
                
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
/**
 修改个人头像

 */
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

/**
 修改个人介绍
 */

- (void)editPersonalIntroduce{
    
    NSString *path = [NSString stringWithFormat:@"%@/member/update_video",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *paramet = @{@"video":_file_url};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    [HttpRequest POSTWithHeader:header url:path parameters:paramet success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [ViewHelps showHUDWithText:@"修改成功"];
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
