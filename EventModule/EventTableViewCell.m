//
//  EventTableViewCell.m
//  Q_TimerAxis
//
//  Created by jqlv on 2018/3/27.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "EventTableViewCell.h"
#import "Q_UIConfig.h"

@implementation EventTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.containerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.containerView.layer.shadowOffset = CGSizeMake(2, 2);
    self.containerView.layer.shadowRadius = 2;
    self.containerView.layer.shadowOpacity= 0.2;
    self.containerView.layer.cornerRadius = 4;
    
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    self.titleLabel.textColor = [Q_UIConfig shareInstance].generalCellTitleFontColor;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    
    self.bodyLabel.font = [UIFont systemFontOfSize:16];
    self.bodyLabel.textColor =  [Q_UIConfig shareInstance].generalCellBodyFontColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
