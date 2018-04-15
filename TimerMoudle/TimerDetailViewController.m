//
//  TimerDetailViewController.m
//  Q_TimerAxis
//
//  Created by jqlv on 2018/3/28.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "TimerDetailViewController.h"
#import "Q_coreDataHelper.h"
#import "Q_UIConfig.h"

@interface TimerDetailViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *inputView;

@property (weak, nonatomic) IBOutlet UITextView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *processLabel;
@property (weak, nonatomic) IBOutlet UISlider *processSlider;

@end

@implementation TimerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MainNavBar_IssueIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(complete)];
    self.contentView.delegate = self;
    [self.inputView removeFromSuperview];
    self.contentView.inputAccessoryView = self.inputView;
    self.contentView.font = [Q_UIConfig shareInstance].generalBodyFont;
    self.contentView.typingAttributes = [Q_UIConfig shareInstance].generalEditAttributes;
    self.navigationItem.title = @"编辑时间线";
    
    self.processLabel.textColor = [Q_UIConfig shareInstance].generalCellTitleFontColor;
    self.processLabel.font = [Q_UIConfig shareInstance].generalTitleFont;
    self.processLabel.text = @"0%";

    self.processSlider.maximumTrackTintColor = [Q_UIConfig shareInstance].generalButtonNormalColor;
    self.processSlider.minimumTrackTintColor = [Q_UIConfig shareInstance].generalButtonSelectedColor;
    [self.processSlider addTarget:self action:@selector(eventProcessChange:) forControlEvents:UIControlEventValueChanged];// 针对值变化添加响应方法
    
     [self initDefaultConfigration];
    
}
-(void)initDefaultConfigration{
    self.processSlider.value = self.event.progress;
    self.processLabel.text = [NSString stringWithFormat:@"%.0f%%",self.event.progress * 100];
    if (self.timeLine) {
        self.contentView.text = self.timeLine.content;
    }
}
-(void)viewWillAppear:(BOOL)animated{
    self.processSlider.minimumValue = self.event.progress;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.contentView becomeFirstResponder];
}

- (void)eventProcessChange:(id)sender {
    UISlider *slider = (UISlider *)sender;
    self.processLabel.text = [NSString stringWithFormat:@"%.0f%%", slider.value * 100];
}
-(void)cancel{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)complete{
    if (self.timeLine) {
        self.timeLine.progress = self.processSlider.value;
        self.timeLine.content = self.contentView.text;
        
        self.event.lastUpdate = [NSDate date];
        self.event.progress = self.timeLine.progress;
        
    }else{
        Q_TimeLine *timeLine = [NSEntityDescription insertNewObjectForEntityForName:@"Q_TimeLine" inManagedObjectContext:[Q_coreDataHelper shareInstance].managedContext];
        timeLine.progress = self.processSlider.value;
        timeLine.event = self.event;
        timeLine.content = self.contentView.text;
        timeLine.createDate = [NSDate date];
        
        self.event.lastUpdate = timeLine.createDate;
        self.event.progress = timeLine.progress;
        
        [[Q_coreDataHelper shareInstance] saveContext];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}



@end
