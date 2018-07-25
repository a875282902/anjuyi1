//
//  HouseQA.h
//  anjuyi1
//
//  Created by apple on 2018/7/24.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HouseQA : UIView


@property (nonatomic,strong)NSString *house_id;

@property (nonatomic,copy)void(^selectHouseQA)(NSDictionary *dic);

@property (nonatomic,copy)void(^addHouseQAToList)(void);


- (void)refreData;


@end
