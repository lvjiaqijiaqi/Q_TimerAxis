//
//  EventCreateContentViewController.m
//  Q_TimerAxis
//
//  Created by jqlv on 2018/3/30.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "EventCreateContentViewController.h"
#import "Q_UIConfig.h"
#import "UIAlertController+Q_Alert.h"

@interface EventCreateContentViewController ()

@property(nonatomic,strong) UITextView *textView;

@end

@implementation EventCreateContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"计划内容";
    self.view.backgroundColor = [Q_UIConfig shareInstance].generalBackgroundColor;
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.view.frame) , 200)];
    textView.contentInset = UIEdgeInsetsMake(5, 5, 0, 0);
    textView.backgroundColor = [UIColor whiteColor];
    textView.font = [UIFont systemFontOfSize:14];
    self.textView = textView;
    
    self.textView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.textView.layer.shadowOffset = CGSizeMake(0, 0);
    self.textView.layer.shadowRadius = 1;
    self.textView.layer.shadowOpacity= 0.4;
    self.textView.clipsToBounds = NO;
    
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
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if (self.textView.text.length == 0) {
        UIAlertController *alert = [UIAlertController createAlertWithTitle:@"错误" massage:@"内容不能为空" ok:^{
            
        }];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    return YES;
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
