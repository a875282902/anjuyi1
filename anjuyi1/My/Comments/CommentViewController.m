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
#import "CommentDetailsVC.h"

@interface CommentViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView    * tmpTableView;

@property (nonatomic,strong) NSMutableArray * dataArr;
@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self baseForDefaultLeftNavButton];
    [self setTitle:@"我的评论"];
    
    NSArray *tArr = @[@"美式整屋、乡村风格，她家聚集了当下最流行的元素！",@"客厅应该摆放什么东西！",@"美式整屋、乡村风格，她家聚集了!"];
    
    self.dataArr = [NSMutableArray array];
    
    for (NSInteger i = 0 ; i < tArr.count; i++) {
        
        NSString * str = tArr[i];
        
        CGFloat h = [str boundingRectWithSize:CGSizeMake(MDXFrom6(290), 1000) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.height;
        
        CGFloat w = [str boundingRectWithSize:CGSizeMake(1000000, 16) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.width+MDXFrom6(10);
        
        [self.dataArr addObject:@{@"titleHight":[NSString stringWithFormat:@"%.2f",h],@"titleWidth":[NSString stringWithFormat:@"%.2f",w],@"title":str}];
    }
    
    
    [self.view addSubview:self.tmpTableView];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1)]];
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
    
    CommentDetailsVC *controller = [[CommentDetailsVC alloc] init];
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
