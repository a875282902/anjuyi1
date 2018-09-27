//
//  UserTableViewCell.h
//  anjuyi1
//
//  Created by apple on 2018/9/26.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

- (void)bandDataWithDictionary:(NSDictionary *)dic;

@end
