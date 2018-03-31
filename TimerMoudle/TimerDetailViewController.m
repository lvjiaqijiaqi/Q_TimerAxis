//
//  TimerDetailViewController.m
//  Q_TimerAxis
//
//  Created by jqlv on 2018/3/28.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "TimerDetailViewController.h"
#import "Q_coreDataHelper.h"

@interface TimerDetailViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *inputViewBtns;

@property (weak, nonatomic) IBOutlet UITextView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *processLabel;

@end

@implementation TimerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"affirmIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(complete)];
    self.contentView.delegate = self;
    [self.inputView removeFromSuperview];
    self.contentView.inputAccessoryView = self.inputView;
    self.navigationItem.title = @"编辑时间轴";
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    /*UISlider *sliderView =  [[UISlider alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 40.f)];
    sliderView.maximumValue = 1;
    sliderView.minimumValue = 0;
    [sliderView addTarget:self action:@selector(updateSliderProcess:) forControlEvents:UIControlEventValueChanged];
    self.contentView.inputAccessoryView = sliderView;
    */
    [self.contentView becomeFirstResponder];
}

-(void)cancel{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)complete{
    Q_TimeLine *timeLine = [NSEntityDescription insertNewObjectForEntityForName:@"Q_TimeLine" inManagedObjectContext:[Q_coreDataHelper shareInstance].managedContext];
    timeLine.event = self.event;
    timeLine.content = self.contentView.text;
    timeLine.createDate = [NSDate date];
    [[Q_coreDataHelper shareInstance] saveContext];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)textViewDidChange:(UITextView *)textView{
    
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    return YES;
}

@end
