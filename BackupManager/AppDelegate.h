//
//  AppDelegate.h
//  BackupManager
//
//  Created by Daniel Walsh on 6/6/12.
//  Copyright (c) 2012 Walsh walsh Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBRestClient;
@class TableViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    DBRestClient *restClient;
    NSDate *deleteDate;
    TableViewController *tableViewController;
    UINavigationController *navigationController;
    NSString *path;
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) UINavigationController *navigationController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void) listFiles;

@end
