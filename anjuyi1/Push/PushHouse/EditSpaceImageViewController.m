//
//  AddSpaceImageViewController.m
//  anjuyi1
//
//  Created by apple on 2018/7/2.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "EditSpaceImageViewController.h"
#import "LabelViewController.h"
#import "PhotoSelectController.h"
#import "SDPhotoBrowserd.h"

#define padding MDXFrom6(10)

@interface EditSpaceImageViewController ()<UIScrollViewDelegate,UITextViewDelegate,PhotoSelectControllerDelegate,SDPhotoBrowserDelegate>
{
    UILabel *_personPlace;
    NSDictionary *_labelDic;//标签
    NSString  *_content;//内容
    NSString  *_image_url;//图片地址
}

@property (nonatomic,strong) UIScrollView          * tmpScrollView;//承载视图的view
@property (nonatomic,strong) NSDictionary          * member_info;//
@property (nonatomic,strong) UIImageView           * coverImage;//
@property (nonatomic,strong) NSMutableDictionary   * imageData;//

@end

@implementation EditSpaceImageViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    UIImage *tmpImage = [UIImage imageWithColor:[UIColor colorWithHexString:@"#ffffff"]];
    [self.navigationController.navigationBar setBackgroundImage:tmpImage forBarMetrics:UIBarMetricsDefault];;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"编辑图片"];
    [self baseForDefaultLeftNavButton];
    
    [self.view addSubview:self.tmpScrollView];
    
    [self setNavigationRightBarButtonWithTitle:@"保存" color:[UIColor colorWithHexString:@"#3b3b3b"]];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1)]];
    
    [self getData];

}

- (void)getData{
    
    
    NSString *path = [NSString stringWithFormat:@"%@/WholeHouse/image_detail",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *paramet = @{@"id":self.img_id};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:paramet success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            weakSelf.imageData = [NSMutableDictionary dictionaryWithDictionary:responseObject[@"datas"]];
    
            [weakSelf setUpUI];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];

}

#pragma mark -- scrollview
-(UIScrollView *)tmpScrollView{
    
    if (!_tmpScrollView) {
        _tmpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KViewHeight - 80)];
        [_tmpScrollView setShowsVerticalScrollIndicator:NO];
        [_tmpScrollView setShowsHorizontalScrollIndicator:NO];
        [_tmpScrollView setDelegate:self];
    }
    return _tmpScrollView;
}

- (void)setUpUI{
    
    CGFloat height = 0;
    
    height = [self createDynamicTextView:height];
    
    //    height = [self createAddLabel:height];
    
    height = [self createImageView:height+20];
    
    [self.tmpScrollView setContentSize:CGSizeMake(KScreenWidth, height)];
    
}

//输入工地状态
- (CGFloat)createDynamicTextView:(CGFloat)height{
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(padding, height+10, KScreenWidth - 2*padding,120)];
    [textView setDelegate:self];
    [textView setFont:[UIFont systemFontOfSize:14]];
    [textView setTextColor:[UIColor blackColor]];
    [textView setTag:1001];
    [self.tmpScrollView addSubview:textView];
    
    _personPlace = [[UILabel alloc] initWithFrame:CGRectMake(5, 9 , KScreenWidth, 14)];
    [_personPlace setTextColor:[UIColor colorWithHexString:@"#999999"]];
    [_personPlace setText:@"说说关于这张图的故事吧"];
    [_personPlace setFont:[UIFont systemFontOfSize:14]];
    [textView addSubview:_personPlace];
    
    [self.tmpScrollView addSubview:[Tools setLineView:CGRectMake(padding, height + 140, KScreenWidth - 20, 1)]];
    
    if (self.imageData[@"description"]) {
        [_personPlace setHidden:YES];
        [textView setText:self.imageData[@"description"]];
    }
    
    return height + 141;
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    
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
    
    _content = textView.text;
}

// 添加标签
- (CGFloat)createAddLabel:(CGFloat)height{
    
    height += 20;
    
    UILabel *addLable = [Tools creatLabel:CGRectMake(padding, height, 80 , 30) font:[UIFont systemFontOfSize:14] color:[UIColor colorWithHexString:@"#3b3b3b"] alignment:(NSTextAlignmentCenter) title:@"#添加标签"];
    [addLable setBackgroundColor:[UIColor colorWithHexString:@"#efefef"]];
    [addLable.layer setCornerRadius:2.5];
    [addLable addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    [self.tmpScrollView addSubview:addLable];
    
    return height + 45 ;
}

// 添加图片
- (CGFloat)createImageView:(CGFloat)height{
    
    //    UIImageView *imageView = [Tools creatImage:CGRectMake(padding, height, 80, 80) image:@"tpxq_img"];
    //    [imageView.layer setCornerRadius:5];
    //    [self.tmpScrollView addSubview:imageView];
    
    UIButton *btn = [Tools creatButton:CGRectMake(padding, height , MDXFrom6(80), MDXFrom6(80)) font:[UIFont systemFontOfSize:16] color:[UIColor whiteColor] title:@"" image:@""];
    [btn setBackgroundColor:[UIColor colorWithHexString:@"#efefef"]];
    [btn.layer setCornerRadius:5];
    [btn setClipsToBounds:YES];
    [btn setImage:[UIImage imageNamed:@"up_photo"] forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(addCoverImage:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.tmpScrollView addSubview:btn];
    
    self.coverImage = [[UIImageView alloc] initWithFrame:CGRectMake(padding*2 + MDXFrom6(80), height, MDXFrom6(80), MDXFrom6(80))];
    [self.coverImage setUserInteractionEnabled:YES];
    [self.coverImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBigImage)]];
    [self.tmpScrollView addSubview:self.coverImage];
    
    if (self.imageData[@"url"]) {
        [self.coverImage sd_setImageWithURL:[NSURL URLWithString:self.imageData[@"url"]]];
        _image_url = self.imageData[@"url"];
    }
    
    return height + 100;
}

#pragma mark --- 点击事件

- (void)rightButtonTouchUpInside:(id)sender{

    
    if ([self.imageData[@"description"] isEqualToString:_content] &&[self.imageData[@"img_url"] isEqualToString:_image_url]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }

    
    NSString *path = [NSString stringWithFormat:@"%@/WholeHouse/update_show_image",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    
    NSMutableDictionary * parameter = [NSMutableDictionary dictionaryWithDictionary:@{@"id":self.img_id}];
    
    if (_image_url.length != 0) {
        [parameter setValue:_image_url forKey:@"img_url"];
    }
    if (_content.length != 0) {
        [parameter setValue:_content forKey:@"description"];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:parameter success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
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
    LabelViewController *vc = [[LabelViewController alloc] init];
    [vc setSelectLabel:^(NSDictionary *dic) {
        
        UILabel *label = (UILabel *)sender.view;
        [label setText:[NSString stringWithFormat:@"#%@",dic[@"name"]]];
        
        self->_labelDic = dic;
        
    }];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)showBigImage{
    if (_image_url.length != 0) {
        SDPhotoBrowserd *browser = [[SDPhotoBrowserd alloc] init];
        browser.imageCount = 1; // 图片总数
        browser.currentImageIndex = 0;
        browser.sourceImagesContainerView = self.view.superview; // 原图的父控件
        browser.delegate = self;
        [browser show];
    }
}

- (NSURL *)photoBrowser:(SDPhotoBrowserd *)browser highQualityImageURLForIndex:(NSInteger)index{
    return [NSURL URLWithString:_image_url];
}

#pragma mark -- 上传图片
- (void)addCoverImage:(UIButton *)sender{
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
                    
                    self->_image_url = responseObject[@"datas"][@"fullPath"];
                    [weakSelf.coverImage setImage:image];
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


- (void)leftButtonTouchUpInside:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
