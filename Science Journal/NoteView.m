//
//  NoteView.m
//  Science Journal
//
//  Created by Evan Teague on 2/16/15.
//  Copyright (c) 2015 Evan Teague. All rights reserved.
//

#import "NoteView.h"

@implementation NoteView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:239.0/255.0f green:239.0/255.0f blue:244.0/255.0f alpha:1.0f];
        self.font = [UIFont fontWithName:@"Helvetica" size:17];
    }
    return self;
    
    
}
//Solution from http://stackoverflow.com/questions/5375350/uitextview-ruled-line-background-but-wrong-line-height
- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.2f].CGColor);
    CGContextSetLineWidth(context, 1.0f);
    CGContextBeginPath(context);
    
    NSUInteger numberOfLines = (self.contentSize.height + self.bounds.size.height) / self.font.leading;
    
    CGFloat baselineOffset = 8.0f;
    
    for (int x = 0; x < numberOfLines; x++) {
        CGContextMoveToPoint(context, self.bounds.origin.x, self.font.leading*x + 0.5f + baselineOffset);
        CGContextAddLineToPoint(context, self.bounds.size.width, self.font.leading*x + 0.5f + baselineOffset);
    }
    
    CGContextClosePath(context);
    CGContextStrokePath(context);
}

@end
