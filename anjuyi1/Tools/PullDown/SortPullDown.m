//
//  SortPullDown.m
//  PullDownMenu
//
//  Created by lsy on 18/6/26.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "SortPullDown.h"
#import "SortCell.h"

extern NSString * const YZUpdateMenuTitleNote;
static NSString * const ID = @"cell";

@interface SortPullDown ()
//@property (nonatomic, copy) NSArray *titleArray;
@property (nonatomic, assign) NSInteger selectedCol;
@end

@implementation SortPullDown

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _selectedCol = 0;
    
  //  _titleArray = @[@"综合排序",@"人气排序",@"评分排序",@"评价最多"];
    
    [self.tableView registerClass:[SortCell class] forCellReuseIdentifier:ID];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_selectedCol inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SortCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.textLabel.text = _titleArray[indexPath.row];
    if (indexPath.row == 0) {
        [cell setSelected:YES animated:NO];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedCol = indexPath.row;
    
    // 选中当前
    SortCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    // 更新菜单标题
    [[NSNotificationCenter defaultCenter] postNotificationName:YZUpdateMenuTitleNote object:self userInfo:@{@"title":cell.textLabel.text}];
    
    
}

@end
