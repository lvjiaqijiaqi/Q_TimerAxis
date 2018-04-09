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

-(UIColor *)mainColor;
-(UIColor *)SupplementaryColor;

-(UIColor *)generalBackgroundColor;
-(UIColor *)generalCellBackgroundColor;
-(UIColor *)generalNavgroundColor;
-(UIColor *)generalButtonSelectedColor;
-(UIColor *)generalButtonNormalColor;

-(UIColor *)generalCellTitleFontColor;
-(UIColor *)generalCellSubTitleFontColor;
-(UIColor *)generalCellBodyFontColor;
-(UIColor *)generalCellSeparatorColor;

-(UIFont *)generalTitleFont;
-(UIFont *)generalSubTitleFont;
-(UIFont *)generalBodyFont;
-(UIFont *)generalHeadLineFont;

-(NSDictionary *)generalEditAttributes;

@end
