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

/**
 *  @author LSY
 *
 *  @brief  刷新
 *
 *  @param projectID  项目id
 *  @param type  项目状态
 *  @param cate  1 发布还是 2查看
 */
- (void)refreDataWithID:(NSString *)projectID andType:(NSString *)type cate:(NSInteger)cate;

@property (nonatomic,weak)id<ProjectViewDelegate>delegate;

@end
