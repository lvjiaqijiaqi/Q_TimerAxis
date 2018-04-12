//
//  HomeTitleTableViewCell.h
//  Q_TimerAxis
//
//  Created by jqlv on 2018/4/11.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTitleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headPortrait;
@property (weak, nonatomic) IBOutlet UITextField *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *subRightLabel;
@property (weak, nonatomic) IBOutlet UIView *seprateLine;

@end
