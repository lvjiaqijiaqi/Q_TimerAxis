//
//  HomeTitleTableViewCell.m
//  Q_TimerAxis
//
//  Created by jqlv on 2018/4/11.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "HomeTitleTableViewCell.h"
#import "Q_UIConfig.h"

@implementation HomeTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.textColor = [Q_UIConfig shareInstance].generalNavFontColor;
    self.titleLabel.font = [Q_UIConfig shareInstance].generalTitleFont;
    
    self.subLeftLabel.font = [Q_UIConfig shareInstance].generalSubTitleFont;
    self.subRightLabel.font = [Q_UIConfig shareInstance].generalSubTitleFont;
    self.subLeftLabel.textColor = [Q_UIConfig shareInstance].generalCellSubTitleFontColor;
    self.subRightLabel.textColor = [Q_UIConfig shareInstance].generalCellSubTitleFontColor;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
