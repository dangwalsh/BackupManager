//
//  File.h
//  BackupManager
//
//  Created by Daniel Walsh on 7/1/12.
//  Copyright (c) 2012 Walsh walsh Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface File : NSManagedObject

@property (nonatomic, retain) NSString * fileName;

@end
