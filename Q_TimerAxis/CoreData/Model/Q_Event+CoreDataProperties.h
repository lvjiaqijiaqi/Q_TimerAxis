//
//  Q_Event+CoreDataProperties.h
//  Q_TimerAxis
//
//  Created by jqlv on 2018/3/27.
//  Copyright © 2018年 jqlv. All rights reserved.
//
//

#import "Q_Event+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Q_Event (CoreDataProperties)

+ (NSFetchRequest<Q_Event *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *body;
@property (nonatomic) double progress;
@property (nullable, nonatomic, copy) NSDate *deadLine;
@property (nullable, nonatomic, copy) NSDate *lastUpdate;
@property (nullable, nonatomic, copy) NSDate *startDate;
@property (nullable, nonatomic, retain) NSSet<Q_TimeLine *> *timeLine;

@end

@interface Q_Event (CoreDataGeneratedAccessors)

- (void)addTimeLineObject:(Q_TimeLine *)value;
- (void)removeTimeLineObject:(Q_TimeLine *)value;
- (void)addTimeLine:(NSSet<Q_TimeLine *> *)values;
- (void)removeTimeLine:(NSSet<Q_TimeLine *> *)values;

@end

NS_ASSUME_NONNULL_END
