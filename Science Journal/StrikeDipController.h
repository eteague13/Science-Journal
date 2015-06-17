//
//  StrikeDipController.h
//  Science Journal
//
//  Created by Evan Teague on 6/8/15.
//  Copyright (c) 2015 Evan Teague. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StrikeDipController;
@protocol StrikeDipControllerDelegate <NSObject>
- (void)strikeDipCancel:(StrikeDipController *) controller;
- (void)strikeDipSave:(StrikeDipController *)controller strike:(NSString *)st dip:(NSString *)dp;
@end

@interface StrikeDipController : UIViewController <UITextFieldDelegate>

//IBOutlets
@property (weak, nonatomic) IBOutlet UITextField *strikeField;
@property (weak, nonatomic) IBOutlet UITextField *dipField;

//IBActions
- (IBAction)cancelStrikeDip:(id)sender;
- (IBAction)saveStrikeDip:(id)sender;

//Variables
@property (nonatomic, weak) id <StrikeDipControllerDelegate> delegate;
@property (nonatomic, strong) NSString *strike, *dip;

//Methods
-(void)setStrike:(NSString*)strike setDip:(NSString *)dip;

@end
