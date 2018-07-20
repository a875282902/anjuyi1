//
//  PowerStationList.h
//  anjuyi1
//
//  Created by apple on 2018/7/20.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PowerStatonModel.h"

@interface PowerStationList : UIView

- (void)setDataArr:(NSMutableArray *)dataArr type:(NSString *)type;

@property (nonatomic,copy)void(^selectStaionListType)(NSInteger index);

@property (nonatomic,copy)void(^selectStaionToShowDetails)( PowerStatonModel *model);

@end
