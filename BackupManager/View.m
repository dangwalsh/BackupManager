//
//  View.m
//  BackupManager
//
//  Created by Daniel Walsh on 6/6/12.
//  Copyright (c) 2012 Walsh walsh Studio. All rights reserved.
//

#import "View.h"

@implementation View

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        CGRect b = self.bounds;
		CGSize s = CGSizeMake(100, 40);
        
        dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle: NSDateFormatterFullStyle];
		[dateFormatter setTimeStyle: NSDateFormatterFullStyle];
        
		//Let the date picker assume its natural size.
		datePicker = [[UIDatePicker alloc] initWithFrame: CGRectZero];
		datePicker.datePickerMode = UIDatePickerModeDate; //vs. UIDatePickerModeTime
        
        datePicker.frame = CGRectMake(
                                      b.origin.x,
                                      b.origin.y,
                                      datePicker.bounds.size.width,
                                      datePicker.bounds.size.height
                                      );
        
		[datePicker addTarget: [UIApplication sharedApplication].delegate
                       action: @selector(valueChanged:)
             forControlEvents: UIControlEventValueChanged
         ];
        
		[self addSubview: datePicker];
        
        //code for linkButton
        linkButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        
		linkButton.frame = CGRectMake(
                                  b.origin.x + (b.size.width - s.width) / 4,
                                  b.origin.y + (b.size.height - s.height) * .75,
                                  s.width,
                                  s.height
                                  );
        
		[linkButton setTitleColor: [UIColor redColor] forState: UIControlStateNormal];
		[linkButton setTitle: @"Link" forState: UIControlStateNormal];
        
		[linkButton addTarget: [UIApplication sharedApplication].delegate
                       action: @selector(didPressLink)
             forControlEvents: UIControlEventTouchUpInside
        ];
        
		[self addSubview: linkButton];
        
        //code for linkButton
        unlinkButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        
		unlinkButton.frame = CGRectMake(
                                      b.origin.x + (b.size.width - s.width) / 4,
                                      b.origin.y + (b.size.height - s.height) * .9,
                                      s.width,
                                      s.height
                                      );
        
		[unlinkButton setTitleColor: [UIColor redColor] forState: UIControlStateNormal];
		[unlinkButton setTitle: @"Unlink" forState: UIControlStateNormal];
        
		[unlinkButton addTarget: [UIApplication sharedApplication].delegate
                         action: @selector(didPressUnlink)
               forControlEvents: UIControlEventTouchUpInside
        ];
        
		[self addSubview: unlinkButton];
        
/*        
        //code for upButton
        upButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        
		upButton.frame = CGRectMake(
                                      (b.origin.x + (b.size.width - s.width) / 4) * 3,
                                      b.origin.y + (b.size.height - s.height) * .25,
                                      s.width,
                                      s.height
                                      );
        
		[upButton setTitleColor: [UIColor redColor] forState: UIControlStateNormal];
		[upButton setTitle: @"Upload" forState: UIControlStateNormal];
        
		[upButton addTarget: [UIApplication sharedApplication].delegate
                       action: @selector(uploadFile)
             forControlEvents: UIControlEventTouchUpInside
         ];
*/        
		[self addSubview: upButton];
        
        //code for listButton
        purgeButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        
		purgeButton.frame = CGRectMake(
                                    (b.origin.x + (b.size.width - s.width) / 4) * 3,
                                    b.origin.y + (b.size.height - s.height) * .75,
                                    s.width,
                                    s.height
                                    );
        
		[purgeButton setTitleColor: [UIColor redColor] forState: UIControlStateNormal];
		[purgeButton setTitle: @"Purge" forState: UIControlStateNormal];
        
		[purgeButton addTarget: [UIApplication sharedApplication].delegate
                     action: @selector(getAllFiles)
           forControlEvents: UIControlEventTouchUpInside
         ];
        
		[self addSubview: purgeButton];
/*        
        //code for downButton
        downButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        
		downButton.frame = CGRectMake(
                                      (b.origin.x + (b.size.width - s.width) / 4) * 3,
                                      b.origin.y + (b.size.height - s.height) * .5,
                                      s.width,
                                      s.height
                                      );
        
		[downButton setTitleColor: [UIColor redColor] forState: UIControlStateNormal];
		[downButton setTitle: @"Download" forState: UIControlStateNormal];
        
		[downButton addTarget: [UIApplication sharedApplication].delegate
                       action: @selector(downloadFile)
             forControlEvents: UIControlEventTouchUpInside
         ];
        
		[self addSubview: downButton];

        //code for deleteButton
        deleteButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        
		deleteButton.frame = CGRectMake(
                                      (b.origin.x + (b.size.width - s.width) / 4) * 2,
                                      b.origin.y + (b.size.height - s.height) * .75,
                                      s.width,
                                      s.height
                                      );
        
		[deleteButton setTitleColor: [UIColor redColor] forState: UIControlStateNormal];
		[deleteButton setTitle: @"Delete" forState: UIControlStateNormal];
        
		[deleteButton addTarget: [UIApplication sharedApplication].delegate
                       action: @selector(deleteFile)
             forControlEvents: UIControlEventTouchUpInside
         ];
        
		[self addSubview: deleteButton];
*/
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
