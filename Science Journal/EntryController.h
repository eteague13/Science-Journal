//
//  EntryController.h
//  Science Journal
//
//  Created by Evan Teague on 8/18/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EntryController : UIViewController{
    IBOutlet UIScrollView *entryScroller;
    IBOutlet UIDatePicker *datePicker;
    IBOutlet UITextField *dateDisplayFieldA;
}
@end
