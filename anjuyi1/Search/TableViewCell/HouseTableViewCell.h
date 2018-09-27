//
//  HouseTableViewCell.h
//  anjuyi1
//
//  Created by apple on 2018/9/26.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HouseTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;

- (void)bandDataWithModel:(NSDictionary *)dic;

@end
