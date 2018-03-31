//
//  Q_TimeLine+CoreDataProperties.m
//  Q_TimerAxis
//
//  Created by jqlv on 2018/3/26.
//  Copyright © 2018年 jqlv. All rights reserved.
//
//

#import "Q_TimeLine+CoreDataProperties.h"

@implementation Q_TimeLine (CoreDataProperties)

+ (NSFetchRequest<Q_TimeLine *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Q_TimeLine"];
}

@dynamic content;
@dynamic createDate;
@dynamic event;

@end
