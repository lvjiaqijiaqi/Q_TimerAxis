//
//  Q_Plan+CoreDataProperties.h
//  Q_TimerAxis
//
//  Created by jqlv on 2018/4/10.
//  Copyright © 2018年 jqlv. All rights reserved.
//
//

#import "Q_Plan+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Q_Plan (CoreDataProperties)

+ (NSFetchRequest<Q_Plan *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSDate *editDate;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *tmpContent;
@property (nonatomic) BOOL isEditing;

@end

NS_ASSUME_NONNULL_END
