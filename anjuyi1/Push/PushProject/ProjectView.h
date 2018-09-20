//
//  ProjectView.h
//  anjuyi1
//
//  Created by apple on 2018/9/13.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ProjectViewDelegate <NSObject>

- (void)selectProjectNode:(NSString *)nodeID;

@end

@interface ProjectView : UIView


- (void)refreDataWithID:(NSString *)projectID andType:(NSString *)type;

@property (nonatomic,weak)id<ProjectViewDelegate>delegate;

@end
