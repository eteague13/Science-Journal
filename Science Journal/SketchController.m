//
//  SketchController.m
//  Science Journal
//
//  Created by Evan Teague on 9/3/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//  Solution obtained from http://www.raywenderlich.com/18840/how-to-make-a-simple-drawing-app-with-uikit

#import "SketchController.h"
#import "SketchSettingsController.h"



@interface SketchController ()


@end

@implementation SketchController

@synthesize delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    red = 0.0/255.0;
    green = 0.0/255.0;
    blue = 0.0/255.0;
    brush = 10.0;
    opacity = 1.0;
    [super viewDidLoad];
    _drawImage.image = sketch;
    
}
/*
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
*/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




- (IBAction)saveSelected:(id)sender {
    
    //Saves the image and passes it back
    UIGraphicsBeginImageContextWithOptions(self.saveImage.bounds.size, NO,0.0);
    [self.saveImage.image drawInRect:CGRectMake(0, 0, self.saveImage.frame.size.width, self.saveImage.frame.size.height)];
    UIImage *SaveImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    NSLog(@"Sketch 1: %@", SaveImage);
    [self.delegate sketchControllerSave:self didFinishSketch:SaveImage];
    
}



- (IBAction)cancelSketchButton:(id)sender {
    //Cancels the sketch and closes the window
    [self.delegate sketchControllerCancel:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)setSketch:(UIImage*)item{
    //sets the sketch when editing
    sketch = item;
}
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //Checks if the user began drawing
    mouseSwiped = NO;
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self.view];
}
-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    //Tracks the movement of the user drawing
    mouseSwiped = YES;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.drawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    [self.drawImage setAlpha:opacity];
    UIGraphicsEndImageContext();
    
    lastPoint = currentPoint;
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if(!mouseSwiped) {
        UIGraphicsBeginImageContext(self.view.frame.size);
        [self.drawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, opacity);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        self.drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    UIGraphicsBeginImageContext(self.saveImage.frame.size);
    [self.saveImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [self.drawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
    self.saveImage.image = UIGraphicsGetImageFromCurrentImageContext();
    self.drawImage.image = nil;
    UIGraphicsEndImageContext();
}
- (IBAction)selectColor:(id)sender {
    //Brush color selector
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Pick brush:"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Black", @"Grey", @"Red", @"Blue", @"Green", @"Light Blue", @"Brown", @"Yellow", nil];
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];
}

- (IBAction)sketchActions:(id)sender {
    //User actions selector
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Sketch Actions"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Clear Sketch", @"Brush Settings", nil];
    actionSheet.tag = 2;
    [actionSheet showInView:self.view];
    
}

- (IBAction)eraserSelected:(id)sender {
    red = 255.0/255.0;
    green = 255.0/255.0;
    blue = 255.0/255.0;
    opacity = 1.0;
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //Sets the colors based on what the user selects
    if (actionSheet.tag == 1){
        switch(buttonIndex)
        {
            case 0: //Black
                red = 0.0/255.0;
                green = 0.0/255.0;
                blue = 0.0/255.0;
                break;
            case 1: //Grey
                red = 105.0/255.0;
                green = 105.0/255.0;
                blue = 105.0/255.0;
                break;
            case 2: //Red
                red = 255.0/255.0;
                green = 0.0/255.0;
                blue = 0.0/255.0;
                break;
            case 3: //Blue
                red = 0.0/255.0;
                green = 0.0/255.0;
                blue = 255.0/255.0;
                break;
            case 4: //Green
                red = 0.0/255.0;
                green = 255.0/255.0;
                blue = 0.0/255.0;
                break;
            case 5: //Light Blue
                red = 51.0/255.0;
                green = 204.0/255.0;
                blue = 255.0/255.0;
                break;
            case 6: //Brown
                red = 160.0/255.0;
                green = 82.0/255.0;
                blue = 45.0/255.0;
                break;
            case 7: //Yellow
                red = 255.0/255.0;
                green = 255.0/255.0;
                blue = 0.0/255.0;
                break;
        }
    }else if (actionSheet.tag == 2){
        
        if ((long)buttonIndex == 0){
            self.saveImage.image = nil;
        }
        else if ((long)buttonIndex == 1){
            [self performSegueWithIdentifier:@"sketchSettings" sender:self];
        }
        
    }
   
}

- (void)sketchSettingsControllerDone:(SketchSettingsController *) controller setSize:(CGFloat)size setOpacity:(CGFloat)op{
    //Passes back the brush and opacity
    self->brush = size;
    self->opacity = op;
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //Opens up the brush and opacity settings
    if ([segue.identifier isEqualToString:@"sketchSettings"]) {
        SketchSettingsController *settings = [segue destinationViewController];
        settings.delegate = self;
        settings.brush = self->brush;
        settings.opacity = self->opacity;
    }
}

@end
