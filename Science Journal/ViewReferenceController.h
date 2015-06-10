//
//  ViewReferenceController.h
//  Science Journal
//
//  Created by Evan Teague on 6/1/15.
//  Copyright (c) 2015 Evan Teague. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteView.h"

@class ViewReferenceController;
@protocol ViewReferenceControllerDelegate <NSObject>
- (void)viewReferenceSave:(ViewReferenceController *) controller setContents:(NSString*) contents setImageOrText:(int) val setName:(NSString *)nm setID:(int)iden;
@end

@interface ViewReferenceController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    int photoOrText;
    UIImageView *imageView;
    int referenceIDToEdit;
    NSString *contents;
    NSString *name;
}
//IBOutlets
@property (weak, nonatomic) IBOutlet UITextField *referenceNameField;
@property (weak, nonatomic) IBOutlet UIButton *editReferenceButton;
@property (weak, nonatomic) IBOutlet UIButton *changeImageButton;

//IBActions
- (IBAction)editReference:(id)sender;
- (IBAction)changeRefImage:(id)sender;
//Variables
@property (nonatomic, retain) NoteView *note;
@property (nonatomic, weak) id <ViewReferenceControllerDelegate> delegate;

//Methods
-(void)setPhotoOrText: (int) val setContents:(NSString *) cont setIdentifier: (int) iden setName: (NSString *) nm;

@end
