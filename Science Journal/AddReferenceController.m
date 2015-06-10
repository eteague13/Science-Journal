//
//  AddReferenceController.m
//  Science Journal
//
//  Created by Evan Teague on 6/1/15.
//  Copyright (c) 2015 Evan Teague. All rights reserved.
//

#import "AddReferenceController.h"

@interface AddReferenceController ()

@end

@implementation AddReferenceController

- (void)viewDidLoad {
    [super viewDidLoad];
     //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Sandcropped1.jpg"]];
    // Do any additional setup after loading the view.
    //If photo
    if (photoOrText == 0) {
        CGRect frame = CGRectMake(0, 100, 320, 370);
        imageView = [[UIImageView alloc] initWithFrame:frame];
        [self.view addSubview:imageView];
        
    //If Text
    }else{
        CGRect frame = CGRectMake(0, 100, 320, 470);
        self.note = [[NoteView alloc] initWithFrame:frame];
        [self.view addSubview:_note];
        _note.delegate = self;
        [_note setScrollEnabled:YES];
        _refImageButton.enabled = NO;
       
    }
    
    _referenceNameField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setPhotoOrText:(int)val {
    photoOrText = val;
    
}

- (IBAction)cancelAddReference:(id)sender {
    [self.delegate referenceCancel:self];
}

- (IBAction)saveReference:(id)sender {
    
    NSString *savedPictureLocation;
    if (imageView != nil && photoOrText == 0){
        NSString *picturename = [NSMutableString stringWithFormat:@"%@%@", _referenceNameField.text, @"_resource.png"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        savedPictureLocation = [documentsDirectory stringByAppendingPathComponent:picturename];
        NSData *pictureData = UIImagePNGRepresentation(imageView.image);
        [pictureData writeToFile:savedPictureLocation atomically:NO];
        [self.delegate referenceSave:self setContents:savedPictureLocation setImageOrText:photoOrText setName:_referenceNameField.text];
    }else if (photoOrText == 1){
        [self.delegate referenceSave:self setContents:_note.text setImageOrText:(int) photoOrText setName:_referenceNameField.text];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addRefImage:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    NSLog(@"using photo");
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    imageView.image = chosenImage;

    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
