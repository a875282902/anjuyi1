//
//  PhotoOrderViewController.m
//  anjuyi1
//
//  Created by apple on 2018/9/13.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "PhotoOrderViewController.h"
#import "PhotoSelectController.h"
#import "SDPhotoBrowserd.h"
#import "PhotoOrderInfoViewController.h"

@interface PhotoOrderViewController ()<UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,PhotoSelectControllerDelegate,SDPhotoBrowserDelegate>

@property (nonatomic,strong) UIImagePickerController * imagePickerController;
@property (nonatomic,strong) UIScrollView            * tmpScrollView;
@property (nonatomic,strong) NSMutableArray          * imageArr;
@property (nonatomic,strong) UIView                  * detalisView;

@end

@implementation PhotoOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    [self baseForDefaultLeftNavButton];
    [self setTitle:@"拍照下单"];
    
    self.imageArr = [NSMutableArray array];
    
    [self.view addSubview:self.tmpScrollView];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1)]];
    
    [self setUpUI];
}

#pragma mark -- scrollview
-(UIScrollView *)tmpScrollView{
    
    if (!_tmpScrollView) {
        _tmpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KViewHeight)];
        [_tmpScrollView setShowsVerticalScrollIndicator:NO];
        [_tmpScrollView setShowsHorizontalScrollIndicator:NO];
        if (@available(iOS 11.0, *)) {
            [_tmpScrollView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpScrollView setDelegate:self];
    }
    return _tmpScrollView;
}

- (void)setUpUI{
    
    CGFloat height = 0 ;
    
    [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(0, height, KScreenWidth, 40) font:[UIFont systemFontOfSize:14] color:[UIColor colorWithHexString:@"#666666"] alignment:(NSTextAlignmentCenter) title:@"拍摄/上传您的清单"]];
    
    height += 40;
    
    UIImageView * camera = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MDXFrom6(105), MDXFrom6(105))];
    [camera setCenter:CGPointMake(KScreenWidth/4, height+ MDXFrom6(70))];
    [camera setImage:[UIImage imageNamed:@"pz_xd"]];
    [camera setUserInteractionEnabled:YES];
    [camera addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(camera:)]];
    [self.tmpScrollView addSubview:camera];
    
    [self.tmpScrollView addSubview:[Tools setLineView:CGRectMake(KScreenWidth/2, height, 1, MDXFrom6(140))]];
    
    UIImageView * photo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MDXFrom6(105), MDXFrom6(105))];
    [photo setCenter:CGPointMake(KScreenWidth*3/4, height+ MDXFrom6(70))];
    [photo setImage:[UIImage imageNamed:@"sc_zp"]];
    [photo setUserInteractionEnabled:YES];
    [photo addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPhoto)]];
    [self.tmpScrollView addSubview:photo];
    
    height += MDXFrom6(140);

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, height, KScreenWidth, 10)];
    [line setBackgroundColor:MDRGBA(246, 246, 246, 1)];
    [self.tmpScrollView addSubview:line];
    
    height += 30;
    
    [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(15, height, KScreenWidth - 30, 15) font:[UIFont systemFontOfSize:15] color:[UIColor redColor] alignment:(NSTextAlignmentLeft) title:@"小安提示您"]];
    
    height += 35;
    
    [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(15, height, KScreenWidth - 30, 15) font:[UIFont systemFontOfSize:15] color:[UIColor colorWithHexString:@"#666666"] alignment:(NSTextAlignmentLeft) title:@"请注意书写材料清单，字迹不能潦草"]];
    
    height += 25;
    
    [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(15, height, KScreenWidth - 30, 15) font:[UIFont systemFontOfSize:15] color:[UIColor colorWithHexString:@"#666666"] alignment:(NSTextAlignmentLeft) title:@"请保证拍摄或上传的清晰度"]];
    
    height += 25;
    
    self.detalisView = [[UIView alloc] initWithFrame:CGRectMake(0, height, KScreenWidth, 0)];
    [self.tmpScrollView addSubview:self.detalisView];
    
    [self.tmpScrollView setContentSize:CGSizeMake(KScreenWidth, height)];
}

- (void)refreDetailsView{
    
    [self.detalisView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat height = ceil(self.imageArr.count/3.0)*(KScreenWidth/3.0);
    
    [self.detalisView setFrame:CGRectMake(0, self.detalisView.frame.origin.y, KScreenWidth, height + 60 + 130)];
    
    [self.tmpScrollView setContentSize:CGSizeMake(KScreenWidth, self.detalisView.frame.origin.y+self.detalisView.frame.size.height)];
    
    for (NSInteger i = 0 ; i < self.imageArr.count ; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth*(i%3)/3.0 +10, (KScreenWidth/3.0 * (i/3))+10, (KScreenWidth/3 - 20), (KScreenWidth/3 - 20))];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageArr[i]]];
        [imageView setTag:i];
        [imageView setContentMode:(UIViewContentModeScaleAspectFit)];
        [imageView setUserInteractionEnabled:YES];
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBigPhoto:)]];
        [self.detalisView addSubview:imageView];
        
        
        UIButton *btn = [Tools creatButton:CGRectMake(KScreenWidth*(i%3 +1)/3.0 -20,  (KScreenWidth/3.0 * (i/3)), 20,20) font:[UIFont systemFontOfSize:16] color:[UIColor whiteColor] title:@"" image:@"new_close"];
        [btn setTag:i];
        [btn addTarget:self action:@selector(deleteImage:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.detalisView addSubview:btn];
    }
    
    
    [self.detalisView addSubview:[Tools setLineView:CGRectMake(0,height, KScreenWidth, 1)]];
    
    UIButton *addBtn = [Tools creatButton:CGRectMake(0, height, KScreenWidth , 60) font:[UIFont systemFontOfSize:14] color:[UIColor colorWithHexString:@"#666666"] title:@" 继续添加" image:@"new_add"];
    [addBtn addTarget:self action:@selector(addPhoto) forControlEvents:(UIControlEventTouchUpInside)];
    [self.detalisView addSubview:addBtn];
    
     [self.detalisView addSubview:[Tools setLineView:CGRectMake(0, height+59, KScreenWidth, 1)]];
    
    
    UIButton *btn = [Tools creatButton:CGRectMake(MDXFrom6(20), height + 110, KScreenWidth - MDXFrom6(40), 50) font:[UIFont systemFontOfSize:16] color:[UIColor whiteColor] title:@"提交订单" image:@""];
    [btn setBackgroundColor:MDRGBA(255, 181, 0, 1)];
    [btn.layer setCornerRadius:5];
    [btn setClipsToBounds:YES];
    [btn addTarget:self action:@selector(pushOrder) forControlEvents:(UIControlEventTouchUpInside)];
    [self.detalisView addSubview:btn];
    
}
//删除图片
- (void)deleteImage:(UIButton *)sender{
    [self.imageArr removeObjectAtIndex:sender.tag];
    [self refreDetailsView];
}

//展示图片
#pragma mark --  展示大图
- (void)showBigPhoto:(UITapGestureRecognizer *)sender{
    
    
    SDPhotoBrowserd *browser = [[SDPhotoBrowserd alloc] init];
    browser.imageCount = self.imageArr.count; // 图片总数
    browser.currentImageIndex = sender.view.tag;
    browser.sourceImagesContainerView = self.view; // 原图的父控件
    browser.delegate = self;
    [browser show];
}


// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowserd *)browser highQualityImageURLForIndex:(NSInteger)index {
    
    
    return [NSURL URLWithString:self.imageArr[index]];
    
}


//提交订单
- (void)pushOrder{
 
    if (self.imageArr.count == 0) {
        [ViewHelps showHUDWithText:@"至少选择一张图片"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    for (NSInteger i = 0 ; i < self.imageArr.count; i++) {
        
        [dic setValue:self.imageArr[i] forKey:[NSString stringWithFormat:@"image_list[%ld]",i]];
    }
    
    
    NSString *path = [NSString stringWithFormat:@"%@/auxiliary_order/phone_order",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            PhotoOrderInfoViewController *vc = [[PhotoOrderInfoViewController alloc] init];
            vc.image_id = responseObject[@"datas"][@"image_id"];
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];

}

#pragma mark -- 上传图片

- (void)camera:(UITapGestureRecognizer *)sender{
    
    if (self.imageArr.count >=4) {
        [ViewHelps showHUDWithText:@"最多上传4张图片"];
        return;
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]) {
        
        self.imagePickerController = [[UIImagePickerController alloc] init];
        
        [self.imagePickerController setDelegate:self];
        // 设置来自相机
        [self.imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        
        // 设置允许编辑
        [self.imagePickerController setAllowsEditing:NO];
        
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    }
    else{
        
        [ViewHelps showHUDWithText:@"该设备不能访问相机"];
    }
  
}
// 选择图片的回调
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    // 图片类型是修改后的图片
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // 返回（结束模态对话窗体）
    [picker dismissViewControllerAnimated:YES completion:^{
        // 设置图片
        [self upLoadImage:selectedImage];
    }];
}

- (void)addPhoto{

    if (self.imageArr.count >=4) {
        [ViewHelps showHUDWithText:@"最多上传4张图片"];
        return;
    }
    self.imagePickerController = [[UIImagePickerController alloc] init];
    
    [self.imagePickerController setDelegate:self];
    // 设置来自相机
    [self.imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    // 设置允许编辑
    [self.imagePickerController setAllowsEditing:NO];
    
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (void)selectImage:(UIImage *)image{
    
    [self upLoadImage:image];
}


- (void)upLoadImage:(UIImage *)image{
    
    NSString *path = [NSString stringWithFormat:@"%@/Upload/upload",KURL];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest uploadFileWithInferface:path parameters:nil fileData:UIImageJPEGRepresentation(image, 0.5) serverName:@"file" saveName:nil mimeType:(MCJPEGImageFileType) progress:^(float progress) {
        NSLog(@"%.2f",progress);
    } success:^(id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            NSLog(@"成功");
            
            if ([responseObject[@"datas"] isKindOfClass:[NSDictionary class]]) {
                if ([responseObject[@"datas"][@"route"] integerValue]==200) {
                    [weakSelf.imageArr addObject:responseObject[@"datas"][@"fullPath"]];
                    
                    [weakSelf refreDetailsView];
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
