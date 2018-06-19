//
//  GoodsClassViewController.m
//  anjuyi1
//
//  Created by apple on 2018/6/14.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "GoodsClassViewController.h"
#import "SearchView.h"

#import "ClassListView.h"
#import "BrandListView.h"

#import "IntegralMallViewController.h"

@interface GoodsClassViewController ()<ClassListViewDelegate,BrandListViewDelegate>

@end

@implementation GoodsClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self baseForDefaultLeftNavButton];
    //搜索框
    SearchView *search = [[SearchView alloc] initWithFrame:CGRectMake(0, 0, MDXFrom6(320), 30) Title:@"沙子  水泥"];
    [search addTarget:self action:@selector(jumpSearch)];
    [self.navigationItem setTitleView:search];
    
    [self setUpUI];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1)]];

}

- (void)jumpSearch{
    
    
}

- (void)setUpUI{
    
    ClassListView *classView = [[ClassListView alloc] initWithFrame:CGRectMake(0, 0, 80, KScreenHeight - KTopHeight)];
    [classView setDelegate:self];
    [self.view addSubview:classView];
    
    BrandListView * brandView = [[BrandListView alloc] initWithFrame:CGRectMake(80, 0, KScreenWidth - 80, KScreenHeight - KTopHeight)];
    [brandView setDelegate:self];
    [self.view addSubview:brandView];
}

- (void)selectClassWithIndex:(NSInteger)index{
    
    
}

- (void)selectBrandWithIndex:(NSInteger)index{
    
    
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
