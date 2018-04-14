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
+(NSDate *)localDate;
+(NSDate *)transDateFormGMT:(NSDate *)GMTDate;
+(NSInteger)diffSecondForm:(NSDate *)fromDate To:(NSDate *)toDate;
+(NSDate *)dateTimeInterval:(NSTimeInterval)secsToBeAdded sinceDate:(NSDate *)date;
+(NSInteger)diffSecondFormNowDayTo:(NSDate *)toDate;
+(NSString *)intervalFormatStringToDate:(NSInteger)interval;

@end
