//
//  PhotoSelectController.m
//  photoSelect
//
//  Created by apple on 2018/6/26.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "PhotoSelectController.h"
#import <Photos/Photos.h>
#import "AlbumSelectController.h"
#import "PhotoCuttingBox.h"


#define KScreenHeight [[UIScreen mainScreen] bounds].size.height
#define KScreenWidth [[UIScreen mainScreen] bounds].size.width
#define KStatusBarHeight [[UIApplication sharedApplication]statusBarFrame].size.height //状态栏高度
#define KNavBarHeight 44.0
#define KTopHeight (KStatusBarHeight + KNavBarHeight)
#define KViewHeight (KScreenHeight - KTopHeight)//视图的高

@interface PhotoSelectController ()<UICollectionViewDelegate,UICollectionViewDataSource,AlbumSelectControllerDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) UICollectionView        * tmpCollectionView;
@property (nonatomic,strong) NSMutableArray          * dataArr;
@property (nonatomic,strong) UIButton                * navButton;
@property (nonatomic,strong) PhotoCuttingBox         * selectImage;
@property (nonatomic,strong) UIImagePickerController * imagePickerController;

@end

@implementation PhotoSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.navButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.navButton setTitle:@"选择相册" forState:(UIControlStateNormal)];
    [self.navButton addTarget:self action:@selector(selectAlbum:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.navButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [self.navigationItem setTitleView:self.navButton];
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"back" style:(UIBarButtonItemStyleDone) target:self action:@selector(back)]];
    
    [self creatImageView];
    
    self.dataArr = [NSMutableArray array];
    
    [self.view addSubview: self.tmpCollectionView];
    
    [self getPhotoList];
    
}

- (void)back{
    
    [self.delegate selectImage:[self nomalSnapshotImage]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- 选中的图片
- (void)creatImageView{
    
    self.selectImage = [[PhotoCuttingBox alloc] initWithFrame:CGRectMake(0, KTopHeight, KScreenWidth, KScreenWidth) withIsClip:self.isClip WithSize:_clipSize];
    [self.view addSubview:self.selectImage];

}
#pragma mark -- 获取相片
- (void)getPhotoList{

    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    NSLog(@"%ld",(long)status);
    
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
    
        NSLog(@"无权限访问");
    }
    else{
        
        NSArray *arr = [self getAllAssetInPhotoAblumWithAscending:YES];
        
        self.dataArr = [NSMutableArray arrayWithArray:arr];
        
        [self.dataArr insertObject:@"" atIndex:0];
        
        [self.tmpCollectionView reloadData];
    
    }
  
}

#pragma mark --  选择相册
- (void)selectAlbum:(UIButton *)sender{
    
    AlbumSelectController *cont = [[AlbumSelectController alloc] init];
    [cont setDelegate:self];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cont];
    
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    
}

- (void)selectPhotoAlbum:(PHAssetCollection *)collection{
    
    [self.navButton setTitle:collection.localizedTitle forState:(UIControlStateNormal)];
    
    [self enumerateAssetsInAssetCollection:collection original:YES];
    
}


#pragma mark -tmpCollectionView
-(UICollectionView *)tmpCollectionView{
    
    if (!_tmpCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setItemSize:CGSizeMake(KScreenWidth/4, KScreenWidth/4)];
        [layout setSectionInset:UIEdgeInsetsMake(0,0, 0, 0)];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        
        _tmpCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, KScreenWidth + KTopHeight, KScreenWidth , KViewHeight - KScreenWidth) collectionViewLayout:layout];
        [_tmpCollectionView setBackgroundColor:[UIColor whiteColor]];
        [_tmpCollectionView setDelegate:self];
        [_tmpCollectionView setDataSource:self];
        [_tmpCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ProjectCollectionViewCell"];
    }
    return _tmpCollectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProjectCollectionViewCell" forIndexPath:indexPath];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth/4, KScreenWidth/4)];
    
    if (indexPath.item == 0) {
        [image setBackgroundColor:[UIColor blackColor]];
        
    }
    else{
        PHAsset *asset = self.dataArr[indexPath.item];
        
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.resizeMode = PHImageRequestOptionsResizeModeNone;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
        options.networkAccessAllowed = YES;
        options.synchronous = YES;
        
        
        // 从asset中获得图片
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(KScreenWidth/4, KScreenWidth/4) contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            [image setImage:result];
            [image setClipsToBounds:YES];
            
        }];
    }
    
    [cell.contentView addSubview:image];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.item == 0) {
        [self chooseImageFromIphone];
    }
    else{
        PHAsset *asset = self.dataArr[indexPath.item];
        
        
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.resizeMode = PHImageRequestOptionsResizeModeNone;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
        options.networkAccessAllowed = YES;
        options.synchronous = YES;
        // 从asset中获得图片
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(asset.pixelWidth, asset.pixelHeight) contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            [self.selectImage changeImage:result];
            
        }];
    }
}


- (CGSize)scrollViewContentSize:(PHAsset *)asset{
    
    CGSize size;
    
    if (asset.pixelHeight > asset.pixelWidth) {
     
        size = CGSizeMake(KScreenWidth, KScreenWidth *((CGFloat)asset.pixelHeight/(CGFloat)asset.pixelWidth));
    }
    else{
        
        size = CGSizeMake(KScreenWidth *((CGFloat)asset.pixelWidth/(CGFloat)asset.pixelHeight), KScreenWidth);
    }
    
    return size;
    
}


- (UIImage *)nomalSnapshotImage
{
    
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(KScreenWidth, KScreenWidth), NO, 0);
    [self.selectImage.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (self.isClip) {

        snapshotImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([snapshotImage CGImage], CGRectMake(2, KScreenWidth/2 +2 , KScreenWidth*2 - 4, KScreenWidth - 4))];
    }
    
    
    
    return snapshotImage;
}




#pragma mark - 获取相册内所有照片资源
- (NSArray<PHAsset *> *)getAllAssetInPhotoAblumWithAscending:(BOOL)ascending
{
    NSMutableArray<PHAsset *> *assets = [NSMutableArray array];
    
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    //ascending 为YES时，按照照片的创建时间升序排列;为NO时，则降序排列
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];
    
    PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:option];
    
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAsset *asset = (PHAsset *)obj;
//        NSLog(@"照片名%@", [asset valueForKey:@"filename"]);
        [assets addObject:asset];
    }];
    
    return assets;
}



- (void)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection original:(BOOL)original
{
//    NSLog(@"相簿名:%@", assetCollection.localizedTitle);
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    
    // 获得某个相簿中的所有PHAsset对象
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    
    
    self.dataArr = [NSMutableArray array];
    
    [self.tmpCollectionView reloadData];
    for (PHAsset *asset in assets) {
        
        [self.dataArr addObject:asset];
    }
    
    [self.dataArr insertObject:@"" atIndex:0];
}


#pragma mark -- 系统相机
- (void)chooseImageFromIphone{
    
    if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]) {
        
        self.imagePickerController = [[UIImagePickerController alloc] init];
        
        [self.imagePickerController setDelegate:self];
        // 设置来自相机
        [self.imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        
        // 设置允许编辑
        [self.imagePickerController setAllowsEditing:NO];
        
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    }
    
}


// 选择图片的回调
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    // 图片类型是修改后的图片
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // 设置图片
    [self.selectImage changeImage:selectedImage];
    
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
