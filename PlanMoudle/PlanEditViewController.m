//
//  PlanEditViewController.m
//  Q_TimerAxis
//
//  Created by lvjiaqi on 2018/4/6.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "PlanEditViewController.h"
#import "Q_UIConfig.h"

@interface PlanEditViewController ()

@property(nonatomic,strong) UITextView *textView;

@end

@implementation PlanEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"计划内容";
    self.view.backgroundColor = [Q_UIConfig shareInstance].generalBackgroundColor;
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.view.frame) , 200)];
    textView.contentInset = UIEdgeInsetsMake(5, 5, 0, 0);
    textView.backgroundColor = [UIColor whiteColor];
    textView.font = [UIFont systemFontOfSize:14];
    self.textView = textView;
    self.textView.text = self.editModel.title;
    self.textView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.textView.layer.shadowOffset = CGSizeMake(0, 0);
    self.textView.layer.shadowRadius = 1;
    self.textView.layer.shadowOpacity= 0.4;
    self.textView.clipsToBounds = NO;
    
    [self.view addSubview:textView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(editSuccess:)];
    // Do any additional setup after loading the view.
}

-(void)editSuccess:(id)sender{
    if (self.editSuccess) {
        self.editModel.title = self.textView.text;
        [self.navigationController popViewControllerAnimated:YES];
        self.editSuccess(self.editModel,self.indexPath);
    }
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
