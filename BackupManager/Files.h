//
//  Files.h
//  BackupManager
//
//  Created by Daniel Walsh on 7/2/12.
//  Copyright (c) 2012 Walsh walsh Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Files : NSObject {
    NSString *name;
    NSString *path;
    NSDate *date;
    NSInteger sectionNumber;
}

@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSDate *date;
@property(nonatomic, retain) NSString *path;
@property NSInteger sectionNumber;

@end
