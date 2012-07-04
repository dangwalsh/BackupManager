//
//  TableViewController.h
//  BackupManager
//
//  Created by Daniel Walsh on 7/1/12.
//  Copyright (c) 2012 Walsh walsh Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewController : UITableViewController {
    NSMutableArray *filesArray;
    NSMutableDictionary *filesDict;
    NSManagedObjectContext *managedObjectContext;
    UIBarButtonItem *addButton;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSMutableArray *filesArray;
@property (nonatomic, retain) NSMutableDictionary *filesDict;
@property (nonatomic, retain) NSMutableArray *filesSort;

- (void) addFile:(NSString *)name;

@end
