//
//  HouseQA.m
//  anjuyi1
//
//  Created by apple on 2018/7/17.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "HouseQA.h"

@interface HouseQA ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView    * tmpTableView;
@property (nonatomic,strong)NSMutableArray * dataArr;

@end

@implementation HouseQA

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
        [view setBackgroundColor:MDRGBA(239, 239, 239, 1)];
        
        [view addSubview:[Tools creatLabel:CGRectMake(15, 0, KScreenWidth-30, 40) font:[UIFont systemFontOfSize:14] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentLeft) title:@"填写完整更容易获得推荐"]];
        [self addSubview:view];
        
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 110, KScreenWidth, 110)];
        [footView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:footView];
        
        UIButton *btn = [Tools creatButton:CGRectMake(MDXFrom6(80), 35, KScreenWidth - MDXFrom6(160), 46) font:[UIFont systemFontOfSize:16] color:[UIColor whiteColor] title:@"添加问题" image:@""];
        [btn setBackgroundColor:[UIColor colorWithHexString:@"#47baba"]];
        [btn.layer setCornerRadius:23];
        [btn setClipsToBounds:YES];
        [btn addTarget:self action:@selector(addHouseSpace) forControlEvents:(UIControlEventTouchUpInside)];
        [footView addSubview:btn];
        
        [self addSubview:self.tmpTableView];
    }
    return self;
}

- (void)setHouse_id:(NSString *)house_id{
    
    _house_id = house_id;
    
    [self getData];
}

- (void)refreData{
    
    [self getData];
}

- (void)getData{
    self.dataArr = [NSMutableArray array];
    
    
    NSString *path = [NSString stringWithFormat:@"%@/WholeHouse/QA_list",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:@{@"house_id":self.house_id} success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *dic in responseObject[@"datas"]) {
                    [weakSelf.dataArr addObject:dic];
                }
                
            }
            else{
                [ViewHelps showHUDWithText:responseObject[@"message"]];
            }
            
            [weakSelf.tmpTableView reloadData];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self animated:YES];
        [RequestSever showMsgWithError:error];
    }];
    
    
}


#pragma mark -- tableView
- (UITableView *)tmpTableView{
    
    if (!_tmpTableView) {
        _tmpTableView = [[UITableView alloc] initWithFrame:CGRectMake(35, 40, KScreenWidth - 70, self.frame.size.height-150) style:(UITableViewStylePlain)];

        if (@available(iOS 11.0, *)) {
            [_tmpTableView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpTableView setBackgroundColor:[UIColor whiteColor]];
        [_tmpTableView setShowsVerticalScrollIndicator:NO];
        [_tmpTableView setShowsHorizontalScrollIndicator:NO];
        [_tmpTableView setTableFooterView:[UIView new]];
        [_tmpTableView setDataSource:self];
        [_tmpTableView setDelegate:self];
    }
    return _tmpTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HouseQATableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"HouseQATableViewCell"];
    }
    if (indexPath.row < self.dataArr.count) {
        [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        [cell.textLabel setText:self.dataArr[indexPath.row][@"title"]];
        [cell.textLabel setNumberOfLines:2];
        [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
        [cell.textLabel setTextColor:TCOLOR];
        
        if ([self.dataArr[indexPath.row][@"text"] isKindOfClass:[NSString class]]) {
            [cell.detailTextLabel setText:self.dataArr[indexPath.row][@"text"]];
            [cell.detailTextLabel setFont:[UIFont systemFontOfSize:14]];
            [cell.detailTextLabel setTextColor:[UIColor colorWithHexString:@"#999999"]];
        }

        
        [cell setAccessoryType:(UITableViewCellAccessoryDisclosureIndicator)];
    }
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectHouseQA(self.dataArr[indexPath.row]);
}

- (void)addHouseSpace{
    self.addHouseQAToList();
    
}

#pragma mark -- 右划删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteSpaceImage:indexPath];
    }
    
}

- (void)deleteSpaceImage:(NSIndexPath *)indexPath{
  
    NSString *path = [NSString stringWithFormat:@"%@/WholeHouse/del_QA_info",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *paramet = @{@"id":self.dataArr[indexPath.row][@"id"]};
    
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:paramet success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [weakSelf.dataArr removeObjectAtIndex:indexPath.row];
            
            [weakSelf.tmpTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationLeft)];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:weakSelf animated:YES];
        [RequestSever showMsgWithError:error];
    }];
    
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
