//
//  AlbumSelectController.m
//  photoSelect
//
//  Created by apple on 2018/6/26.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "AlbumSelectController.h"

#define KScreenHeight [[UIScreen mainScreen] bounds].size.height
#define KScreenWidth [[UIScreen mainScreen] bounds].size.width
#define KStatusBarHeight [[UIApplication sharedApplication]statusBarFrame].size.height //状态栏高度
#define KNavBarHeight 44.0
#define KTopHeight (KStatusBarHeight + KNavBarHeight)
#define KViewHeight (KScreenHeight - KTopHeight)//视图的高

static NSString *const CellId = @"AlbumTableViewCell";

@interface AlbumSelectController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tmpTableView;

@property (nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation AlbumSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"所有相册"];
    
    [self.view addSubview:self.tmpTableView];
    
    [self.tmpTableView setAutoresizesSubviews:YES];
    
    [self getData];
    
}

- (void)getData{
    
    self.dataArr = [NSMutableArray array];
    
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL *stop) {
    
        [self.dataArr addObject:collection];
        
    }];
    
    [self.tmpTableView reloadData];
}

#pragma mark -- tableView
- (UITableView *)tmpTableView{
    
    if (!_tmpTableView) {
        _tmpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KTopHeight, KScreenWidth, KViewHeight) style:(UITableViewStylePlain)];
        if (@available(iOS 11.0, *)) {
            [_tmpTableView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpTableView setShowsVerticalScrollIndicator:NO];
        [_tmpTableView setShowsHorizontalScrollIndicator:NO];
        [_tmpTableView setTableFooterView:[UIView new]];
        [_tmpTableView setDataSource:self];
        [_tmpTableView setDelegate:self];
    }
    return _tmpTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CellId];
    }
    
    
    if (indexPath.row < self.dataArr.count) {
        PHAssetCollection * collection = self.dataArr[indexPath.row];
        
        [cell.textLabel setText:[NSString stringWithFormat:@"%@(%ld)",collection.localizedTitle,[[PHAsset fetchAssetsInAssetCollection:collection options:nil] count]]];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.delegate selectPhotoAlbum:self.dataArr[indexPath.row]];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
