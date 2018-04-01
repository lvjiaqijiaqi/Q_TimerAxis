//
//  Q_UIConfig.h
//  Q_TimerAxis
//
//  Created by jqlv on 2018/4/1.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Q_UIConfig : NSObject

+(instancetype)shareInstance;

-(UIColor *)generalBackgroundColor;
-(UIColor *)generalCellBackgroundColor;
-(UIColor *)generalNavgroundColor;
-(UIColor *)generalCellBodyFontColor;
-(UIColor *)generalCellTitleFontColor;
-(UIColor *)generalButtonSelectedColor;
-(UIColor *)generalButtonNormalColor;
@end
