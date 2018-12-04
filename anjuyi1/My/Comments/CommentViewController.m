//
//  CommentViewController.m
//  anjuyi1
//
//  Created by 李 on 2018/6/2.
//  Copyright © 2018年 lsy. All rights reserved.
//
//  评论

#import "CommentViewController.h"
#import "CommentTableViewCell.h"
#import "CommentDetalisViewController.h"

@interface CommentViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView    * tmpTableView;

@property (nonatomic,strong) NSMutableArray * dataArr;
@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self baseForDefaultLeftNavButton];
    [self setTitle:@"评论"];
    
    self.dataArr = [NSMutableArray array];
    
    
    [self.view addSubview:self.tmpTableView];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1)]];
    
    [self getCommentData];
}

- (void)getCommentData{
    
    NSString *path = [NSString stringWithFormat:@"%@/person/user_evaluate",KURL];
    
    NSDictionary *dic = @{@"user_id":self.user_id};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *dic in responseObject[@"datas"]) {
                    
                    [weakSelf.dataArr addObject:[weakSelf addAttributeToDic:dic]];
                }
            }
            
            [weakSelf.tmpTableView reloadData];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
    
}

- (NSDictionary *)addAttributeToDic:(NSDictionary *)dic{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    NSString * str = dict[@"content"];
    
    CGFloat h = [str boundingRectWithSize:CGSizeMake(MDXFrom6(290), 1000) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.height;
    
    CGFloat w = [str boundingRectWithSize:CGSizeMake(1000000, 16) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.width+MDXFrom6(10);
    
    [dict setValue:[NSString stringWithFormat:@"%.2f",h] forKey:@"titleHight"];
    [dict setValue:[NSString stringWithFormat:@"%.2f",w] forKey:@"titleWidth"];
    [dict setValue:str forKey:@"title"];
    
    return dict;
}

#pragma mark -- tableView
- (UITableView *)tmpTableView{
    
    if (!_tmpTableView) {
        _tmpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-KTopHeight) style:(UITableViewStylePlain)];
        [_tmpTableView setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
        if (@available(iOS 11.0, *)) {
            [_tmpTableView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpTableView setShowsVerticalScrollIndicator:NO];
        [_tmpTableView setShowsHorizontalScrollIndicator:NO];
        [_tmpTableView setDataSource:self];
        [_tmpTableView setDelegate:self];
    }
    return _tmpTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentTableViewCell"];
    if (!cell) {
        cell = [[CommentTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"CommentTableViewCell"];
    }
    
    [cell bandDataWith:self.dataArr[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = self.dataArr[indexPath.row];
    
    NSInteger h = [dic[@"titleWidth"] floatValue]/MDXFrom6(290);
    
    CGFloat wid = [dic[@"titleWidth"] floatValue] -  MDXFrom6(290) *h;
    
    if (wid > MDXFrom6(240)) {
        
        return [dic[@"titleHight"] floatValue]+MDXFrom6(47)+31;
    }
    else{
        
        return [dic[@"titleHight"] floatValue]+MDXFrom6(46)+15;
    }
    
    return 400;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataArr[indexPath.row];
    
    NSInteger type = [dic[@"type"] integerValue];
    //项目1 整屋 2 文章 3 图片 4 活动精选 5
    if (type == 1) type =3;
    if (type == 4||type == 5) type =1;
    if (type == 3) type =4;
    CommentDetalisViewController *controller = [[CommentDetalisViewController alloc] init];
    controller.eva_id = dic[@"id"];
    
    controller.type = type;
    [self.navigationController pushViewController:controller animated:YES];
    
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
