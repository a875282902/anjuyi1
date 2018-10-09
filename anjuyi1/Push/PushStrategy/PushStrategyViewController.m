//
//  PushPhotoViewController.m
//  anjuyi1
//
//  Created by apple on 2018/7/2.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "PushStrategyViewController.h"
#import "PhotoSelectController.h"
#import "SDPhotoBrowserd.h"

#define padding MDXFrom6(10)

@interface PushStrategyViewController ()<UIScrollViewDelegate,UITextViewDelegate,PhotoSelectControllerDelegate,SDPhotoBrowserDelegate>
{
    UILabel *_personPlace;
    UITextView * _tmpTextView;
    NSString  * _image_url;//图片地址
    NSString  * _tag_id;//分类id
    NSString  * _door_id;//户型id
    NSString  * _title;
}

@property (nonatomic,strong) UIScrollView     * tmpScrollView;//承载视图的view
@property (nonatomic,strong) NSDictionary     * member_info;//
@property (nonatomic,strong) UIImageView      * coverImage;//
@property (nonatomic,strong) NSMutableArray   * labelArr;//
@property (nonatomic,strong) NSMutableArray   * labelBtnArr;

@property (nonatomic,strong) NSMutableArray   * doorArr;//
@property (nonatomic,strong) NSMutableArray   * doorBtnArr;
@end

@implementation PushStrategyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"发布攻略"];
    [self baseForDefaultLeftNavButton];
    self.labelArr = [NSMutableArray array];
    self.labelBtnArr = [NSMutableArray array];
    
    self.doorArr = [NSMutableArray array];
    self.doorBtnArr = [NSMutableArray array];
    
    [self.view addSubview:self.tmpScrollView];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1)]];
    
    [self getData];
    
    [self createPushButton];
}

- (void)getData{
    
    
    NSString *path = [NSString stringWithFormat:@"%@/strategy/get_info",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:nil success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            weakSelf.member_info = responseObject[@"datas"][@"member_info"];
            weakSelf.labelArr = [NSMutableArray arrayWithArray:responseObject[@"datas"][@"cate"]];
            weakSelf.doorArr = [NSMutableArray arrayWithArray:responseObject[@"datas"][@"door"]];
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
        if (@available(iOS 11.0, *)) {
            [_tmpScrollView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpScrollView setShowsVerticalScrollIndicator:NO];
        [_tmpScrollView setShowsHorizontalScrollIndicator:NO];
        [_tmpScrollView setDelegate:self];
    }
    return _tmpScrollView;
}

- (void)setUpUI{
    
    CGFloat height = 20;
    
    UIImageView *header = [Tools creatImage:CGRectMake(padding, height, 43, 43) url:self.member_info[@"head"] image:@""];
    [header.layer setCornerRadius:21.5];
    [self.tmpScrollView addSubview:header];
    
    NSString *name = self.member_info[@"nickname"];
    CGFloat nameW = KHeight(name, 10000, 20, 18).size.width + padding;
    
    [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(65, 20,nameW , 25) font:[UIFont systemFontOfSize:18] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:name]];
    
    UILabel *typeLabel = [Tools creatLabel:CGRectMake(65+ nameW, 22.5 , 50, 20) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#fffefe"] alignment:(NSTextAlignmentCenter) title:self.member_info[@"level"]];
    [typeLabel.layer setCornerRadius:5];
    [typeLabel setBackgroundColor:[UIColor colorWithHexString:@"#5cc6c6"]];
    [self.tmpScrollView addSubview:typeLabel];
    
    [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(65, 45 ,KScreenWidth - 75 , 20) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentLeft) title:self.member_info[@"position"]]];
    
    [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(65, 45 ,KScreenWidth - 75 , 20) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentRight) title:[Tools getCurrentTimes]]];
    
    height += 83;
    
    [self.tmpScrollView addSubview:[Tools setLineView:CGRectMake(padding, height, KScreenWidth - 20, 1)]];
    
    
    height = [self createLabelView:height];
    height = [self createDoorView:height];
    
    UITextField * textField = [[UITextField alloc] initWithFrame:CGRectMake(15, height, KScreenWidth-30, 50)];
    [textField setPlaceholder:@"请输入标题"];
    [textField setFont:[UIFont systemFontOfSize:14]];
    [textField addTarget:self action:@selector(textFieldValueChange:) forControlEvents:(UIControlEventEditingChanged)];
    [self.tmpScrollView addSubview:textField];
    
    [self.tmpScrollView addSubview:[Tools setLineView:CGRectMake(15, height+49, KScreenWidth, 1)]];
    
    height+= 50;
    
    height = [self createDynamicTextView:height];
    
    height = [self createImageView:height+10.0f];
    
    [self.tmpScrollView setContentSize:CGSizeMake(KScreenWidth, height)];
    
}

- (CGFloat)createLabelView:(CGFloat)height{
    
    UIScrollView * cetaScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, height, KScreenWidth, 55)];
    [cetaScrollView setShowsVerticalScrollIndicator:NO];
    [cetaScrollView setShowsHorizontalScrollIndicator:NO];
    [self.tmpScrollView addSubview:cetaScrollView];
    
    CGFloat x = 15.0f;
    CGFloat y = 10.0f;
    CGFloat w = 0;
    CGFloat h = 35.0f;
    
    for (NSInteger i = 0 ; i < self.labelArr.count ; i ++) {
        
        NSString *str = [NSString stringWithFormat:@"%@",self.labelArr[i][@"name"]];
        
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        style.lineBreakMode = NSLineBreakByWordWrapping;
        style.alignment = NSTextAlignmentLeft;
        
        NSAttributedString *atts = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:style}];
        
        CGRect rext = [atts boundingRectWithSize:CGSizeMake(10000, 35) options:(NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin) context:nil];
        
        w = rext.size.width + 20.0f;
        
        UIButton *btn = [Tools creatButton:CGRectMake(x, y, w, h) font:[UIFont systemFontOfSize:14] color:[UIColor colorWithHexString:@"#2cb7b5"] title:str image:@""];
        [btn setBackgroundColor:[UIColor colorWithHexString:@"#eaf8f8"]];
        [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateSelected)];
        [btn.layer setBorderWidth:1];
        [btn.layer setBorderColor:[UIColor colorWithHexString:@"#34bab8"].CGColor];
        [btn.layer setCornerRadius:5];
        [btn setClipsToBounds:YES];
        [btn setTag:i];
        [btn addTarget:self action:@selector(selectLabel:) forControlEvents:(UIControlEventTouchUpInside)];
        [cetaScrollView addSubview:btn];
        
        x += w+ 10.0f;
        [self.labelBtnArr addObject:btn];
    }
    [cetaScrollView setContentSize:CGSizeMake( x , 55)];

    [self.tmpScrollView addSubview:[Tools setLineView:CGRectMake(0, height+54, KScreenWidth, 1)]];
    
    return height+55;
}

- (CGFloat)createDoorView:(CGFloat)height{
    
    UIScrollView * doorScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, height, KScreenWidth, 55)];
    [doorScrollView setShowsVerticalScrollIndicator:NO];
    [doorScrollView setShowsHorizontalScrollIndicator:NO];
    [self.tmpScrollView addSubview:doorScrollView];
    
    CGFloat x = 15.0f;
    CGFloat y = 10.0f;
    CGFloat w = 0;
    CGFloat h = 35.0f;
    
    for (NSInteger i = 0 ; i < self.doorArr.count ; i ++) {
        
        NSString *str = [NSString stringWithFormat:@"%@",self.doorArr[i][@"name"]];
        
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        style.lineBreakMode = NSLineBreakByWordWrapping;
        style.alignment = NSTextAlignmentLeft;
        
        NSAttributedString *atts = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:style}];
        
        CGRect rext = [atts boundingRectWithSize:CGSizeMake(10000, 35) options:(NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin) context:nil];
        
        w = rext.size.width + 20.0f;
        
        UIButton *btn = [Tools creatButton:CGRectMake(x, y, w, h) font:[UIFont systemFontOfSize:14] color:[UIColor colorWithHexString:@"#2cb7b5"] title:str image:@""];
        [btn setBackgroundColor:[UIColor colorWithHexString:@"#eaf8f8"]];
        [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateSelected)];
        [btn.layer setBorderWidth:1];
        [btn.layer setBorderColor:[UIColor colorWithHexString:@"#34bab8"].CGColor];
        [btn.layer setCornerRadius:5];
        [btn setClipsToBounds:YES];
        [btn setTag:i];
        [btn addTarget:self action:@selector(selectDoor:) forControlEvents:(UIControlEventTouchUpInside)];
        [doorScrollView addSubview:btn];
        
        x += w+ 10.0f;
        [self.doorBtnArr addObject:btn];
    }
    [doorScrollView setContentSize:CGSizeMake( x , 55)];
    
    [self.tmpScrollView addSubview:[Tools setLineView:CGRectMake(0, height+54, KScreenWidth, 1)]];
    
    return height+55;
}

//输入工地状态
- (CGFloat)createDynamicTextView:(CGFloat)height{
    
    _tmpTextView = [[UITextView alloc] initWithFrame:CGRectMake(padding, height+10, KScreenWidth - 2*padding,120)];
    [_tmpTextView setDelegate:self];
    [_tmpTextView setFont:[UIFont systemFontOfSize:14]];
    [_tmpTextView setTextColor:[UIColor blackColor]];
    [_tmpTextView setTag:1001];
    [self.tmpScrollView addSubview:_tmpTextView];
    
    _personPlace = [[UILabel alloc] initWithFrame:CGRectMake(5, 9 , KScreenWidth, 14)];
    [_personPlace setTextColor:[UIColor colorWithHexString:@"#999999"]];
    [_personPlace setText:@"请输入你的故事~~~"];
    [_personPlace setFont:[UIFont systemFontOfSize:14]];
    [_tmpTextView addSubview:_personPlace];
    
    [self.tmpScrollView addSubview:[Tools setLineView:CGRectMake(padding, height + 140, KScreenWidth - 20, 1)]];
    
    return height + 141;
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
    
    return height + 100;
}

- (void)createPushButton{
    
    UIButton *btn = [Tools creatButton:CGRectMake(padding, KViewHeight -  65, KScreenWidth - 2*padding, 50) font:[UIFont systemFontOfSize:16] color:[UIColor whiteColor] title:@"发布" image:@""];
    [btn setBackgroundColor:BTNCOLOR];
    [btn.layer setCornerRadius:5];
    [btn setClipsToBounds:YES];
    [btn addTarget:self action:@selector(push) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
}


#pragma mark --- 点击事件
- (void)selectLabel:(UIButton *)sender{
    
    for (UIButton *btn in self.labelBtnArr) {
        [btn setBackgroundColor:[UIColor colorWithHexString:@"#eaf8f8"]];
        [btn setSelected:NO];
    }
    [sender setSelected:YES];
    [sender setBackgroundColor:[UIColor colorWithHexString:@"#34bab8"]];
    
    _tag_id = [NSString stringWithFormat:@"%@",self.labelArr[sender.tag][@"id"]];
}

- (void)selectDoor:(UIButton *)sender{
    
    for (UIButton *btn in self.doorBtnArr) {
        [btn setBackgroundColor:[UIColor colorWithHexString:@"#eaf8f8"]];
        [btn setSelected:NO];
    }
    [sender setSelected:YES];
    [sender setBackgroundColor:[UIColor colorWithHexString:@"#34bab8"]];
    
    _door_id = [NSString stringWithFormat:@"%@",self.doorArr[sender.tag][@"id"]];
}

- (void)textFieldValueChange:(UITextField *)sender{
    _title = sender.text;
}

- (void)push{
    
    if (_title .length == 0) {
        [ViewHelps showHUDWithText:@"请输入标题"];
        return;
    }
    if (_tag_id.length == 0) {
        [ViewHelps showHUDWithText:@"请选择分类信息"];
        return;
    }
    if (_door_id.length == 0) {
        [ViewHelps showHUDWithText:@"请选择户型"];
        return;
    }
    
    if (_tmpTextView.text.length == 0) {
        [ViewHelps showHUDWithText:@"请输入内容"];
        return;
    }
    
    if (_image_url.length == 0) {
        [ViewHelps showHUDWithText:@"请选择图片"];
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/strategy/add_strategy",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    
    NSDictionary *parameter = @{@"image_url":_image_url,
                                @"cate_id":_tag_id,
                                @"content":_tmpTextView.text,
                                @"title":_title,
                                @"door":_door_id};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:parameter success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            [ViewHelps showHUDWithText:@"发布成功"];
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
    [self dismissViewControllerAnimated:YES completion:nil];
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
