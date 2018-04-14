//
//  NSDate+Extension.m
//  Q_TimerAxis
//
//  Created by jqlv on 2018/3/27.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

+(NSString *)dateToString:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [dateFormatter stringFromDate:date];
}

-(BOOL)laterThanDate:(NSDate *)date{
    NSInteger interval = [self timeIntervalSinceDate:date];
    if (interval > 0) {
        return YES;
    }
    return NO;
}

+(NSString *)intervalFormatStringToDate:(NSInteger)interval{
    BOOL reverse = interval > 0 ? NO : YES;
    interval = interval > 0 ? interval : -interval;
    NSInteger day = interval / (60 * 60 * 24);
    NSInteger hour = (interval % (60 * 60 * 24)) / (60 * 60);
    NSInteger min = (interval % (60 * 60 * 24)) % (60 * 60) / 60;
    if (reverse) {
        return [NSString stringWithFormat:@"- %ld日 %ld时 %ld分",day,hour,min];
    }
    return [NSString stringWithFormat:@"%ld日 %ld时 %ld分",day,hour,min];
}


+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedDescending){
        return 1;
    }else if (result == NSOrderedAscending){
        return -1;
    }else{
        return 0;
    }
}

+(NSDate *)localDate{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSTimeInterval interval = [zone secondsFromGMTForDate:date];
    NSDate *current = [date dateByAddingTimeInterval:interval];
    return current;
}
+(NSDate *)transDateFormGMT:(NSDate *)GMTDate{
    NSDate *date = GMTDate;
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSTimeInterval interval = [zone secondsFromGMTForDate:date];
    NSDate *current = [date dateByAddingTimeInterval:interval];
    return current;
}
+(NSInteger)diffSecondForm:(NSDate *)fromDate To:(NSDate *)toDate{
    return  [toDate timeIntervalSinceDate:fromDate];
}
+(NSInteger)diffSecondFormNowDayTo:(NSDate *)toDate{
    return  [toDate timeIntervalSinceDate:[NSDate localDate]];
}
+(NSDate *)dateTimeInterval:(NSTimeInterval)secsToBeAdded sinceDate:(NSDate *)date{
    return [NSDate dateWithTimeInterval:secsToBeAdded sinceDate:date];
}

@end
