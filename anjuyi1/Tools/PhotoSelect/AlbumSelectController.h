//
//  AlbumSelectController.h
//  photoSelect
//
//  Created by apple on 2018/6/26.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@protocol AlbumSelectControllerDelegate <NSObject>

- (void)selectPhotoAlbum:(PHAssetCollection *)collection;

@end

@interface AlbumSelectController : UIViewController

@property (nonatomic,weak)id<AlbumSelectControllerDelegate>delegate;

@end
