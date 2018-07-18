//
//  HouseSpace.m
//  anjuyi1
//
//  Created by apple on 2018/7/17.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "HouseSpace.h"
#import "HouseSpaceTableViewCell.h"

@interface HouseSpace ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView    * tmpTableView;
@property (nonatomic,strong)NSMutableArray * dataArr;

@end

@implementation HouseSpace

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
        [self addSubview:self.tmpTableView];
        [self dragButtonClick];
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
    
    
    NSString *path = [NSString stringWithFormat:@"%@/WholeHouse/house_show_list",KURL];
    
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
        _tmpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, self.frame.size.height) style:(UITableViewStyleGrouped)];
        [_tmpTableView setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
        if (@available(iOS 11.0, *)) {
            [_tmpTableView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpTableView setBackgroundColor:[UIColor whiteColor]];
        [_tmpTableView setShowsVerticalScrollIndicator:NO];
        [_tmpTableView setShowsHorizontalScrollIndicator:NO];
        [_tmpTableView setDataSource:self];
        [_tmpTableView setDelegate:self];
    }
    return _tmpTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HouseSpaceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HouseSpaceTableViewCell"];
    if (!cell) {
        cell = [[HouseSpaceTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"HouseSpaceTableViewCell"];
    }
    if (indexPath.row < self.dataArr.count) {
        [cell bandDataWith:self.dataArr[indexPath.row]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    [view setBackgroundColor:MDRGBA(239, 239, 239, 1)];
    
    [view addSubview:[Tools creatLabel:CGRectMake(15, 0, KScreenWidth-30, 40) font:[UIFont systemFontOfSize:14] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentLeft) title:@"长按对空间排序"]];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectHouseSpace(self.dataArr[indexPath.row]);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 110.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 110)];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *btn = [Tools creatButton:CGRectMake(MDXFrom6(80), 35, KScreenWidth - MDXFrom6(160), 46) font:[UIFont systemFontOfSize:16] color:[UIColor whiteColor] title:@"添加空间" image:@""];
    [btn setBackgroundColor:[UIColor colorWithHexString:@"#47baba"]];
    [btn.layer setCornerRadius:23];
    [btn setClipsToBounds:YES];
    [btn addTarget:self action:@selector(addHouseSpace) forControlEvents:(UIControlEventTouchUpInside)];
    [view addSubview:btn];
    

    
    return view;
}

- (void)addHouseSpace{
    self.addHouseSpaceToList();
    
}


#pragma mark -- cell 长按排序
- (void)dragButtonClick{
    //添加长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressRecognizer:)];
    //    self.longPress = longPress;
    longPress.minimumPressDuration = 0.3;
    [self.tmpTableView addGestureRecognizer:longPress];
}
- (void)longPressRecognizer:(UILongPressGestureRecognizer *)longPress{
    //获取长按的点及cell
    CGPoint location = [longPress locationInView:self.tmpTableView];
    NSIndexPath *indexPath = [self.tmpTableView indexPathForRowAtPoint:location];
    UIGestureRecognizerState state = longPress.state;
    
    static UIView *snapView = nil;
    static NSIndexPath *sourceIndex = nil;
    switch (state) {
        case UIGestureRecognizerStateBegan:{
            if (indexPath) {
                sourceIndex = indexPath;
                UITableViewCell *cell = [self.tmpTableView cellForRowAtIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                snapView = [self customViewWithTargetView:cell];
                
                __block CGPoint center = cell.center;
                snapView.center = center;
                snapView.alpha = 0.0;
                [self.tmpTableView addSubview:snapView];
                
                [UIView animateWithDuration:0.1 animations:^{
                    center.y = location.y;
                    snapView.center = center;
                    snapView.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapView.alpha = 0.5;
                    
                    cell.alpha = 0.0;
                }];
            }
        }
            break;
            
        case UIGestureRecognizerStateChanged:{
            CGPoint center = snapView.center;
            center.y = location.y;
            snapView.center = center;
            
            UITableViewCell *cell = [self.tmpTableView cellForRowAtIndexPath:sourceIndex];
            cell.alpha = 0.0;
            
            if (indexPath && ![indexPath isEqual:sourceIndex]) {
                
                [self.dataArr exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndex.row];
                
                [self.tmpTableView moveRowAtIndexPath:sourceIndex toIndexPath:indexPath];
                
                sourceIndex = indexPath;
            }
            
        }
            break;
            
        default:{
            UITableViewCell *cell = [self.tmpTableView cellForRowAtIndexPath:sourceIndex];
            [UIView animateWithDuration:0.25 animations:^{
                snapView.center = cell.center;
                snapView.transform = CGAffineTransformIdentity;
                snapView.alpha = 0.0;
                
                cell.alpha = 1.0;
            } completion:^(BOOL finished) {
                [snapView removeFromSuperview];
                snapView = nil;
            }];
            sourceIndex = nil;
        }
            break;
    }
}

//截取选中cell
- (UIView *)customViewWithTargetView:(UIView *)target{
    UIGraphicsBeginImageContextWithOptions(target.bounds.size, NO, 0);
    [target.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
