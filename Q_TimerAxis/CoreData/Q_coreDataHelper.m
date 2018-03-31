//
//  Q_coreDataHelper.m
//  Q_diary
//
//  Created by lvjiaqi on 2017/12/17.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import "Q_coreDataHelper.h"

@interface Q_coreDataHelper()

//iOS9中 CoreData Stack核心的三个类
//管理模型文件上下文
@property(nonatomic,strong) NSManagedObjectContext *managedObjectContext;
//模型文件
@property(nonatomic,strong) NSManagedObjectModel *managedObjectModel;
//存储调度器
@property(nonatomic,strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;


//iOS10中NSPersistentContainer
/**
 CoreData Stack容器
 内部包含：
 管理对象上下文：NSManagedObjectContext *viewContext;
 对象管理模型：NSManagedObjectModel *managedObjectModel
 存储调度器：NSPersistentStoreCoordinator *persistentStoreCoordinator;
 */
@property(nonatomic,strong)NSPersistentContainer *persistentContainer;

@end

@implementation Q_coreDataHelper

#pragma mark -iOS9 CoreData Stack


+ (Q_coreDataHelper *)shareInstance
{
    static Q_coreDataHelper *coreDataHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        coreDataHelper = [[Q_coreDataHelper alloc] init];
    });
    return coreDataHelper;
}


//获取沙盒路径URL
-(NSURL*)getDocumentsUrl{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
}


//懒加载managedObjectModel
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    //    //根据某个模型文件路径创建模型文件
    //  _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[[NSBundle mainBundle]URLForResource:@"Person" withExtension:@"momd"]];
    
    //合并Bundle所有.momd文件
    //budles: 指定为nil,自动从mainBundle里找所有.momd文件
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return _managedObjectModel;
    
}

//懒加载persistentStoreCoordinator
-(NSPersistentStoreCoordinator*)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    //根据模型文件创建存储调度器
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    /**
     *  给存储调度器添加存储器
     *
     *  tyep:存储类型
     *  configuration：配置信息 一般为nil
     *  options：属性信息  一般为nil
     *  URL：存储文件路径
     */
    
    NSURL *url = [[self getDocumentsUrl] URLByAppendingPathComponent:@"person.db" isDirectory:YES];
    [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:nil];
    
    NSLog(@"%@",_persistentStoreCoordinator.persistentStores[0].URL);
    
    return _persistentStoreCoordinator;
    
}

//懒加载managedObjectContext
-(NSManagedObjectContext*)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    //参数表示线程类型  NSPrivateQueueConcurrencyType比NSMainQueueConcurrencyType略有延迟
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    //设置存储调度器
    [_managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    
    return _managedObjectContext;
}

#pragma mark -iOS10 CoreData Stack

//懒加载NSPersistentContainer
- (NSPersistentContainer *)persistentContainer
{
    if(_persistentContainer != nil)
    {
        return _persistentContainer;
    }
    
    //1.创建对象管理模型
    //    //根据某个模型文件路径创建模型文件
    //    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:[[NSBundle mainBundle]URLForResource:@"Person" withExtension:@"momd"]];
    
    
    //合并Bundle所有.momd文件
    //budles: 指定为nil,自动从mainBundle里找所有.momd文件
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    
    
    //2.创建NSPersistentContainer
    /**
     * name:数据库文件名称
     */
    _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"sql.db" managedObjectModel:model];
    
    //3.加载存储器
    [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription * description, NSError * error) {
        NSLog(@"%@",description);
        NSLog(@"%@",error);
    }];
    
    return _persistentContainer;
}

#pragma mark - NSManagedObjectContext

//重写get方法
- (NSManagedObjectContext *)managedContext{
    //获取系统版本
    float systemNum = [[UIDevice currentDevice].systemVersion floatValue];
    //根据系统版本返回不同的NSManagedObjectContext
    if(systemNum < 10.0){
        return self.managedObjectContext;
    }else{
        return self.persistentContainer.viewContext;
    }
}

- (NSPersistentContainer *)getCurrentPersistentContainer{
    //获取系统版本
    float systemNum = [[UIDevice currentDevice].systemVersion floatValue];
    if(systemNum < 10.0){
        return nil;
    }else{
        return self.persistentContainer;
    }
}

- (void)saveContext{
    NSManagedObjectContext *context = self.managedContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}




@end
