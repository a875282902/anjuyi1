//
//  SpaceImageListTableViewCell.h
//  anjuyi1
//
//  Created by apple on 2018/7/17.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpaceImageListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;

- (void)bandDataWith:(NSDictionary *)dic;

@end
