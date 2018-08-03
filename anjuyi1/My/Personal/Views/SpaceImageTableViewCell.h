//
//  SpaceImageTableViewCell.h
//  anjuyi1
//
//  Created by apple on 2018/8/2.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpaceImageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

- (void)bandDataWithDic:(NSDictionary *)dic;
@end
