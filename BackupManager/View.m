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
        
        //code for linkButton
        linkButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        
		linkButton.frame = CGRectMake(
                                  b.origin.x + (b.size.width - s.width) / 4,
                                  b.origin.y + (b.size.height - s.height) / 4,
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
        
        //code for upButton
        upButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        
		upButton.frame = CGRectMake(
                                      (b.origin.x + (b.size.width - s.width) / 4) * 3,
                                      b.origin.y + (b.size.height - s.height) / 4,
                                      s.width,
                                      s.height
                                      );
        
		[upButton setTitleColor: [UIColor redColor] forState: UIControlStateNormal];
		[upButton setTitle: @"Upload" forState: UIControlStateNormal];
        
		[upButton addTarget: [UIApplication sharedApplication].delegate
                       action: @selector(uploadFile)
             forControlEvents: UIControlEventTouchUpInside
         ];
        
		[self addSubview: upButton];
        
        //code for listButton
        listButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        
		listButton.frame = CGRectMake(
                                    (b.origin.x + (b.size.width - s.width) / 4),
                                    b.origin.y + (b.size.height - s.height) / 2,
                                    s.width,
                                    s.height
                                    );
        
		[listButton setTitleColor: [UIColor redColor] forState: UIControlStateNormal];
		[listButton setTitle: @"List" forState: UIControlStateNormal];
        
		[listButton addTarget: [UIApplication sharedApplication].delegate
                     action: @selector(listFiles)
           forControlEvents: UIControlEventTouchUpInside
         ];
        
		[self addSubview: listButton];
        
        //code for downButton
        downButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        
		downButton.frame = CGRectMake(
                                      (b.origin.x + (b.size.width - s.width) / 4) * 3,
                                      b.origin.y + (b.size.height - s.height) / 2,
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
