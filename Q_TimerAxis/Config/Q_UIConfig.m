//
//  Q_UIConfig.m
//  Q_TimerAxis
//
//  Created by jqlv on 2018/4/1.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "Q_UIConfig.h"
#import "UIColor+Extension.h"

const static NSDictionary *colors;

static Q_UIConfig *defaultConfig = nil;

@implementation Q_UIConfig

+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (defaultConfig == nil) {
            defaultConfig = [[self alloc] init];
        }
    });
    return defaultConfig;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (defaultConfig == nil) {
            defaultConfig = [super allocWithZone:zone];
        }
    });
    return defaultConfig;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
-(id)copy{
    return self;
}

-(UIColor *)defaultColor:(NSString *)colorStr{
    colors = @{
               @"#000000" : [UIColor colorWithR:0 G:0 B:0],
               @"Black" : [UIColor colorWithR:0 G:0 B:0],//纯黑
               @"#FFFFFF" : [UIColor colorWithR:255 G:255 B:255],
               @"White" : [UIColor colorWithR:255 G:255 B:255],//纯白
               @"#FF0000" : [UIColor colorWithR:255 G:0 B:0],
               @"Red" : [UIColor colorWithR:255 G:0 B:0],//纯红
               @"#F08080" : [UIColor colorWithR:240 G:128 B:128],
               @"LightCoral" : [UIColor colorWithR:240 G:128 B:128],//淡珊瑚色
               @"#FFFF00" : [UIColor colorWithR:255 G:255 B:0],
               @"Yellow" : [UIColor colorWithR:255 G:255 B:0],//纯黄
               @"#008000" : [UIColor colorWithR:0 G:128 B:0],
               @"Green" : [UIColor colorWithR:0 G:128 B:0],//纯绿
               @"#98FB98" : [UIColor colorWithR:152 G:251 B:152],
               @"PaleGreen" : [UIColor colorWithR:152 G:251 B:152],//苍白的绿色
               @"#0000FF" : [UIColor colorWithR:0 G:0 B:255],
               @"Blue" : [UIColor colorWithR:0 G:0 B:255],//纯蓝
               @"#808080" : [UIColor colorWithR:128 G:128 B:128],
               @"Gray" : [UIColor colorWithR:128 G:128 B:128],//灰色
               @"#7FFFAA" : [UIColor colorWithR:127 G:255 B:170],
               @"Auqamarin" : [UIColor colorWithR:127 G:255 B:170],//绿玉\碧绿色
               @"#87CEEB" : [UIColor colorWithR:135 G:206 B:235],
               @"SkyBlue" : [UIColor colorWithR:135 G:206 B:235],//天蓝色
               @"#f4f4f4" : [UIColor colorWithR:225 G:245 B:254],
               @"generalBackgroundColor" : [UIColor colorWithR:240 G:255 B:255],//天蓝色
               @"#B3E5FC" : [UIColor colorWithR:179 G:229 B:252],
               @"generalCellBackgroundColor" : [UIColor colorWithR:179 G:229 B:252],//天蓝色
               @"#1E90FF" : [UIColor colorWithR:30 G:144 B:255],
               @"generalNavgroundColor" : [UIColor colorWithR:0 G:191 B:255],
               @"generalCellTitleColor" : [UIColor colorWithR:0 G:191 B:255],
               @"generalCellBodyColor" : [UIColor colorWithR:128 G:128 B:128],
               @"generalCellSubTitleFont" : [UIColor colorWithR:169 G:169 B:169],
               @"generalNavTitleFontColor" : [UIColor whiteColor],
               @"generalButtonNormalColor" : [UIColor colorWithR:0 G:191 B:255],
               @"generalButtonSelectedColor" : [UIColor colorWithR:255 G:105 B:180],
               };
    return colors[colorStr];
}
-(UIColor *)generalButtonSelectedColor{
    return [self defaultColor:@"generalButtonSelectedColor"];
}
-(UIColor *)generalButtonNormalColor{
    return [self defaultColor:@"generalButtonNormalColor"];
}
-(UIColor *)generalNavTitleFontColor{
    return [self defaultColor:@"generalNavTitleFontColor"];
}
-(UIColor *)generalCellSubTitleFont{
    return [self defaultColor:@"generalCellSubTitleFont"];
}
-(UIColor *)generalCellBodyFontColor{
    return [self defaultColor:@"generalCellBodyColor"];
}
-(UIColor *)generalCellTitleFontColor{
    return [self defaultColor:@"generalCellTitleColor"];
}
-(UIColor *)generalNavgroundColor{
    return [self defaultColor:@"generalNavgroundColor"];
}
-(UIColor *)generalCellBackgroundColor{
    return [self defaultColor:@"generalCellBackgroundColor"];
}
-(UIColor *)generalBackgroundColor{
    return [self defaultColor:@"generalBackgroundColor"];
}
-(UIFont *)generalTitleFont{
    return [UIFont boldSystemFontOfSize:16];
}
-(UIFont *)generalFont{
    return [UIFont boldSystemFontOfSize:14];
}
-(NSDictionary *)generalEditAttributes{
    static NSDictionary *attributes;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
        pStyle.alignment = NSTextAlignmentLeft;
        pStyle.lineSpacing = 2;
        pStyle.paragraphSpacing = 5;
        attributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:15],
                       NSForegroundColorAttributeName : self.generalCellBodyFontColor,
                       NSParagraphStyleAttributeName : pStyle
                       };
    });
    return attributes;
}
@end
