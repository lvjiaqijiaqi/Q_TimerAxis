//
//  Q_TimeLine+CoreDataProperties.m
//  Q_TimerAxis
//
//  Created by jqlv on 2018/3/26.
//  Copyright © 2018年 jqlv. All rights reserved.
//
//

#import "Q_TimeLine+CoreDataProperties.h"
#import "Q_Event+CoreDataClass.h"

@implementation Q_TimeLine (CoreDataProperties)

+ (NSFetchRequest<Q_TimeLine *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Q_TimeLine"];
}

+(void)createFirstTimerLineAtContext:(NSManagedObjectContext *)context InEvent:(Q_Event *)event{
    Q_TimeLine *firstLine = [NSEntityDescription insertNewObjectForEntityForName:@"Q_TimeLine" inManagedObjectContext:context];
    firstLine.createDate = [NSDate date];
    firstLine.progress = 0.f;
    firstLine.event = event;
    firstLine.content = @"创建任务";
}

@dynamic content;
@dynamic createDate;
@dynamic event;
@dynamic progress;

@end
