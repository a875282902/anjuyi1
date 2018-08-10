//
//  AddProjectViewController.m
//  anjuyi1
//
//  Created by apple on 2018/7/3.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "AddProjectViewController.h"
#import "ProjectAddressViewController.h"
#import "PhotoSelectController.h"
#import "SelectLocationVC.h"

#import "PullDownView.h"
#import "YZMenuButton.h"
#import "DefaultPullDown.h"

#define padding 20

@interface AddProjectViewController ()<UIScrollViewDelegate,PhotoSelectControllerDelegate,DefaultPullDownDelegate,SelectLocationVCDelegate>
{
    NSDictionary  * _provincesDic;//保存省
    NSDictionary  * _cityDic;//保存城市
    NSDictionary  * _areaDic;//保存区
    NSString      * _picture;//保存封面地址
    NSInteger       _currentSelect;//当前下拉的view 0为房间 1为室
    UIButton *_selectLocationBtn;
}
@property (nonatomic,strong)UIScrollView     * tmpScrollView;
@property (nonatomic,strong)UILabel          * location;//地址
@property (nonatomic,strong)NSMutableArray   * textArr;//存储输入信息的数组
@property (nonatomic,strong)UIImageView      * coverImage;


@property (nonatomic,strong)PullDownView     * pullDownView;//下拉选择框
@property (nonatomic,strong)NSMutableArray   * roomArr;
@property (nonatomic,strong)NSMutableArray   * hallArr;
@property (nonatomic,strong)NSMutableArray   * buttonArr;
@property (nonatomic,strong)NSMutableArray   * selectRoomArr;



@end

@implementation AddProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self baseForDefaultLeftNavButton];
    [self setTitle:@"新增项目"];
    
    self.textArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"", nil];
    self.roomArr = [NSMutableArray array];
    self.hallArr = [NSMutableArray array];
    self.buttonArr = [NSMutableArray array];
    self.selectRoomArr = [NSMutableArray arrayWithObjects:@"",@"",@"", nil];
    
    [self.view addSubview:self.tmpScrollView];
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1)]];
    
    [self setUpUI];
    
    [self createPushButton];
    
    [self getRoom];
}

#pragma mark -- data
- (void)getRoom{
    
    
    NSString *path = [NSString stringWithFormat:@"%@/Project/get_insert_info",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
  
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:nil success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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
                [btn1 setTitle:weakSelf.roomArr[0][@"name"] forState:(UIControlStateNormal)];
                UIButton *btn2 = weakSelf.buttonArr[1];
                [btn2 setTitle:weakSelf.hallArr[0][@"name"] forState:(UIControlStateNormal)];
                
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

#pragma mark -- scrollview
-(UIScrollView *)tmpScrollView{
    
    if (!_tmpScrollView) {
        _tmpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, KScreenWidth, KViewHeight - 50 - 80)];
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
    
    UIView * alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 50)];
    [alertView setBackgroundColor:MDRGBA(246, 246, 246, 1)];
    [self.view addSubview:alertView];
    
    [alertView addSubview:[Tools creatLabel:CGRectMake(padding, 0, KScreenWidth - 2*padding, 50) font:[UIFont systemFontOfSize:12] color:TCOLOR alignment:(NSTextAlignmentLeft) title:@"定位说明：请您准确定位项目位置，后期客户需要根据定位来访问工地。"]];
    
    CGFloat height = 25.0f;;
    
    
    height = [self selectLocationView:height];
    height = [self selectRoomModelView:height];
    height = [self inputPersonInfor:height];
    height = [self ceateCoverImage:height];
    
    self.coverImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, height + 10, KScreenWidth, KScreenWidth/2.0)];
    [self.tmpScrollView addSubview:self.coverImage];
    
    height += KScreenWidth/2.0 + 10;
    
    [self.tmpScrollView setContentSize:CGSizeMake(KScreenWidth, height)];
}

// ---------- 选择地址 -------
- (CGFloat)selectLocationView:(CGFloat)height{
    
    [self.tmpScrollView addSubview:[Tools creatImage:CGRectMake(MDXFrom6(20), height + 10, 15, 15) image:@"add_add"]];
    
    CGRect rect = [@"北京  朝阳区" boundingRectWithSize:CGSizeMake(1000000, 35) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    
    self.location = [Tools creatLabel:CGRectMake(MDXFrom6(45), height, rect.size.width , 35) font:[UIFont systemFontOfSize:15] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:@"北京  朝阳区"];
    [self.tmpScrollView addSubview:self.location];
    
    UIButton * rechange = [Tools creatButton:CGRectMake(MDXFrom6(65) + rect.size.width, height, MDXFrom6(80), MDXFrom6(35)) font:[UIFont systemFontOfSize:14] color:[UIColor colorWithHexString:@"#23b7b5"] title:@"重新选择" image:@""];
    [rechange setBackgroundColor:[UIColor colorWithHexString:@"#eaf8f8"]];
    [rechange.layer setCornerRadius:7.5];
    [rechange.layer setBorderColor:[UIColor colorWithHexString:@"#34bab8"].CGColor];
    [rechange.layer setBorderWidth:1];
    [rechange addTarget:self action:@selector(rechangeLocation:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.tmpScrollView addSubview:rechange];
    
    _selectLocationBtn = rechange;

    return height + 50;
}

// ---------- 选择户型 -------
- (CGFloat)selectRoomModelView:(CGFloat)height{
    
    [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(20), height, MDXFrom6(50), 30) font:[UIFont systemFontOfSize:15] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentLeft) title:@"户型："]];
    
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
        [button setFrame:CGRectMake(i==0?MDXFrom6(85):MDXFrom6(195), height, MDXFrom6(100), 30)];
        [button setTag:i];
        [button addTarget:self action:@selector(selectRoomNum:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.tmpScrollView addSubview:button];
        
        [self.buttonArr addObject:button];
    }
    
    
    return height + 40;
}

- (CGFloat)inputPersonInfor:(CGFloat)height{
    
    // ---------- 输入信息 -------
    NSArray *tArr = @[@"输入您的住宅面积(整数)",@"输入小区名称",@"输入可预约时间"];
    
    for (NSInteger i = 0 ; i <  3; i++) {
        UITextField *userName = [[UITextField alloc] initWithFrame:CGRectMake(MDXFrom6(20), height, MDXFrom6(335), 50)];
        [userName setPlaceholder:tArr[i]];
        [userName setFont:[UIFont systemFontOfSize:16]];
        [userName setClearButtonMode:(UITextFieldViewModeAlways)];
        [userName setTag:i];
        [userName setKeyboardType:(UIKeyboardTypeNumberPad)];
        [userName addTarget:self action:@selector(textValueChange:) forControlEvents:(UIControlEventEditingChanged)];
        [self.tmpScrollView addSubview:userName];
        
        if (i==1 || i==2) {
            [userName setKeyboardType:(UIKeyboardTypeDefault)];
        }
        
        [self.tmpScrollView addSubview:[self creatLine:CGRectMake(MDXFrom6(20), height + 49, MDXFrom6(335), 1)]];
        
        height += 50;
        
    }
    return height;
}

- (UIView *)creatLine:(CGRect)rect{
    
    UIView *v = [[UIView alloc] initWithFrame:rect];
    [v setBackgroundColor:[UIColor colorWithHexString:@"#d1d1d1"]];
    return v;
}

- (CGFloat)ceateCoverImage:(CGFloat)height{
    
    UIButton *btn = [Tools creatButton:CGRectMake(MDXFrom6(20), height + MDXFrom6(20) , MDXFrom6(80), MDXFrom6(80)) font:[UIFont systemFontOfSize:16] color:[UIColor whiteColor] title:@"" image:@""];
    [btn setBackgroundColor:[UIColor colorWithHexString:@"#efefef"]];
    [btn.layer setCornerRadius:5];
    [btn setClipsToBounds:YES];
    [btn setImage:[UIImage imageNamed:@"up_photo"] forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(addCoverImage:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.tmpScrollView addSubview:btn];
    
    
    return height + MDXFrom6(110);
}

- (void)createPushButton{
    
    UIButton *btn = [Tools creatButton:CGRectMake(padding, KViewHeight -  65, KScreenWidth - 2*padding, 50) font:[UIFont systemFontOfSize:16] color:[UIColor whiteColor] title:@"新增项目" image:@""];
    [btn setBackgroundColor:BTNCOLOR];
    [btn.layer setCornerRadius:5];
    [btn setClipsToBounds:YES];
    [btn addTarget:self action:@selector(push) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
}

#pragma mark  -- 点击事件  选择地址
- (void)rechangeLocation:(UIButton *)sender{
    
    SelectLocationVC *vc = [[SelectLocationVC alloc] init];
    [vc setDelegate:self];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)sureProvince:(NSDictionary *)province city:(NSDictionary *)city area:(NSDictionary *)area{
    
    _provincesDic = province;
         _cityDic = city;
         _areaDic = area;
    
    NSString *address = [NSString stringWithFormat:@"%@ %@ %@",_provincesDic[@"value"],_cityDic[@"value"],_areaDic[@"value"]];
    
    
    CGRect rect = [address boundingRectWithSize:CGSizeMake(1000000, 35) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    
    if (55 + rect.size.width + 95 < KScreenWidth) {
        [self->_location setText:address];
        [self->_location setFrame:CGRectMake(40, self->_location.frame.origin.y, rect.size.width , 35)];
        [self->_selectLocationBtn setFrame:CGRectMake(55 + rect.size.width, self->_selectLocationBtn.frame.origin.y, 80, 35)];
    }
    else{
        
        [self->_location setText:address];
        [self->_location setFrame:CGRectMake(40,self->_location.frame.origin.y , KScreenWidth - 95 - 55-15 , 35)];
        [self->_selectLocationBtn setFrame:CGRectMake(KScreenWidth - 95, self->_selectLocationBtn.frame.origin.y, 80, 35)];
    }
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

- (void)textValueChange:(UITextField *)sender{// tag 1 为账号
    
    [self.textArr replaceObjectAtIndex:sender.tag withObject:sender.text];
}

#pragma mark -- 封面

- (void)addCoverImage:(UIButton *)sende{
    
    PhotoSelectController *vc = [[PhotoSelectController alloc] init];
    [vc setDelegate:self];
    [vc setIsClip:YES];
    [vc setClipSize:CGSizeMake(KScreenWidth, KScreenWidth/2)];
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
                [weakSelf.coverImage setImage:image];
                self->_picture = responseObject[@"datas"][@"fullPath"];
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

- (void)push{
    
    if (!_provincesDic || !_cityDic || !_areaDic) {
        [ViewHelps showHUDWithText:@"请选择地址"];
        return;
    }
 
    if ([self.textArr[0] length] == 0) {
        [ViewHelps showHUDWithText:@"请输入住宅面积"];
        return;
    }
    if ([self.textArr[1] length] == 0) {
        [ViewHelps showHUDWithText:@"请输入小区名字"];
        return;
    }
    if ([_picture length]==0) {
        [ViewHelps showHUDWithText:@"请选择封面"];
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/Project/add_project",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    
    
    NSDictionary *paramet = @{@"province":_provincesDic[@"key"],
                              @"city":_cityDic[@"key"],
                              @"area":_areaDic[@"key"],
                              @"room_id":self.selectRoomArr[0][@"id"],
                              @"hall_id":self.selectRoomArr[1][@"id"],
                              @"areaop":self.textArr[0],
                              @"nameregister":self.textArr[1],
                              @"appointment_time":self.textArr[2],
                              @"picture":_picture};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:paramet success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [ViewHelps showHUDWithText:@"新增成功"];
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
