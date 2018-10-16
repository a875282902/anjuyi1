//
//  SearchPromptTableViewController.m
//  anjuyi1
//
//  Created by apple on 2018/9/27.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "SearchPromptTableViewController.h"
#import "SearchResultsViewController.h"

@interface SearchPromptTableViewController ()

@property (nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation SearchPromptTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;\
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];
    
    [self.tableView setTableFooterView:[UIView new]];
}

- (void)setKeyWord:(NSString *)keyWord{
    
    _keyWord = keyWord;
    NSString *path = [NSString stringWithFormat:@"%@/search/keyword_result",KURL];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:@{@"keyword":keyWord} success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                weakSelf.dataArr = [NSMutableArray arrayWithArray:responseObject[@"datas"]];
            }
            [weakSelf.tableView reloadData];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count+3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
   
    if (indexPath.row<3) {
        NSString *str = @[[NSString stringWithFormat:@"在「图片」中搜索%@",self.keyWord],[NSString stringWithFormat:@"在「整屋」中搜索%@",self.keyWord],[NSString stringWithFormat:@"在「用户」中搜索%@",self.keyWord]][indexPath.row];
        
        NSMutableAttributedString *attS = [[NSMutableAttributedString alloc] initWithString:str];
        [attS setAttributes:@{NSForegroundColorAttributeName:GCOLOR} range:NSMakeRange(8, str.length-8)];
        [cell.textLabel setAttributedText:attS];
    }
    else{
        [cell.imageView setImage:[UIImage imageNamed:@"search"]];
        // Configure the cell...
        [cell.textLabel setText:self.dataArr[indexPath.row-3][@"suggestion"]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *str;
    NSInteger type = 0;
    if (indexPath.row<3) {
        str = self.keyWord;
        type = indexPath.row;
    }
    else{
        
        str = self.dataArr[indexPath.row-3][@"suggestion"];
        
    }
    
    NSMutableArray *searchArr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:SEARCHARR]];
    
    BOOL isbool = [searchArr containsObject:str];
    if (!isbool) {
        [searchArr addObject:str];
        [[NSUserDefaults standardUserDefaults] setValue:searchArr forKey:SEARCHARR];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [self.view setHidden:YES];
    SearchResultsViewController *vc = [[SearchResultsViewController alloc] init];
    vc.keyword = str;
    vc.type =type;
    [self.navigationController pushViewController:vc animated:YES];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
