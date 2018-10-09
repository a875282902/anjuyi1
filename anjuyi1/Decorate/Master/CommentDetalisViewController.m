//
//  CommentDetalisViewController.m
//  anjuyi1
//
//  Created by apple on 2018/9/19.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "CommentDetalisViewController.h"

@interface CommentDetalisViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation CommentDetalisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self baseForDefaultLeftNavButton];
    
    [self setTitle:@"评论详情"];
    
    [self.headerImage.layer setCornerRadius:22.5];
    [self.typeLabel.layer setCornerRadius:5];
    
    [self getCommentInfo];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1)]];
}

- (void)getCommentInfo{
    
    NSArray * uArr = @[@"",@"index/image_evaluate_detail",@"whole_house_info/whole_evaluate_detail",@"project_info/project_evaluate_detail",@"strategy_info/evaluate_detail"];
    
    NSString *path = [NSString stringWithFormat:@"%@/%@",KURL,uArr[self.type]];
    
    NSDictionary *header = @{@"token":UTOKEN};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:@{@"eva_id":self.eva_id} success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [weakSelf.headerImage sd_setImageWithURL:[NSURL URLWithString:responseObject[@"datas"][@"member_info"][@"head"]]];
            [weakSelf.nickName setText:responseObject[@"datas"][@"member_info"][@"nick_name"]];
            [weakSelf.typeLabel setText:responseObject[@"datas"][@"member_info"][@"level"]];
            [weakSelf.timeLabel setText:responseObject[@"datas"][@"create_time"]];
            [weakSelf.contentLabel setText:responseObject[@"datas"][@"content"]];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
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
