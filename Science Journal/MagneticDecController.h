//
//  MagneticDecController.h
//  Science Journal
//
//  Created by Evan Teague on 1/9/15.
//  Copyright (c) 2015 Evan Teague. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MagneticDecController;
@protocol MagneticDecControllerDelegate <NSObject>
- (void)magDecControllerCancel:(MagneticDecController *) controller;
- (void)magDecControllerSave:(MagneticDecController *)controller value1:(NSString*)v1 value2:(NSString*)v2 type:(NSString*)type;
@end
@interface MagneticDecController : UIViewController{
    NSString *value1;
    NSString *value2;
    NSString *type;
    
}
- (IBAction)magDecCancel:(id)sender;
- (IBAction)magDecSave:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *value1;
@property (weak, nonatomic) IBOutlet UITextField *value2;
@property (weak, nonatomic) IBOutlet UISegmentedControl *magDecType;
@property (nonatomic, weak) id <MagneticDecControllerDelegate> delegate;
-(void)setVal1:(NSString*) val1 setVal2:(NSString*) val2 setType:(NSString*) typ;
@end
