//
//  AddReferenceController.h
//  Science Journal
//
//  Created by Evan Teague on 6/1/15.
//  Copyright (c) 2015 Evan Teague. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteView.h"

@class AddReferenceController;
@protocol AddReferenceControllerDelegate <NSObject>
- (void)referenceSave:(AddReferenceController *) controller setContents:(NSString*) contents setImageOrText:(int) val setName:(NSString *)nm;
- (void)referenceCancel:(AddReferenceController *) controller;

@end
@interface AddReferenceController : UIViewController <UITextFieldDelegate, UITextViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    int photoOrText;
    UIImageView *imageView;
}

//IBOutlets

//IBActions
- (IBAction)cancelAddReference:(id)sender;
- (IBAction)saveReference:(id)sender;
- (IBAction)addRefImage:(id)sender;

//Variables
@property (nonatomic, retain) NoteView *note;
@property (nonatomic, weak) id <AddReferenceControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *refImageButton;
@property (weak, nonatomic) IBOutlet UITextField *referenceNameField;

//Methods
-(void)setPhotoOrText: (int) val;




@end
