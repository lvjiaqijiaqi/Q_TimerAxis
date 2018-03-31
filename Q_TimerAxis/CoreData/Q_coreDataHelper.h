//
//  Q_coreDataHelper.h
//  Q_diary
//
//  Created by lvjiaqi on 2017/12/17.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface Q_coreDataHelper : NSObject

- (void)saveContext;
+ (Q_coreDataHelper *)shareInstance;
- (NSManagedObjectContext *)managedContext;

@end
