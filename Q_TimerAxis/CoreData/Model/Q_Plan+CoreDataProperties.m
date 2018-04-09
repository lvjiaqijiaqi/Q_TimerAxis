//
//  Q_Plan+CoreDataProperties.m
//  Q_TimerAxis
//
//  Created by jqlv on 2018/4/9.
//  Copyright © 2018年 jqlv. All rights reserved.
//
//

#import "Q_Plan+CoreDataProperties.h"

@implementation Q_Plan (CoreDataProperties)

+ (NSFetchRequest<Q_Plan *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Q_Plan"];
}

@dynamic content;
@dynamic editDate;
@dynamic title;

@end
