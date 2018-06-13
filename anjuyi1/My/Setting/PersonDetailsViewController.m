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

@interface PersonDetailsViewController ()<UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImageView *headerImage;
}
@property (nonatomic,strong)UIScrollView *tmpScrollView;

@property (nonatomic,strong)UIImagePickerController *imagePickerController;

@property (nonatomic,strong)DateView *dateView;

@end

@implementation PersonDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"个人资料"];
    [self baseForDefaultLeftNavButton];
    
    [self.view addSubview:self.tmpScrollView];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1.5)]];
    
    [self setUpUI];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.dateView];
}

-(UIScrollView *)tmpScrollView{
    
    if (!_tmpScrollView) {
        _tmpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-KTopHeight)];
        [_tmpScrollView setShowsVerticalScrollIndicator:NO];
        [_tmpScrollView setShowsHorizontalScrollIndicator:NO];
        [_tmpScrollView setContentSize:CGSizeMake(KScreenWidth, 270)];
        [_tmpScrollView setDelegate:self];
    }
    return _tmpScrollView;
}

- (void)setUpUI{
    
    CGFloat height = 0;
    
    NSArray *tArr = @[@"头像",@"昵称",@"位置",@"生日",@"个人简历"];
    
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
           
        }
        else{
             [backView addSubview:[Tools creatLabel:CGRectMake(15, 0, 200 , backView.frame.size.height) font:[UIFont systemFontOfSize:15] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:tArr[i]]];
        }
        
        [backView addSubview:[Tools creatImage:CGRectMake(KScreenWidth - 35, (backView.frame.size.height -10 )/2, 6, 10) image:@"jilu_rili_arrow"]];
        
        [backView addSubview:[Tools setLineView:CGRectMake(15, backView.frame.size.height - 1, KScreenWidth - 30, 1)]];
        
    }
}

- (DateView *)dateView{
    
    if (!_dateView) {
        
        _dateView = [[DateView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    }
    return _dateView;
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
        // 设置允许编辑
        [self.imagePickerController setAllowsEditing:YES];
        
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
        
    }];
    
    UIAlertAction *trueB = [UIAlertAction actionWithTitle:@"相机" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        self.imagePickerController = [[UIImagePickerController alloc] init];
        
        [self.imagePickerController setDelegate:self];
        // 设置来自相机
        [self.imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        
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
    
    // 我们选取的信息都在info里面，info是一个字典
    //    字典中的键
    /*
     UIImagePickerControllerMediaType;    指定用户选择的媒体类型
     UIImagePickerControllerOriginalImage;    原始图片
     UIImagePickerControllerEditedImage;      修改后的图片
     UIImagePickerControllerCropRect;             裁剪尺寸
     UIImagePickerControllerMediaURL;           媒体的URL
     UIImagePickerControllerReferenceURL        原件的URL
     UIImagePickerControllerMediaMetadata  当数据来源是照相机的时候这个值才有效
     */
    
    
    // 图片类型是修改后的图片
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    // 设置图片
    //    [self.headImageView setImage:selectedImage];
    [headerImage setImage:selectedImage];
    
    // 返回（结束模态对话窗体）
    [picker dismissViewControllerAnimated:YES completion:nil];
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
