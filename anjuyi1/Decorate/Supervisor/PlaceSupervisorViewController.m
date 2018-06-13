//
//  PlaceSupervisorViewController.m
//  anjuyi1
//
//  Created by 李 on 2018/6/9.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "PlaceSupervisorViewController.h"
#import "SupervisorDetailsVC.h"

@interface PlaceSupervisorViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *placeSupervisor;
@property (weak, nonatomic) IBOutlet UIImageView *signService;

@end

@implementation PlaceSupervisorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self baseForDefaultLeftNavButton];
    [self setTitle:@"请个监理"];
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1.5)]];
    
    [self.placeSupervisor addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectSupervisorService)]];
    [self.signService addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectSignService)]];
}

- (void)selectSupervisorService{
    
    SupervisorDetailsVC *vc = [[SupervisorDetailsVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)selectSignService{
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
