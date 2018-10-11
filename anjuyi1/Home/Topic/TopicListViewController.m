//
//  TopicListViewController.m
//  anjuyi1
//
//  Created by apple on 2018/8/10.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "TopicListViewController.h"

#import "AddTopicViewController.h"//添加话题

#import "ChannelView.h"
#import "TopicListView.h"

@interface TopicListViewController ()<ChannelViewDelegate,UIScrollViewDelegate,TopicListViewDelegate,TopicListViewDelegate>

//频道数组
@property (nonatomic,strong) NSMutableArray * cateArr;

@property (nonatomic,strong) UIScrollView   * topicListViewScroll;

@property (nonatomic,strong) ChannelView    * channelView ;
@property (nonatomic,strong) NSMutableArray * viewArr ;

@end

@implementation TopicListViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self baseForDefaultLeftNavButton];
    [self setTitle:@"话题"];
    self.cateArr = [NSMutableArray array];
    self.viewArr = [NSMutableArray array];
    
    [self.view addSubview:self.channelView];
    
    [self getCategoryChannel];
    
    [self.view addSubview:self.topicListViewScroll];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1)]];
    
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, KViewHeight - 80, KScreenWidth, 1)]];
    UIButton *btn = [Tools creatButton:CGRectMake((KScreenWidth- 200)/2,KViewHeight -  17.5- 45, 200, 45) font:[UIFont systemFontOfSize:18] color:[UIColor whiteColor] title:@"发布话题" image:@""];
    [btn setBackgroundColor:GCOLOR];
    [btn.layer setCornerRadius:22.5];
    [btn setClipsToBounds:YES];
    [btn addTarget:self action:@selector(addTopic) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
}

#pragma mark -- 获取频道

- (ChannelView *)channelView{
    if (!_channelView) {
        _channelView = [[ChannelView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 50)];
       
        [_channelView setDelegate:self];
    }
    return _channelView;
}

- (void)getCategoryChannel{
    
    NSString *path = [NSString stringWithFormat:@"%@/topic_info/topic_cate_list",KURL];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:nil success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                
                [weakSelf.cateArr removeAllObjects];
                
                [weakSelf.cateArr addObject:@{@"id":@"0",@"name":@"全部"}];
                
                for (NSDictionary *dic in responseObject[@"datas"]) {
                    [weakSelf.cateArr addObject:dic];
                }
                
                [weakSelf.channelView setCateArr:weakSelf.cateArr];
                
                //添加有多少view
                [weakSelf setUpScrollViewContent];
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

- (void)clickBtnIndex:(NSInteger)index{
    
    [self.topicListViewScroll setContentOffset:CGPointMake(KScreenWidth*index, 0) animated:YES];
    
    TopicListView *listV = self.viewArr[index];
    [listV autoRefreshIfNeed];
    
}



#pragma mark -- 频道列表view
-(UIScrollView *)topicListViewScroll{
    
    if (!_topicListViewScroll) {
        _topicListViewScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0,50, KScreenWidth, KViewHeight-50-80)];
        [_topicListViewScroll setShowsVerticalScrollIndicator:NO];
        [_topicListViewScroll setShowsHorizontalScrollIndicator:NO];
        if (@available(iOS 11.0, *)) {
            [_topicListViewScroll setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_topicListViewScroll setPagingEnabled:YES];
        [_topicListViewScroll setDelegate:self];
    }
    return _topicListViewScroll;
}

- (void)setUpScrollViewContent{
    
    for (NSInteger i = 0 ; i < self.cateArr.count ; i ++) {
        TopicListView *listV = [[TopicListView alloc] initWithFrame:CGRectMake(KScreenWidth * i, 0, KScreenWidth, self.topicListViewScroll.frame.size.height)];
        listV.cate_id = [NSString stringWithFormat:@"%@",self.cateArr[i][@"id"]];
        listV.delegate =self;
        [self.topicListViewScroll addSubview:listV];
        
        if (i==0) {
            [listV autoRefreshIfNeed];
        }
        
        [self.viewArr addObject:listV];
    }
    [self.topicListViewScroll setContentSize:CGSizeMake(KScreenWidth * self.cateArr.count, self.topicListViewScroll.frame.size.height)];
}

- (void)jumpToTopicDetails:(UIViewController *)vc{
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addTopic{
    
    LOGIN
    
    AddTopicViewController *VC = [[AddTopicViewController alloc] init];
    VC.cateArr = self.cateArr;
    [self.navigationController pushViewController:VC animated:YES];
    
}

#pragma mark -- scrollVIew 协议 、、 数据刷新
- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView == self.topicListViewScroll) {
        
        // 如果在拖动结束的时候，没有减速的过程
        if (!decelerate){
            
            NSInteger page = scrollView.contentOffset.x/KScreenWidth;
            
            [self.channelView selectBtnIndex:page];
        }
    }
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.topicListViewScroll) {
        NSInteger page = scrollView.contentOffset.x/KScreenWidth;
        
        [self.channelView selectBtnIndex:page];
    }
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
