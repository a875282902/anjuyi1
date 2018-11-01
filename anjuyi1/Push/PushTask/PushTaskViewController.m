//
//  FreeOfferViewController.m
//  anjuyi1
//
//  Created by apple on 2018/6/14.
//  Copyright © 2018年 lsy. All rights reserved.
//
//  发布任务

#import "PushTaskViewController.h"
#import "SelectCityView.h"//选择地址

#import "PullDownView.h"
#import "YZMenuButton.h"
#import "DefaultPullDown.h"

#import "LSYLocation.h"

#import "PhotoSelectController.h"

#define padding 20

@interface PushTaskViewController ()<SelectCityViewDelegate,DefaultPullDownDelegate,LSYLocationDelegta,UIScrollViewDelegate,PhotoSelectControllerDelegate>
{
    NSInteger time;
    UIButton *codeBtn;
    NSDictionary *_province;
    NSDictionary *_city ;
    NSDictionary *_area ;
    UIButton * _selectLocationBtn;
    NSInteger       _currentSelect;//当前下拉的view 0为房间 1为室
    UIButton * _selectTypeBtn;
    UIButton * _upLoadBtn;

}

@property (nonatomic,strong)UIScrollView   * tmpScrollView;

@property (nonatomic,strong)NSMutableArray * textArr;
@property (nonatomic,strong)NSTimer        * timer;
@property (nonatomic,strong)UILabel        * location;
@property (nonatomic,strong)LSYLocation    * locationSevice;
@property (nonatomic,strong)UIView         * modelImageView;//户型图的view
@property (nonatomic,strong)NSMutableArray * modelImageArr;//户型图的图片数组

@property (nonatomic,strong)PullDownView     * pullDownView;//下拉选择框
@property (nonatomic,strong)NSMutableArray   * roomArr;
@property (nonatomic,strong)NSMutableArray   * hallArr;
@property (nonatomic,strong)NSMutableArray   * buttonArr;
@property (nonatomic,strong)NSMutableArray   * selectRoomArr;

@property (nonatomic,strong)SelectCityView   * selectCityView;//选择城市


@end

@implementation PushTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self baseForDefaultLeftNavButton];
    
    [self setTitle:@"发布任务"];
    
    self.textArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"",@"", nil];
    time = 60;
    self.roomArr = [NSMutableArray array];
    self.hallArr = [NSMutableArray array];
    self.buttonArr = [NSMutableArray array];
    self.selectRoomArr = [NSMutableArray arrayWithObjects:@"",@"",@"", nil];
    self.modelImageArr = [NSMutableArray arrayWithObjects:@"", nil];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setUpUI];
    
    [self getRoom];
    
    [self.locationSevice beginUpdatingLocation];
    
    [self.view addSubview:self.selectCityView];
    
}
- (void)getRoom{
    
    
    NSString *path = [NSString stringWithFormat:@"%@/person_task/get_publish_info",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:nil success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf.roomArr removeLastObject];
        [weakSelf.hallArr removeLastObject];
        if ([responseObject[@"code"] integerValue] == 200) {
            for (NSDictionary *dic  in responseObject[@"datas"][@"room"]) {
                [weakSelf.roomArr addObject:dic];
            }
            
            for (NSDictionary *dic  in responseObject[@"datas"][@"hall"]) {
                [weakSelf.hallArr addObject:dic];
            }
            
            DefaultPullDown *sort1 = [[DefaultPullDown alloc] init];
            sort1.titleArray = weakSelf.roomArr;
            [sort1 setDelegate:weakSelf];
            [weakSelf addChildViewController:sort1];
            
            DefaultPullDown *sort2 = [[DefaultPullDown alloc] init];
            sort2.titleArray = weakSelf.hallArr;
            [sort2 setDelegate:weakSelf];
            [weakSelf addChildViewController:sort2];
            
            if (weakSelf.buttonArr.count > 0 && weakSelf.hallArr.count > 0 && weakSelf.roomArr.count > 0) {
                UIButton *btn1 = weakSelf.buttonArr[0];
                [btn1 setTitle:weakSelf.roomArr[0] forState:(UIControlStateNormal)];
                UIButton *btn2 = weakSelf.buttonArr[1];
                [btn2 setTitle:weakSelf.hallArr[0] forState:(UIControlStateNormal)];
                
                [weakSelf.selectRoomArr replaceObjectAtIndex:0 withObject:weakSelf.roomArr[0]];
                [weakSelf.selectRoomArr replaceObjectAtIndex:1 withObject:weakSelf.hallArr[0]];
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
// 选择的房间 数量
- (void)dafalutPullDownSelect:(NSInteger)index{
    
    if (_currentSelect == 0) {
        [self.selectRoomArr replaceObjectAtIndex:0 withObject:self.roomArr[index]];
    }
    else{
        [self.selectRoomArr replaceObjectAtIndex:0 withObject:self.hallArr[index]];
    }
}

#pragma mark --  UI

-(UIScrollView *)tmpScrollView{
    
    if (!_tmpScrollView) {
        _tmpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, KScreenWidth, KViewHeight-50-80)];
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
    
    UIView * alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 50)];
    [alertView setBackgroundColor:MDRGBA(246, 246, 246, 1)];
    [self.view addSubview:alertView];
    
    [alertView addSubview:[Tools creatLabel:CGRectMake(padding, 0, KScreenWidth - 2*padding, 50) font:[UIFont systemFontOfSize:12] color:TCOLOR alignment:(NSTextAlignmentLeft) title:@"发布说明：您发布的任务会由平台上的人员进行接单，请如实填写任务情况。"]];
    
    [self.view addSubview:self.tmpScrollView];
    
    CGFloat height = 25.0f;;
    
    height = [self selectLocationView:height];//房屋地址
    
    height = [self selectRoomTypeView:height];//
    
    height = [self selectRoomModelView:height];//房屋户型
    
    height = [self inputPersonInfor:height];//个人信息
    
    height = [self ceateCoverImage:height];//上传封面
    

    [self.tmpScrollView setContentSize:CGSizeMake(KScreenWidth, height)];
    
    [self createPushButton];
  
}
- (SelectCityView *)selectCityView{
    
    if (!_selectCityView) {
        
        _selectCityView = [[SelectCityView alloc] initWithFrame:CGRectMake(0, 0 , KScreenWidth, KViewHeight)];
        [_selectCityView setDelegate:self];
    }
    return _selectCityView;
}

// ---------- 选择地址 -------
- (CGFloat)selectLocationView:(CGFloat)height{
    
    [self.tmpScrollView addSubview:[Tools creatImage:CGRectMake(MDXFrom6(35), height + 10, 15, 15) image:@"add_add"]];
    
    CGRect rect = [@"北京  朝阳区" boundingRectWithSize:CGSizeMake(1000000, 35) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    
    self.location = [Tools creatLabel:CGRectMake(MDXFrom6(60), height, rect.size.width , 35) font:[UIFont systemFontOfSize:15] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:@"北京  朝阳区"];
    [self.tmpScrollView addSubview:self.location];
    
    UIButton * rechange = [Tools creatButton:CGRectMake(MDXFrom6(80) + rect.size.width, height, MDXFrom6(80), MDXFrom6(35)) font:[UIFont systemFontOfSize:14] color:[UIColor colorWithHexString:@"#23b7b5"] title:@"重新选择" image:@""];
    [rechange setBackgroundColor:[UIColor colorWithHexString:@"#eaf8f8"]];
    [rechange.layer setCornerRadius:7.5];
    [rechange.layer setBorderColor:[UIColor colorWithHexString:@"#34bab8"].CGColor];
    [rechange.layer setBorderWidth:1];
    [rechange addTarget:self action:@selector(rechangeLocation:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.tmpScrollView addSubview:rechange];
    
    _selectLocationBtn = rechange;
    
    return height + 50;
}

- (CGFloat)selectRoomTypeView:(CGFloat)height{
    
       [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(35), height, MDXFrom6(50), 30) font:[UIFont systemFontOfSize:15] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentLeft) title:@"类型："]];
    
    for (NSInteger i = 0 ; i < 2 ; i++) {
        
        UIButton *btn = [Tools creatButton:CGRectMake(MDXFrom6(20), MDXFrom6(60), KScreenWidth - MDXFrom6(40), MDXFrom6(50)) font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#999999"] title:@[@"  家装",@"  工装"][i] image:@"cart_select_no"];
        [btn setImage:[UIImage imageNamed:@"cart_selected"] forState:(UIControlStateSelected)];
        [btn addTarget:self action:@selector(selectRoomType:) forControlEvents:(UIControlEventTouchUpInside)];
        [btn setFrame:CGRectMake(i==0?MDXFrom6(100):MDXFrom6(210), height, MDXFrom6(100), 30)];
        [btn setTag:i];
        if (i==0) {
            _selectTypeBtn = btn;
            [btn setSelected:YES];
        }
        
        [self.tmpScrollView addSubview:btn];
        
    }
    
    
    return height + 40;
}

// ---------- 选择户型 -------
- (CGFloat)selectRoomModelView:(CGFloat)height{
    
    [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(35), height, MDXFrom6(50), 30) font:[UIFont systemFontOfSize:15] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentLeft) title:@"户型:"]];

    for (NSInteger i = 0 ; i < 2 ; i++) {
        
        YZMenuButton *button = [YZMenuButton buttonWithType:UIButtonTypeCustom];
        [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:25 /255.0 green:143/255.0 blue:238/255.0 alpha:1] forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:@"标签-向下箭头"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"标签-向上箭头"] forState:UIControlStateSelected];
        [button.layer setBorderWidth:1];
        [button.layer setCornerRadius:5];
        [button.layer setBorderColor:[UIColor colorWithHexString:@"#d1d1d1"].CGColor];
        [button setFrame:CGRectMake(i==0?MDXFrom6(100):MDXFrom6(210), height, MDXFrom6(100), 30)];
        [button setTag:i];
        [button addTarget:self action:@selector(selectRoomNum:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.tmpScrollView addSubview:button];
        
        [self.buttonArr addObject:button];
    }
    
    
    
    return height + 40;
}


- (CGFloat)inputPersonInfor:(CGFloat)height{
    
    // ---------- 输入信息 -------
    NSArray *tArr = @[@"输入您的住宅面积(整数)",@"输入您的预算（整数万元）",@"输入联系手机号码",@"联系人姓名",@"验证码",@"备注您的要求"];
    
    for (NSInteger i = 0 ; i <  tArr.count; i++) {
        UITextField *userName = [[UITextField alloc] initWithFrame:CGRectMake(MDXFrom6(35), height, MDXFrom6(305), 50)];
        [userName setPlaceholder:tArr[i]];
        [userName setFont:[UIFont systemFontOfSize:16]];
        [userName setClearButtonMode:(UITextFieldViewModeAlways)];
        [userName setTag:i];
        [userName setKeyboardType:(UIKeyboardTypeNumberPad)];
        if (i == 3 || i == 5) {
            [userName setKeyboardType:(UIKeyboardTypeDefault)];
        }
        
        [userName addTarget:self action:@selector(textValueChange:) forControlEvents:(UIControlEventEditingChanged)];
        [self.tmpScrollView addSubview:userName];
        
        [self.tmpScrollView addSubview:[self creatLine:CGRectMake(MDXFrom6(35), height + 49, MDXFrom6(305), 1)]];
        
        height += 50;
        
        if (i == 4) {
            UIButton *codeBtn1 = [Tools creatButton:CGRectMake(KScreenWidth - 130, height - 42.5 , 95, 35) font:[UIFont systemFontOfSize:15] color:[UIColor whiteColor] title:@"获取验证码" image:@""];
            [codeBtn1 setBackgroundColor:BTNCOLOR];
            [codeBtn1.layer setCornerRadius:5];
            [codeBtn1 setClipsToBounds:YES];
            [codeBtn1 setTag:1];
            [codeBtn1 addTarget:self action:@selector(getCode:) forControlEvents:(UIControlEventTouchUpInside)];
            [self.tmpScrollView addSubview:codeBtn1];
            
            codeBtn = codeBtn1;
        }
    }
    return height;
}

- (CGFloat)ceateCoverImage:(CGFloat)height{
    
    self.modelImageView = [[UIView alloc] initWithFrame:CGRectMake(0, height, KScreenWidth, MDXFrom6(110))];
    [self.tmpScrollView addSubview:self.modelImageView];
    
    
    UIButton *btn = [Tools creatButton:CGRectMake(MDXFrom6(20), MDXFrom6(20) , MDXFrom6(80), MDXFrom6(80)) font:[UIFont systemFontOfSize:12] color:TCOLOR title:@"上传户型图" image:@""];
    [btn setBackgroundColor:[UIColor colorWithHexString:@"#efefef"]];
    [btn.layer setCornerRadius:5];
    [btn setClipsToBounds:YES];
    [btn setImage:[UIImage imageNamed:@"up_photo"] forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(addCoverImage:) forControlEvents:(UIControlEventTouchUpInside)];
    
    CGFloat offset = MDXFrom6(20);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -btn.imageView.frame.size.width, -btn.imageView.frame.size.height-offset/2, 0);
    btn.imageEdgeInsets = UIEdgeInsetsMake(-btn.titleLabel.intrinsicContentSize.height-offset/2, 0, 0, -btn.titleLabel.intrinsicContentSize.width);
    
    [self.modelImageView addSubview:btn];
    
    _upLoadBtn = btn;
    
    return height + MDXFrom6(110);
}

- (void)createPushButton{
    
    UIButton *btn = [Tools creatButton:CGRectMake(MDXFrom6(35), KViewHeight -  65, KScreenWidth - MDXFrom6(70), MDXFrom6(50)) font:[UIFont systemFontOfSize:18] color:[UIColor whiteColor] title:@"发布" image:@""];
    [btn setBackgroundColor:[UIColor colorWithHexString:@"#ffb638"]];
    [btn.layer setCornerRadius:5];
    [btn setClipsToBounds:YES];
    [btn addTarget:self action:@selector(submit) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
}


- (UIView *)creatLine:(CGRect)rect{
    
    UIView *v = [[UIView alloc] initWithFrame:rect];
    [v setBackgroundColor:[UIColor colorWithHexString:@"#d1d1d1"]];
    return v;
}

- (void)refreModelImageView{
    
    [self.modelImageView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat y = self.modelImageView.frame.origin.y;
    CGFloat height = ceil(self.modelImageArr.count/4.0)*MDXFrom6(85)+MDXFrom6(25);
    
    
    [self.modelImageView setFrame:CGRectMake(0, y , KScreenWidth, height)];
    
    [self.tmpScrollView setContentSize:CGSizeMake(KScreenWidth, height+y)];
    
    [self.modelImageView addSubview:_upLoadBtn];
    
    for (NSInteger i = 1 ; i < self.modelImageArr.count; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(MDXFrom6(20+85*(i%4)), MDXFrom6(20+85*(i/4)+5) , MDXFrom6(75), MDXFrom6(75))];
        [imageView setUserInteractionEnabled:YES];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.modelImageArr[i]]];
        [self.modelImageView addSubview:imageView];
        
        UIButton *dele = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [dele setImage:[UIImage imageNamed:@"new_close"] forState:(UIControlStateNormal)];
        [dele setTag:i];
        [dele setFrame:CGRectMake(MDXFrom6(64), -5, MDXFrom6(15), MDXFrom6(15))];
        [dele addTarget:self action:@selector(deleteImage:) forControlEvents:(UIControlEventTouchUpInside)];
        [imageView addSubview:dele];
    }
}

#pragma mark -- 点击事件
- (void)leftButtonTouchUpInside:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rechangeLocation:(UIButton *)sender{
    
    [self.selectCityView show];
}

- (void)sureProvince:(NSDictionary *)province city:(NSDictionary *)city area:(NSDictionary *)area{
    
    _province = province;
    _city = city;
    _area = area;
    
    NSString *address = [NSString stringWithFormat:@"%@ %@ %@",province[@"value"],city[@"value"],area[@"value"]];
    
    
    CGRect rect = [address boundingRectWithSize:CGSizeMake(1000000, 35) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    
    if (MDXFrom6(60) + rect.size.width + 95 < KScreenWidth) {
        [self->_location setText:address];
        [self->_location setFrame:CGRectMake(MDXFrom6(60), self->_location.frame.origin.y, rect.size.width , 35)];
        [self->_selectLocationBtn setFrame:CGRectMake(MDXFrom6(75) + rect.size.width, self->_selectLocationBtn.frame.origin.y, 80, 35)];
    }
    else{
        
        [self->_location setText:address];
        [self->_location setFrame:CGRectMake(MDXFrom6(60),self->_location.frame.origin.y , KScreenWidth - 95 - 55-15 , 35)];
        [self->_selectLocationBtn setFrame:CGRectMake(KScreenWidth - 95, self->_selectLocationBtn.frame.origin.y, 80, 35)];
    }
}

- (void)selectRoomType:(UIButton *)sender{
    
    [_selectTypeBtn setSelected:NO];
    
    [sender setSelected:YES];
    _selectTypeBtn = sender;
}

- (void)textValueChange:(UITextField *)sender{// tag 1 为账号
    
    [self.textArr replaceObjectAtIndex:sender.tag withObject:sender.text];
}
- (PullDownView *)pullDownView{
    
    if (!_pullDownView) {
        _pullDownView  = [[PullDownView alloc] init];
        [self.view addSubview:_pullDownView];
    }
    return _pullDownView;
}

- (void)selectRoomNum:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
    _currentSelect = sender.tag;
    
    CGRect rext = [sender convertRect:sender.bounds toView:self.view];
    
    CGRect frame;
    frame.origin.x = rext.origin.x;
    frame.origin.y = rext.origin.y + rext.size.height;
    frame.size.width = rext.size.width;
    frame.size.height = 150;
    
    [self.pullDownView showOrHidden:NO withFrame:frame button:sender view:((DefaultPullDown *)self.childViewControllers[sender.tag]).view];
}
//删除图片
- (void)deleteImage:(UIButton *)sender{
    
    [self.modelImageArr removeObjectAtIndex:sender.tag];
    [self refreModelImageView];
}

// 提交
- (void)submit{
  
    NSArray * tArr = @[@"您的住宅面积(整数)",@"您的预算（整数万元）",@"联系手机号码",@"联系人姓名",@"验证码",@"备注您的要求"];
    
    for (NSInteger i = 0 ; i < tArr.count; i ++) {
        NSString *str = tArr[i];
        if ([str length]==0) {
            [ViewHelps showHUDWithText:[NSString stringWithFormat:@"请输入%@",tArr[i]]];
            return;
        }
    }
    
    if (self.modelImageArr.count<=1) {
        [ViewHelps showHUDWithText:@"户型图至少上传一张"];
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/person_task/publish",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    
    NSMutableDictionary * parameter = [NSMutableDictionary dictionaryWithDictionary:@{@"province":_province[@"key"],@"city":_city[@"key"],@"area":_area[@"key"],@"room":self.selectRoomArr[0],@"hall":self.selectRoomArr[1],@"proportion":self.textArr[0],@"budget":self.textArr[1],@"mobile":self.textArr[2],@"name":self.textArr[3],@"code":self.textArr[4],@"requirements":self.textArr[5],@"type":[NSString stringWithFormat:@"%ld",_selectTypeBtn.tag+1]}];

    for (NSInteger i =1; i < self.modelImageArr.count; i++) {
        [parameter setValue:self.modelImageArr[i] forKey:[NSString stringWithFormat:@"image_list[%ld]",i-1]];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:parameter success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
    
    
}

#pragma mark -- 验证码
- (void)getCode:(UIButton *)sender{
    
    if ([self.textArr[2] length] !=11) {
        
        [ViewHelps showHUDWithText:@"请输入正确的手机号"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *path = [NSString stringWithFormat:@"%@/login/getMobileCode",KURL];
    
    NSDictionary *dic = @{@"mobile":self.textArr[2]};
    
    [HttpRequest POST:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            if (!self.timer) {
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
            }
            else {
                [self.timer setFireDate:[NSDate distantPast]];
            }
            
            [sender removeTarget:self action:@selector(getCode:) forControlEvents:(UIControlEventTouchUpInside)];
            
            self->time = 60;
            
            [sender setTitle:@"60 S" forState:(UIControlStateNormal)];
            
            [ViewHelps showHUDWithText:@"验证码发送成功，请注意查收"];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [ViewHelps showHUDWithText:@"验证码发送失败，请再次发送"];
    }];
    
    
}

- (void)timeChange{
    
    time -- ;
    
    if (time<1) {
        if (![codeBtn.titleLabel.text isEqualToString:@"获取验证码"]) {
            [codeBtn setTitle:@"获取验证码" forState:(UIControlStateNormal)];
            [codeBtn addTarget:self action:@selector(getCode:) forControlEvents:(UIControlEventTouchUpInside)];
            
            [self.timer setFireDate:[NSDate distantFuture]];
        }
        
    }
    else{
        [codeBtn setTitle:[NSString stringWithFormat:@"%ld S",time] forState:(UIControlStateNormal)];
    }
}
#pragma mark -- 封面

- (void)addCoverImage:(UIButton *)sende{
    
    PhotoSelectController *vc = [[PhotoSelectController alloc] init];
    [vc setDelegate:self];
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
    
    [HttpRequest uploadFileWithInferface:path parameters:nil fileData:UIImagePNGRepresentation(image) serverName:@"file" saveName:@"232323.png" mimeType:(MCPNGImageFileType) progress:^(float progress) {
        NSLog(@"%.2f",progress);
    } success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            NSLog(@"成功");
            
            if ([responseObject[@"datas"][@"route"] integerValue]==200) {
                
                [weakSelf.modelImageArr addObject:responseObject[@"datas"][@"fullPath"]];
                
                [weakSelf refreModelImageView];
            }
            else{
                [ViewHelps showHUDWithText:@"图片加载失败，请重新选择"];
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
#pragma mark -- 获取地址
- (LSYLocation *)locationSevice{
    
    if (!_locationSevice) {
        _locationSevice = [[LSYLocation alloc] init];
        [_locationSevice setDelegate:self];
    }
    return _locationSevice;
}

- (void)loctionWithProvince:(NSDictionary *)province city:(NSDictionary *)city area:(NSDictionary *)area{
    [self sureProvince:province city:city area:area];
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
