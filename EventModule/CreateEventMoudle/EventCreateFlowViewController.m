//
//  EventCreateFlowViewController.m
//  Q_TimerAxis
//
//  Created by jqlv on 2018/3/30.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "EventCreateFlowViewController.h"
#import "EventCreateStepViewController.h"
#import "Q_coreDataHelper.h"
#import "Q_Event+CoreDataClass.h"
#import "Q_TimeLine+CoreDataClass.h"
#import "Q_UIConfig.h"

@interface EventCreateFlowViewController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIBarButtonItem *navBackBtn;

@end

@implementation EventCreateFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavBar];
    self.delegate = self;
    self.model = [[EventModel alloc] init];
    self.interactivePopGestureRecognizer.delegate = self;
}

-(UIBarButtonItem *)navBackBtn{
    if(!_navBackBtn){
        _navBackBtn =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MainNavBar_BackIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(Navback)];
    }
    return _navBackBtn;
}

-(void)configNavBar{
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    self.navigationBar.translucent = NO;
    self.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],
                                               NSKernAttributeName:[NSNumber numberWithInteger:2],
                                               NSForegroundColorAttributeName:[UIColor whiteColor]
                                               };
    self.navigationBar.barTintColor = [Q_UIConfig shareInstance].generalNavgroundColor;
    self.navigationBar.tintColor = [UIColor whiteColor];
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(EventCreateStepViewController *)viewController animated:(BOOL)animated{
    
    if (navigationController.viewControllers.count > 1) {
        viewController.navigationItem.leftBarButtonItem = self.navBackBtn;
    }else{
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MainNavBar_BackIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(BackEdit)];
    }
    viewController.model = self.model;
    [viewController updateViewFromModel];
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(EventCreateStepViewController *)viewController animated:(BOOL)animated{
    if (navigationController.viewControllers.count <= 1) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }else{
        self.interactivePopGestureRecognizer.enabled = YES;
    }
}
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        //self.interactivePopGestureRecognizer.enabled = YES;
    }
    [super pushViewController:viewController animated:animated];
}

-(void)BackEdit{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)Navback{
    [self popViewControllerAnimated:YES];
}
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}
-(void)completeEventCreate{
    Q_Event *event = [NSEntityDescription insertNewObjectForEntityForName:@"Q_Event" inManagedObjectContext:[Q_coreDataHelper shareInstance].managedContext];
    event.title = self.model.title;
    event.startDate = self.model.startDate;
    event.lastUpdate = self.model.startDate;
    event.deadLine = self.model.endDate;
    event.body = self.model.content;
    [Q_TimeLine createFirstTimerLineAtContext:[Q_coreDataHelper shareInstance].managedContext InEvent:event];
    [[Q_coreDataHelper shareInstance] saveContext];
    [self BackEdit];
}
-(UIViewController *)popViewControllerAnimated:(BOOL)animated{
    EventCreateStepViewController *preVC = (EventCreateStepViewController *)[self visibleViewController];
    [preVC storeModelFromView];
    return [super popViewControllerAnimated:animated];
}
@end
