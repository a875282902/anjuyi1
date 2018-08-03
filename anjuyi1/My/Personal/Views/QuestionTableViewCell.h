//
//  QuestionTableViewCell.h
//  anjuyi1
//
//  Created by apple on 2018/8/3.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
- (void)bandDataWithDictionary:(NSDictionary *)dic;
@end
