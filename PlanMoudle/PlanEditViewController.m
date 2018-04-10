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
    self.textView.layer.shadowOpacity = 0.4;
    self.textView.clipsToBounds = NO;
    
    [self.view addSubview:textView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MainNavBar_ConfirmIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(editSuccess:)];
    
}

-(void)editSuccess:(id)sender{
    if (self.editSuccess) {
        self.editModel.title = self.textView.text;
        [self.navigationController popViewControllerAnimated:YES];
        self.editSuccess(self.editModel,self.indexPath);
    }
}


@end
