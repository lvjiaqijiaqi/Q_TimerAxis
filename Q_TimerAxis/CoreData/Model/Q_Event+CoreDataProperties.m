//
//  Q_Event+CoreDataProperties.m
//  Q_TimerAxis
//
//  Created by jqlv on 2018/3/27.
//  Copyright © 2018年 jqlv. All rights reserved.
//
//

#import "Q_Event+CoreDataProperties.h"

@implementation Q_Event (CoreDataProperties)

+ (NSFetchRequest<Q_Event *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Q_Event"];
}

@dynamic title;
@dynamic body;
@dynamic progress;
@dynamic deadLine;
@dynamic lastUpdate;
@dynamic timeLine;
@dynamic startDate;

@end
