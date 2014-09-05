//
//  ReturnSegue.m
//  Science Journal
//
//  Created by Evan Teague on 9/3/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

#import "ReturnSegue.h"

@implementation ReturnSegue

- (void) perform {
    UIViewController *source = (UIViewController *) self.sourceViewController;
    [source.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
