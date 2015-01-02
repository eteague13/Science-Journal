//
//  SampleNumController.h
//  Science Journal
//
//  Created by Evan Teague on 12/31/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SampleNumController;
@protocol SampleNumControllerDelegate <NSObject>
- (void)SampleNumControllerCancel:(SampleNumController *) controller;
- (void)SampleNumControllerSave:(SampleNumController *)controller didSaveSample:(NSString*) num;
@end

@interface SampleNumController : UIViewController
@property (nonatomic, weak) id <SampleNumControllerDelegate> delegate;
- (IBAction)sampleCancelButton:(id)sender;
- (IBAction)sampleActionButton:(id)sender;


@end
