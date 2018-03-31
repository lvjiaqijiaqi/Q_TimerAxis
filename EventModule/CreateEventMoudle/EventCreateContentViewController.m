//
//  EventCreateContentViewController.m
//  Q_TimerAxis
//
//  Created by jqlv on 2018/3/30.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "EventCreateContentViewController.h"

@interface EventCreateContentViewController ()

@property(nonatomic,strong) UITextView *textView;

@end

@implementation EventCreateContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"计划内容";
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 20, CGRectGetWidth(self.view.frame) - 20, 44)];
    textView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    self.textView = textView;
    [self.view addSubview:textView];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.textView becomeFirstResponder];
}
-(void)viewDidDisappear:(BOOL)animated{
    [self.textView resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.model.content = self.textView.text;
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
