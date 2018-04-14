//
//  EventTitleViewController.m
//  Q_TimerAxis
//
//  Created by jqlv on 2018/3/30.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "EventTitleViewController.h"
#import "Q_UIConfig.h"
#import "UIAlertController+Q_Alert.h"
@interface EventTitleViewController ()

@property(nonatomic,strong) UITextField *textField;

@end

@implementation EventTitleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"任务名称";
    self.view.backgroundColor = [Q_UIConfig shareInstance].generalBackgroundColor;
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.view.frame), 44)];
    textField.borderStyle = UITextBorderStyleNone;
    textField.enabled = YES;
    textField.placeholder = @"请填写任务名称";
    textField.backgroundColor = [UIColor whiteColor];
    textField.font = [UIFont systemFontOfSize:14];
    self.textField = textField;
    
    self.textField.layer.shadowColor = [UIColor blackColor].CGColor;
    self.textField.layer.shadowOffset = CGSizeMake(0, 0);
    self.textField.layer.shadowRadius = 1;
    self.textField.layer.shadowOpacity= 0.4;
    
    [self.view addSubview:textField];
}

-(void)updateViewFromModel{
    [super updateViewFromModel];
    if (self.model.title) {
        self.textField.text = self.model.title;
    }
}
-(void)storeModelFromView{
    [super storeModelFromView];
    if (self.textField.text) {
        self.model.title = self.textField.text;
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.textField becomeFirstResponder];
}
-(void)viewDidDisappear:(BOOL)animated{
    [self.textField resignFirstResponder];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.model.title = self.textField.text;
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if (self.textField.text.length == 0) {
        UIAlertController *alert = [UIAlertController createAlertWithTitle:@"提示" massage:@"任务标题不能为空" ok:^{
            
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
