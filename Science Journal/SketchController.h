//
//  SketchController.h
//  Science Journal
//
//  Created by Evan Teague on 9/3/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SketchControllerDelegate;

@interface SketchController : UIViewController {
    CGPoint lastPoint;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;
    BOOL mouseSwiped;
}
@property (weak, nonatomic) IBOutlet UIImageView *saveImage;
@property (weak, nonatomic) IBOutlet UIImageView *drawImage;
- (IBAction)pencilSelected:(id)sender;
- (IBAction)eraserSelected:(id)sender;
- (IBAction)saveSelected:(id)sender;
- (IBAction)clearSelected:(id)sender;
@property (nonatomic, weak) id <SketchControllerDelegate> delegate;
@end

@protocol SketchControllerDelegate <NSObject>

-(void)passBackSketch:(SketchController *)controller didFinishSketch:(UIImage *)item;

@end
