//
//  SearchResultsViewController.m
//  anjuyi1
//
//  Created by apple on 2018/9/26.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "SearchListView.h"
#import "SearchPhotoView.h"
#import "SearchHouseView.h"
#import "SearchView.h"

@interface SearchResultsViewController ()<UIScrollViewDelegate>

//频道
@property (nonatomic,strong) UIScrollView   * channelView;
@property (nonatomic,strong) UIView         * lineView;

@property (nonatomic,strong) UIScrollView   * listScrollView;

@property (nonatomic,strong) NSMutableArray * cateArr;

@property (nonatomic,strong) NSMutableArray * btnArr;

@end

@implementation SearchResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self baseForDefaultLeftNavButton];
    
    self.cateArr = [NSMutableArray array];
    self.btnArr = [NSMutableArray array];
    
    [self.view addSubview:self.channelView];
    
    //搜索框
    SearchView *search = [[SearchView alloc] initWithFrame:CGRectMake(0, 0, MDXFrom6(320), 30) Title:@"搜索"];
    [search addTarget:self action:@selector(jumpSearch)];
    [self.navigationItem setTitleView:search];
    
    [self.view addSubview:self.listScrollView];
 
    [self getType];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1)]];
}

- (void)getType{
    
    
    NSString *path = [NSString stringWithFormat:@"%@/search/get_search_type",KURL];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:nil success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            weakSelf.cateArr = [NSMutableArray arrayWithArray:responseObject[@"datas"]];
            
            [weakSelf setUpContentView];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];

}

- (void)setType:(NSInteger)type{
    if (type >0) {
        _type = type;
    }
    else{
        _type = 0;
    }
    
}

#pragma mark -- scrollview
-(UIScrollView *)listScrollView{
    
    if (!_listScrollView) {
        _listScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, KScreenWidth, KViewHeight-40)];
        [_listScrollView setShowsVerticalScrollIndicator:NO];
        [_listScrollView setShowsHorizontalScrollIndicator:NO];
        if (@available(iOS 11.0, *)) {
            [_listScrollView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_listScrollView setPagingEnabled:YES];
        [_listScrollView setDelegate:self];
    }
    return _listScrollView;
}

-(UIScrollView *)channelView{
    
    if (!_channelView) {
        _channelView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
        [_channelView setShowsVerticalScrollIndicator:NO];
        [_channelView setShowsHorizontalScrollIndicator:NO];
        if (@available(iOS 11.0, *)) {
            [_channelView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_channelView setDelegate:self];
    }
    return _channelView;
}


- (void)setUpContentView{
    
    //添加按钮
    CGFloat horizontalX = 0;
    for (NSInteger i = 0; i <  self.cateArr.count; i++) {
        
        // button 的字号
        UIFont *buttonFont = [UIFont systemFontOfSize:15];
        
        CGRect tmpRect = [[self.cateArr[i] valueForKey:@"name"] boundingRectWithSize:CGSizeMake(1000,35) options:0 attributes:@{NSFontAttributeName : buttonFont} context:nil];
        tmpRect.size.width += 20;
        
        UIButton *butn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [butn setFrame:CGRectMake(horizontalX, 0, tmpRect.size.width, 35)];
        [butn setTitle:[self.cateArr[i] valueForKey:@"name"] forState:(UIControlStateNormal)];
        [butn.titleLabel setFont:buttonFont];
        [butn setTag:i];
        [butn setClipsToBounds:YES];
        [butn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [butn setClipsToBounds:YES];
        [butn setUserInteractionEnabled:YES];
        [butn addTarget:self action:@selector(buttonDidPress:) forControlEvents:(UIControlEventTouchUpInside)];
        horizontalX = horizontalX + butn.frame.size.width + 10;
    
        [self.channelView addSubview:butn];
        [self.btnArr addObject:butn];
    }
    
    [self.channelView setContentSize:CGSizeMake(horizontalX, 35)];
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 35, 20, 2)];
    [self.lineView setBackgroundColor:[UIColor blackColor]];
    [self.channelView addSubview:self.lineView];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0,39, KScreenWidth, 1)]];
    
    //listview
    
    [self.listScrollView setContentSize:CGSizeMake(KScreenWidth * self.cateArr.count, self.listScrollView.frame.size.height)];
    
    SearchPhotoView * searchPhotoV = [[SearchPhotoView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, self.listScrollView.frame.size.height)];
    searchPhotoV.keyword = self.keyword;
    [self.listScrollView addSubview:searchPhotoV];
    
    for (NSInteger i = 1 ; i < self.cateArr.count; i ++) {
        SearchListView * v = [[SearchListView alloc] initWithFrame:CGRectMake(KScreenWidth*i, 0, KScreenWidth, self.listScrollView.frame.size.height)];
        [v setUpKeyWord:self.keyword type:self.cateArr[i][@"id"]];
        [self.listScrollView addSubview:v];
    }
    
//    SearchHouseView * searchHouseV = [[SearchHouseView alloc] initWithFrame:CGRectMake(KScreenWidth, 0, KScreenWidth, self.listScrollView.frame.size.height)];
//    searchHouseV.keyword = self.keyword;
//    [self.listScrollView addSubview:searchHouseV];
    
    
    [self buttonDidPress:self.btnArr[self.type]];
    
    
}

- (void)buttonDidPress:(UIButton *)sender{
    
    [self.lineView setCenter:CGPointMake(sender.center.x, self.lineView.center.y)];
    
    if (sender.frame.origin.x+sender.frame.size.width > KScreenWidth) {
        [self.channelView setContentOffset:CGPointMake(sender.frame.origin.x+sender.frame.size.width - KScreenWidth, 0) animated:YES];
    }
    
    [self.listScrollView setContentOffset:CGPointMake(KScreenWidth *sender.tag, 0) animated:YES];
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView == self.listScrollView) {

        // 如果在拖动结束的时候，没有减速的过程
        if (!decelerate){

            NSInteger page = scrollView.contentOffset.x/KScreenWidth;

            [self buttonDidPress:self.btnArr[page]];
        }
    }

}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.listScrollView) {
        NSInteger page = scrollView.contentOffset.x/KScreenWidth;

        [self buttonDidPress:self.btnArr[page]];
    }
}

- (void)jumpSearch{
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
