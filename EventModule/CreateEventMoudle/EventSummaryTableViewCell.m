//
//  EventSummaryTableViewCell.m
//  Q_TimerAxis
//
//  Created by jqlv on 2018/3/30.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "EventSummaryTableViewCell.h"
#import "Q_UIConfig.h"

@interface EventSummaryTableViewCell()

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *sperateLine;


@end

@implementation EventSummaryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.sperateLine enumerateObjectsUsingBlock:^(UIView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.backgroundColor = [Q_UIConfig shareInstance].generalBackgroundColor;
    }];
    self.title.font = [UIFont boldSystemFontOfSize:14];
    self.title.textColor = [Q_UIConfig shareInstance].generalCellTitleFontColor;
    
    self.content.textColor = [Q_UIConfig shareInstance].generalCellBodyFontColor;
    self.content.font = [UIFont systemFontOfSize:14];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



@end
