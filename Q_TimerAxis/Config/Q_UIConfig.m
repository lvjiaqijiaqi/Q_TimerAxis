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

-(NSArray<NSDictionary *> *)topicColors{
    static NSArray<NSDictionary *> *colors;
    colors = @[@{@"name":@"天蓝色",@"color":[UIColor colorWithR:152 G:204 B:255]},
               @{@"name":@"青绿色",@"color":[UIColor colorWithR:0 G:174 B:157]},
               @{@"name":@"珊瑚粉",@"color":[UIColor colorWithR:248 G:171 B:166]},
               @{@"name":@"蜜柑橙",@"color":[UIColor colorWithR:245 G:130 B:32]},
               @{@"name":@"菖蒲紫",@"color":[UIColor colorWithR:105 G:77 B:159]},
               @{@"name":@"黒橡",@"color":[UIColor colorWithR:62 G:65 B:69]}];
    return colors;
}

-(UIColor *)defaultColor:(NSString *)colorStr{
    static NSDictionary *colors;
    NSUInteger topicIdx = 0;
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"topicIdx"]) {
        topicIdx = [[NSUserDefaults standardUserDefaults] integerForKey:@"topicIdx"];
    }
    colors = @{
               @"Main": self.topicColors[topicIdx][@"color"],
               @"Supplementary": [UIColor colorWithR:255 G:182 B:185],
               @"Grounding": [UIColor colorWithR:245 G:245 B:245],
               @"Black": [UIColor colorWithR:0 G:0 B:0],
               @"Half-Black": [UIColor colorWithR:128 G:128 B:128],
               @"Tiny-Black": [UIColor colorWithR:245 G:245 B:245],
               @"Weak-Black": [UIColor colorWithR:192 G:192 B:192],
               @"Strong-Black": [UIColor colorWithR:64 G:64 B:64],
               @"White": [UIColor colorWithR:256 G:256 B:256],
               };
    /*colors = @{
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
               @"generalBackgroundColor" : [UIColor colorWithR:245 G:245 B:245],//天蓝色
               @"#B3E5FC" : [UIColor colorWithR:179 G:229 B:252],
               @"generalCellBackgroundColor" : [UIColor colorWithR:179 G:229 B:252],//天蓝色
               @"#1E90FF" : [UIColor colorWithR:30 G:144 B:255],
               @"generalNavgroundColor" : [UIColor colorWithR:152 G:204 B:255],
               @"generalCellTitleColor" : [UIColor colorWithR:0 G:0 B:0],
               @"generalCellBodyColor" : [UIColor colorWithR:128 G:128 B:128],
               @"generalCellSubTitleFontColor" : [UIColor colorWithR:169 G:169 B:169],
               @"generalNavTitleFontColor" : [UIColor whiteColor],
               @"generalButtonNormalColor" : [UIColor colorWithR:0 G:191 B:255],
               @"generalButtonSelectedColor" : [UIColor colorWithR:255 G:105 B:180],
               };*/
    return colors[colorStr];
}

-(UIColor *)mainColor{
    return [self defaultColor:@"Main"];
}
-(UIColor *)SupplementaryColor{
    return [self defaultColor:@"Supplementary"];
}

-(UIColor *)generalButtonSelectedColor{
    return [self defaultColor:@"Supplementary"];
}
-(UIColor *)generalButtonNormalColor{
    return [self defaultColor:@"Main"];
}
-(UIColor *)generalNavTitleFontColor{
    return [self defaultColor:@"White"];
}

-(UIColor *)generalNavgroundColor{
    return [self defaultColor:@"Main"];
}
-(UIColor *)generalCellBackgroundColor{
    return [self defaultColor:@"Main"];
}
-(UIColor *)generalBackgroundColor{
    return [self defaultColor:@"Tiny-Black"];
}

-(UIColor *)generalCellTitleFontColor{
    return [self defaultColor:@"Main"];
}
-(UIColor *)generalCellSubTitleFontColor{
    return [self defaultColor:@"Half-Black"];
}
-(UIColor *)generalCellSeparatorColor{
    return [self defaultColor:@"Weak-Black"];
}
-(UIColor *)generalCellBodyFontColor{
    return [self defaultColor:@"Strong-Black"];
}
-(UIColor *)generalNavFontColor{
    return [self defaultColor:@"White"];
}

-(UIFont *)generalTitleFont{
    return [UIFont boldSystemFontOfSize:16];
}
-(UIFont *)generalSubTitleFont{
    return [UIFont boldSystemFontOfSize:14];
}
-(UIFont *)generalBodyFont{
    return [UIFont systemFontOfSize:16];
}
-(UIFont *)generalHeadLineFont{
    return [UIFont boldSystemFontOfSize:20];
}
-(UIFont *)generalNavFont{
    return [UIFont boldSystemFontOfSize:18];
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
