//
//  ProjectView.m
//  anjuyi1
//
//  Created by apple on 2018/9/13.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "ProjectView.h"
#import "ProjectCollectionViewCell.h"

@interface ProjectView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UICollectionView * tmpCollectionView;
@property (nonatomic,strong)NSMutableArray   * dataArr;//项目某个状态的数组
@end

@implementation ProjectView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
        self.dataArr = [NSMutableArray array];
        [self addSubview:self.tmpCollectionView];
    }
    return self;
    
}

- (void)refreDataWithID:(NSString *)projectID andType:(NSString *)type{
    
    NSString *path = [NSString stringWithFormat:@"%@/project/get_project_article",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *paramet = @{@"id":projectID,
                              @"type":type};
    
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:paramet success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self animated:YES];
        
        [weakSelf.dataArr removeAllObjects];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *dic in responseObject[@"datas"]) {
                    [weakSelf.dataArr addObject:dic];
                }
                
            }
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        [weakSelf.tmpCollectionView reloadData];
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self animated:YES];
        [RequestSever showMsgWithError:error];
    }];

}

#pragma mark -tmpCollectionView
-(UICollectionView *)tmpCollectionView{
    
    if (!_tmpCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setItemSize:CGSizeMake(MDXFrom6(167), MDXFrom6(230))];
        [layout setSectionInset:UIEdgeInsetsMake(MDXFrom6(5), MDXFrom6(10), MDXFrom6(5), MDXFrom6(10))];
        
        _tmpCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, self.frame.size.height) collectionViewLayout:layout];
        [_tmpCollectionView setBackgroundColor:[UIColor whiteColor]];
        [_tmpCollectionView setDelegate:self];
        [_tmpCollectionView setDataSource:self];
        [_tmpCollectionView registerClass:[ProjectCollectionViewCell class] forCellWithReuseIdentifier:@"ProjectCollectionViewCell"];
    }
    return _tmpCollectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ProjectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProjectCollectionViewCell" forIndexPath:indexPath];
    
    if (indexPath.item < self.dataArr.count) {
        [cell bandDataWithDictionary:self.dataArr[indexPath.item]];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.delegate selectProjectNode:self.dataArr[indexPath.item][@"id"]];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
