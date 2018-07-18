//
//  HouseSpace.h
//  anjuyi1
//
//  Created by apple on 2018/7/17.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HouseSpace : UIView

@property (nonatomic,strong)NSString *house_id;

@property (nonatomic,copy)void(^selectHouseSpace)(NSDictionary *dic);

@property (nonatomic,copy)void(^addHouseSpaceToList)(void);


- (void)refreData;

@end
