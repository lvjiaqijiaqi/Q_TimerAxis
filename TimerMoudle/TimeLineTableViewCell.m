//
//  TimeLineTableViewCell.m
//  Q_TimerAxis
//
//  Created by jqlv on 2018/3/27.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "TimeLineTableViewCell.h"
#import "Q_UIConfig.h"

@implementation TimeLineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentTextView.contentInset = UIEdgeInsetsZero;
    self.contentTextView.textColor = [Q_UIConfig shareInstance].generalCellBodyFontColor;
    self.lastUpdateLabel.textColor = [Q_UIConfig shareInstance].generalCellSubTitleFontColor;
    self.timeIconView.backgroundColor = [Q_UIConfig shareInstance].generalNavgroundColor;
    self.timeIconView.layer.cornerRadius = 8;
    
    self.processLabel.textColor = [Q_UIConfig shareInstance].SupplementaryColor;
    self.processLabel.font = [Q_UIConfig shareInstance].generalHeadLineFont;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
