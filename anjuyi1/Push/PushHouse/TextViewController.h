//
//  TextViewController.h
//  anjuyi1
//
//  Created by apple on 2018/7/18.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "BaseViewController.h"

@protocol TextViewControllerDelegat <NSObject>

- (void)textViewInputText:(NSString *)text type:(NSInteger)type;

@end

@interface TextViewController : BaseViewController

@property (nonatomic,assign)NSInteger type;//0为标题 1为说在前面

@property (nonatomic,strong)NSString *text;
@property (nonatomic,strong)NSString *placeHolder;

@property (nonatomic,weak)id<TextViewControllerDelegat>delegate;

@end
