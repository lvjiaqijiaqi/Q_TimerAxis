//
//  Q_TimeLine+CoreDataProperties.h
//  Q_TimerAxis
//
//  Created by jqlv on 2018/3/26.
//  Copyright © 2018年 jqlv. All rights reserved.
//
//

#import "Q_TimeLine+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Q_TimeLine (CoreDataProperties)

+ (NSFetchRequest<Q_TimeLine *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSDate *createDate;
@property (nullable, nonatomic, retain) Q_Event *event;

@end

NS_ASSUME_NONNULL_END
