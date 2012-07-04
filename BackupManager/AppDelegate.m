//
//  AppDelegate.m
//  BackupManager
//
//  Created by Daniel Walsh on 6/6/12.
//  Copyright (c) 2012 Walsh walsh Studio. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "TableViewController.h"
#import <DropboxSDK/DropboxSDK.h>

@implementation AppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    path = @"/";
    // Override point for customization after application launch.
    //self.window.backgroundColor = [UIColor whiteColor];
    //self.window.rootViewController = [[ViewController alloc] initWithNibName:nil bundle:nil];    
    //self.window.rootViewController = [[TableViewController alloc] initWithNibName:nil bundle:nil];
    
    tableViewController = [[TableViewController alloc]
                                                initWithStyle:UITableViewStylePlain];  
    //self.window.rootViewController = tableViewController;
    NSManagedObjectContext *context = [self managedObjectContext];
    if (!context) {
        // Handle the error.
    }
    // Pass the managed object context to the view controller. 
    tableViewController.managedObjectContext = context;
    UINavigationController *aNavigationController = [[UINavigationController alloc]
                                                     initWithRootViewController:tableViewController];
    self.navigationController = aNavigationController;
    
    DBSession* dbSession =
    [[DBSession alloc]
      initWithAppKey:@"r35ooyaxflfw51n"
      appSecret:@"tei78uljuzmt863"
      root:kDBRootDropbox]; // either kDBRootAppFolder or kDBRootDropbox

    [DBSession setSharedSession:dbSession];
    
    [self.window addSubview:[navigationController view]];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)didPressLink {
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self.window.rootViewController];
        NSLog(@"Connected!");
    }
}

- (void)didPressUnlink {
    [[DBSession sharedSession] unlinkAll];
    NSLog(@"Disconnected!");
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        if ([[DBSession sharedSession] isLinked]) {
            NSLog(@"App linked successfully!");
            // At this point you can start making API calls
        }
        return YES;
    }
    // Add whatever other url handling code your app requires here
    return NO;
}

- (DBRestClient *)restClient {
    if (!restClient) {
        restClient =
        [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    return restClient;
}

//uploading a file
- (void) uploadFile {
    NSString *localPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSString *filename = @"Info.plist";
    NSString *destDir = @"/";
    [[self restClient] uploadFile:filename toPath:destDir
                    withParentRev:nil fromPath:localPath];
}

- (void)restClient:(DBRestClient*)client uploadedFile:(NSString*)destPath
              from:(NSString*)srcPath metadata:(DBMetadata*)metadata {
    
    NSLog(@"File uploaded successfully to path: %@", metadata.path);
}

- (void)restClient:(DBRestClient*)client uploadFileFailedWithError:(NSError*)error {
    NSLog(@"File upload failed with error - %@", error);
}


//listing a dropbox directory
- (void) listFiles {
    [[self restClient] loadMetadata:@"/"];
}

/*
- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    if (metadata.isDirectory) {
        NSLog(@"Folder '%@' contains:", metadata.path);
        for (DBMetadata *file in metadata.contents) {
            NSLog(@"\t%@", file.filename);
        }
    }
}
*/

- (void) valueChanged:(id) sender {
    UIDatePicker *picker = sender;
    deleteDate = picker.date;
    NSLog(@"date: %@", deleteDate);
}

- (void) getAllFiles {
    [[self restClient] loadMetadata: path];
}

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    if (metadata.isDirectory) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"]; 

        for (DBMetadata *f in metadata.contents) {
            if (!f.isDirectory) {
                //NSComparisonResult result = [deleteDate compare:file.lastModifiedDate];
                NSDate *d = [dateFormatter dateFromString:@"2012-06-29"];
                NSComparisonResult result = [d compare:f.lastModifiedDate];
                if(result == NSOrderedDescending){
                    NSString *path = [f.path stringByAppendingString:f.filename];
                    NSString *name = f.filename;
                    NSDate *date = f.lastModifiedDate;
                    
                    [tableViewController addFile:name];
                    
                    //perhaps here we want to add to filesArray
                    NSLog(@"\t%@", path);
                    NSLog(@"\t%@", [dateFormatter stringFromDate:date]);
                    NSLog(@"\t%@", [dateFormatter stringFromDate:d]);
                }
            }
            else {
                path = f.path;
                [self getAllFiles];
            }
        }
    }
}

- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error {
    NSLog(@"Error loading metadata: %@", error);
}


//download a file
- (void) downloadFile {
    NSString *dropboxPath = @"/Info.plist";
    NSString *localPath = @"/Users/dan/Desktop/DropboxTest/Info.plist";
    [[self restClient] loadFile:dropboxPath intoPath:localPath];
}

- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)localPath {
    NSLog(@"File loaded into path: %@", localPath);
}

- (void)restClient:(DBRestClient*)client loadFileFailedWithError:(NSError*)error {
  NSLog(@"There was an error loading the file - %@", error);
}

//delete a file
- (void) deleteFile {
    NSString *dropboxPath = @"/Info.plist";
    [[self restClient] deletePath:dropboxPath];
}

//purge files
- (void) purgeFile:(NSString *) path {
    [[self restClient] deletePath:path];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"BackupManager" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"BackupManager.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
