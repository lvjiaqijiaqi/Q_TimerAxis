//
//  EventTableViewCell.m
//  Q_TimerAxis
//
//  Created by jqlv on 2018/3/27.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "EventTableViewCell.h"
#import "Q_UIConfig.h"

@interface EventTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *lastUpdateTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateTitleLabel;


@end

@implementation EventTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.containerView.layer.shadowColor = [Q_UIConfig shareInstance].generalCellSeparatorColor.CGColor;
    self.containerView.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    self.containerView.layer.shadowRadius = 1;
    self.containerView.layer.shadowOpacity= 0.4;
    self.containerView.layer.cornerRadius = 4;
    
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    self.titleLabel.textColor = [Q_UIConfig shareInstance].generalCellTitleFontColor;
    self.titleLabel.font = [Q_UIConfig shareInstance].generalHeadLineFont;
    
    self.bodyLabel.font = [Q_UIConfig shareInstance].generalBodyFont;
    self.bodyLabel.textColor =  [Q_UIConfig shareInstance].generalCellBodyFontColor;
    
    self.lastUpdateDateLabel.textColor = [Q_UIConfig shareInstance].generalCellSubTitleFontColor;
    self.lastUpdateDateLabel.font = [Q_UIConfig shareInstance].generalSubTitleFont;
    self.lastUpdateTitleLabel.textColor = [Q_UIConfig shareInstance].generalCellSubTitleFontColor;
    self.lastUpdateTitleLabel.font = [Q_UIConfig shareInstance].generalSubTitleFont;
    self.startDateLabel.textColor = [Q_UIConfig shareInstance].generalCellSubTitleFontColor;
    self.startDateLabel.font = [Q_UIConfig shareInstance].generalSubTitleFont;
    self.startDateTitleLabel.textColor = [Q_UIConfig shareInstance].generalCellSubTitleFontColor;
    self.startDateTitleLabel.font = [Q_UIConfig shareInstance].generalSubTitleFont;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
