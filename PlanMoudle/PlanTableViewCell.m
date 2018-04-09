//
//  PlanTableViewCell.m
//  Q_TimerAxis
//
//  Created by jqlv on 2018/4/9.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "PlanTableViewCell.h"
#import "Q_UIConfig.h"

@implementation PlanTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.textLabel.font = [Q_UIConfig shareInstance].generalTitleFont;
    self.textLabel.textColor = [Q_UIConfig shareInstance].generalCellTitleFontColor;
    
    self.detailTextLabel.font = [Q_UIConfig shareInstance].generalSubTitleFont;
    self.detailTextLabel.textColor = [Q_UIConfig shareInstance].generalCellSubTitleFontColor ;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
