//
//  EditPushPhotoViewController.m
//  anjuyi1
//
//  Created by apple on 2018/8/4.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "EditPushPhotoViewController.h"
#import "LabelViewController.h"
#import "PhotoSelectController.h"

#define padding 20

@interface EditPushPhotoViewController ()<UITextViewDelegate,UIScrollViewDelegate,PhotoSelectControllerDelegate>
{
    UIButton *backBtn;
    UIButton *shareBtn;
    UIImageView *headerBackImage;
    UILabel *_personPlace;
    UITextView *_tmpTextView;
    NSString *_image_url;
    NSString *_tag_id;
    
}
@property (nonatomic,strong)NSMutableDictionary  *  photoInfo;
@property (nonatomic,strong)UIView               *  navView;
@property (nonatomic,strong)UIView               *  infoView;
@property (nonatomic,strong)UIView               *  functionBar;
@property (nonatomic,strong)NSMutableArray       *  labelArr;
@property (nonatomic,strong)UIScrollView         *  tmpScrollView;

@end

@implementation EditPushPhotoViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self baseForDefaultLeftNavButton];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.labelArr = [NSMutableArray array];
    [self.view addSubview:self.tmpScrollView];
    [self.tmpScrollView addSubview:self.infoView];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.functionBar];
    
    [self getPhotoData];
    
}

- (void)getPhotoData{
    
    
    NSString *path = [NSString stringWithFormat:@"%@/member_image/get_image_info",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *parameter = @{@"image_id":self.photo_id};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:parameter success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            weakSelf.photoInfo = [NSMutableDictionary dictionaryWithDictionary:responseObject[@"datas"]];
            
            [weakSelf createphotoInfo];
            [weakSelf createFunctionBar];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];

}

#pragma mark --  UI
-(UIScrollView *)tmpScrollView{
    
    if (!_tmpScrollView) {
        _tmpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-80)];
        [_tmpScrollView setShowsVerticalScrollIndicator:NO];
        if (@available(iOS 11.0, *)) {
            [_tmpScrollView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpScrollView setShowsHorizontalScrollIndicator:NO];
        [_tmpScrollView setDelegate:self];
    }
    return _tmpScrollView;
}


- (UIView *)navView{
    
    if (!_navView) {
        _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KTopHeight)];
        
        UIButton *back = [Tools creatButton:CGRectMake(MDXFrom6(10), KStatusBarHeight + 2, 40, 40) font:[UIFont systemFontOfSize:12] color:[UIColor whiteColor] title:@"" image:@"my_back"];
        [back addTarget:self action:@selector(back) forControlEvents:(UIControlEventTouchUpInside)];
        [_navView addSubview:back];
        
        backBtn = back;
        
        UIButton *share = [Tools creatButton:CGRectMake(KScreenWidth - 50, KStatusBarHeight + 2, 40, 40) font:[UIFont systemFontOfSize:12] color:[UIColor whiteColor] title:@"" image:@"designer_xq_zf"];
        [share addTarget:self action:@selector(share) forControlEvents:(UIControlEventTouchUpInside)];
//        [_navView addSubview:share];
        
        shareBtn = share;
        
        
    }
    return _navView;
}

- (UIView *)infoView{
    
    if (!_infoView) {
        _infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 1)];
        [_infoView setBackgroundColor:[UIColor whiteColor]];
    }
    return _infoView;
}
- (UIView *)functionBar{
    
    if (!_functionBar) {
        _functionBar = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 80, KScreenWidth, 80)];
        [_functionBar addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 2)]];
    }
    return _functionBar;
}


- (void)createphotoInfo{
    
    [self.infoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat height = 0;
    
    _image_url = self.photoInfo[@"image_info"][@"cover"];
    _tag_id = self.photoInfo[@"image_info"][@"tag_id"];
    
    headerBackImage  = [Tools creatImage:CGRectMake(0, height, KScreenWidth,  750.0*KScreenWidth/750.0)  url:self.photoInfo[@"image_info"][@"cover"] image:@""];
    
    [self.infoView addSubview:headerBackImage];
    UIView *cov = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenWidth)];
    [cov setBackgroundColor:MDRGBA(0, 0, 0, 0.5)];
    [self.infoView addSubview:cov];
    [cov addSubview:[Tools creatImage:CGRectMake((KScreenWidth - 38)/2, MDXFrom6(120), 38, 33 ) image:@"bjtp_change"]];
     [cov addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addCoverImage)]];
    [cov addSubview:[Tools creatLabel:CGRectMake(0, MDXFrom6(120)+53, KScreenWidth, 13) font:[UIFont systemFontOfSize:14] color:[UIColor whiteColor] alignment:(NSTextAlignmentCenter) title:@"点击更换图片"]];
    
    height += 750.0*KScreenWidth/750.0 + 20;
    
    UIImageView *header = [Tools creatImage:CGRectMake(20, height+20, 43, 43) url:self.photoInfo[@"member_info"][@"head"] image:@""];
    [header.layer setCornerRadius:21.5];
    [self.infoView addSubview:header];
    
    NSString *name = self.photoInfo[@"member_info"][@"nickname"];
    CGFloat nameW = KHeight(name, 10000, 20, 18).size.width + 20;
    
    [self.infoView addSubview:[Tools creatLabel:CGRectMake(65,  height+20 ,nameW , 25) font:[UIFont systemFontOfSize:18] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:name]];
    
    UILabel *typeLabel = [Tools creatLabel:CGRectMake(65+ nameW, height+22.5 , 50, 20) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#fffefe"] alignment:(NSTextAlignmentCenter) title:self.photoInfo[@"member_info"][@"level"]];
    [typeLabel.layer setCornerRadius:5];
    [typeLabel setBackgroundColor:[UIColor colorWithHexString:@"#5cc6c6"]];
    [self.infoView addSubview:typeLabel];
    
    [self.infoView addSubview:[Tools creatLabel:CGRectMake(65,height+ 45 ,KScreenWidth - 75 , 20) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentLeft) title:self.photoInfo[@"member_info"][@"position"]]];
    
    UIButton *deletebtn = [Tools creatButton:CGRectMake(KScreenWidth - 110, height+25, 90, 33) font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#666666"] title:@"添加标签" image:@""];
    [deletebtn.layer setCornerRadius:16.5];
    [deletebtn setBackgroundColor: [UIColor colorWithHexString:@"#e9e9e9"]];
    [deletebtn setClipsToBounds:YES];
    [deletebtn addTarget:self action:@selector(deletePhoto) forControlEvents:(UIControlEventTouchUpInside)];
    [self.infoView addSubview:deletebtn];
    
    height += 83+15;
    
    height = [self createDynamicTextView:height];
    
    [self.infoView addSubview:[Tools setLineView:CGRectMake(15, height, KScreenWidth - 30, 1)]];
    
    [self.infoView setFrame:CGRectMake(0, 0, KScreenWidth, height)];
    
    [self.tmpScrollView setContentSize:CGSizeMake(KScreenWidth, height+30)];
}

//输入工地状态
- (CGFloat)createDynamicTextView:(CGFloat)height{
    
    _tmpTextView = [[UITextView alloc] initWithFrame:CGRectMake(padding, height+10, KScreenWidth - 2*padding,120)];
    [_tmpTextView setDelegate:self];
    [_tmpTextView setFont:[UIFont systemFontOfSize:14]];
    [_tmpTextView setTextColor:[UIColor blackColor]];
    [_tmpTextView setTag:1001];
    [_tmpTextView setText:self.photoInfo[@"image_info"][@"text"]];
    [self.infoView addSubview:_tmpTextView];
    
    _personPlace = [[UILabel alloc] initWithFrame:CGRectMake(5, 9 , KScreenWidth, 14)];
    [_personPlace setTextColor:[UIColor colorWithHexString:@"#999999"]];
    [_personPlace setText:@"请输入你的故事~~~"];
    [_personPlace setFont:[UIFont systemFontOfSize:14]];
    [_tmpTextView addSubview:_personPlace];
    
    if ([self.photoInfo[@"image_info"][@"text"] length]!=0) {
        [_personPlace setHidden:YES];
    }
    
    [self.infoView addSubview:[Tools setLineView:CGRectMake(padding, height , KScreenWidth - 20, 1)]];
    
    return height + 140;
}
- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView.tag == 1001) {
        if (textView.text.length == 0) {
            [_personPlace setHidden:NO];
        }
        else{
            [_personPlace setHidden:YES];
        }
    }
    
    if (textView.text.length>1000) {
        
        [textView setText:[textView.text substringToIndex:1000]];
    }
    
    
}

- (void)createFunctionBar{
    
    UIButton *btn = [Tools creatButton:CGRectMake(MDXFrom6(20), 15, KScreenWidth - MDXFrom6(40), 50) font:[UIFont systemFontOfSize:16] color:[UIColor whiteColor] title:@"保存" image:@""];
    [btn setBackgroundColor:MDRGBA(255, 181, 0, 1)];
    [btn.layer setCornerRadius:5];
    [btn setClipsToBounds:YES];
    [btn addTarget:self action:@selector(saveEditPhoto) forControlEvents:(UIControlEventTouchUpInside)];
    [self.functionBar addSubview:btn];
    
}

#pragma mark -- 点击事件
- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)share{
   
}

- (void)saveEditPhoto{
    
    
    NSString *path = [NSString stringWithFormat:@"%@/member_image/edit_image",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    
    NSString * tag_id = @"";
    
    if (self.labelArr.count>0) {
        tag_id = self.labelArr[0][@"id"];
    }
    else{
        tag_id = _tag_id;
    }
    
    NSDictionary *dic = @{@"image_id":self.photo_id,
                          @"image_url":_image_url,
                          @"tag_id":tag_id,
                          @"content":_tmpTextView.text};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];

}

- (void)deletePhoto{

    LabelViewController *vc = [[LabelViewController alloc] init];
    vc.sureBtnLabel = self.labelArr;
    [vc setSureSelectLabel:^(NSArray *labelArr1) {
        self.labelArr = [NSMutableArray arrayWithArray:labelArr1];
        [self addLabelToTextView];
    }];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)addLabelToTextView{
    
    NSString *str = [NSString stringWithFormat:@"%@#%@",_tmpTextView.text,[self.labelArr lastObject][@"name"]];
    [_tmpTextView setText:str];
    
    [_personPlace setHidden:YES];
}

#pragma mark -- 上传图片
- (void)addCoverImage{
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
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            
            if ([responseObject[@"datas"] isKindOfClass:[NSDictionary class]]) {
                if ([responseObject[@"datas"][@"route"] integerValue]==200) {
                    
                    self->_image_url = responseObject[@"datas"][@"fullPath"];
                    [self->headerBackImage setImage:image];
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
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
    
}

#pragma mark -- delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    if (scrollView.contentOffset.y<0) {
        [scrollView setContentOffset:CGPointZero];
    }
    
    [self.navView setBackgroundColor:MDRGBA(255, 255, 255, scrollView.contentOffset.y/KScreenWidth)];
    
    if (scrollView.contentOffset.y > 265) {
        [shareBtn setImage:[UIImage imageNamed:@"share"] forState:(UIControlStateNormal)];
        [backBtn setImage:[UIImage imageNamed:@"ss_back"] forState:(UIControlStateNormal)];
    }
    else{
        
        [shareBtn setImage:[UIImage imageNamed:@"designer_xq_zf"] forState:(UIControlStateNormal)];
        [backBtn setImage:[UIImage imageNamed:@"my_back"] forState:(UIControlStateNormal)];
    }
    
//    CGPoint point = scrollView.contentOffset;
    
//    if (point.y < 0) {
//        CGRect rect = headerBackImage.frame;
//        rect.origin.y =point.y ;
//        rect.size.height = KScreenWidth - point.y;
//        rect.origin.x =  point.y /2;
//        rect.size.width = KScreenWidth - point.y;
//        headerBackImage.frame = rect;
//    }
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
