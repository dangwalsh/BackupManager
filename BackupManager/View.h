//
//  View.h
//  BackupManager
//
//  Created by Daniel Walsh on 6/6/12.
//  Copyright (c) 2012 Walsh walsh Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface View : UIView {
    UIButton *linkButton;
    UIButton *unlinkButton;
    UIButton *upButton;
    UIButton *purgeButton;
    UIButton *downButton;
    UIButton *deleteButton;
    UIDatePicker *datePicker;
    NSDateFormatter *dateFormatter;
}

@end
