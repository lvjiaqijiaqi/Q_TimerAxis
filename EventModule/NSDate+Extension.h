//
//  NSDate+Extension.h
//  Q_TimerAxis
//
//  Created by jqlv on 2018/3/27.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)

+(NSString *)dateToString:(NSDate *)date;
-(BOOL)laterThanDate:(NSDate *)date;
+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;

@end
