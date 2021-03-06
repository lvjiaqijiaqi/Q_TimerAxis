//
//  Q_navigationController.m
//  Q_TimerAxis
//
//  Created by jqlv on 2018/3/28.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "Q_navigationController.h"
#import "Q_UIConfig.h"

@interface Q_navigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIBarButtonItem *navBackBtn;

@end

@implementation Q_navigationController


-(instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        
    }
    return self;
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

-(UIBarButtonItem *)navBackBtn{
    if(!_navBackBtn){
        _navBackBtn =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MainNavBar_BackIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(Navback)];
    }
    return _navBackBtn;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavBar];
    
    self.delegate = self;
    self.interactivePopGestureRecognizer.delegate = self;
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (navigationController.viewControllers.count > 1) {
        viewController.navigationItem.leftBarButtonItem = self.navBackBtn;
    }
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
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

-(void)Navback{
    if ([self.topViewController respondsToSelector:@selector(Navback)]) {
        [self.topViewController performSelector:@selector(Navback)];
    }
    [self popViewControllerAnimated:YES];
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}
@end
