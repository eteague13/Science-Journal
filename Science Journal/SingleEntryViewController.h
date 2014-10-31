//
//  SingleEntryViewController.h
//  Science Journal
//
//  Created by Evan Teague on 8/19/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface SingleEntryViewController : UIViewController <MFMailComposeViewControllerDelegate>

   
    
@property (strong, nonatomic) IBOutlet UIScrollView *entryDetailScroller;
@property (strong, nonatomic) IBOutlet UITextField *entryDetailName;
@property (strong, nonatomic) IBOutlet UITextField *entryDetailDateDisplay;
@property (strong, nonatomic) IBOutlet UIDatePicker *entryDetailDatePicker;
@property (strong, nonatomic) IBOutlet UITextField *entryDetailProjectName;
@property (strong, nonatomic) IBOutlet UITextView *entryDetailGoal;
@property (strong, nonatomic) IBOutlet UITextField *entryDetailLatitude;
@property (strong, nonatomic) IBOutlet UITextField *entryDetailLongitude;
@property (strong, nonatomic) IBOutlet UITextView *entryDetailWeather;
@property (strong, nonatomic) IBOutlet UITextField *entryDetailMagnet;
@property (strong, nonatomic) IBOutlet UITextView *entryDetailPartners;
@property (strong, nonatomic) IBOutlet UITextView *entryDetailPermissions;
@property (strong, nonatomic) IBOutlet UITextView *entryOutcrop;
@property (strong, nonatomic) IBOutlet UITextField *entryDetailSampleNum;
@property (strong, nonatomic) IBOutlet UITextView *entryDetailNotes;
@property (strong, nonatomic) IBOutlet UITextView *entryStructuralData;
- (IBAction)emailEntry:(id)sender;



@property (strong, nonatomic) NSArray *entryDetailsModel;


@end
