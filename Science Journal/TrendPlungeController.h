//
//  TrendPlungeController.h
//  Science Journal
//
//  Created by Evan Teague on 6/8/15.
//  Copyright (c) 2015 Evan Teague. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TrendPlungeController;
@protocol TrendPlungeControllerDelegate <NSObject>
- (void)trendPlungeCancel:(TrendPlungeController *) controller;
- (void)trendPlungeSave:(TrendPlungeController *)controller trend:(NSString *)tr plunge:(NSString *)pl;
@end

@interface TrendPlungeController : UIViewController

//IBOutlets
@property (weak, nonatomic) IBOutlet UITextField *trendField;
@property (weak, nonatomic) IBOutlet UITextField *plungeField;

//IBActions
- (IBAction)cancelTrendPlunge:(id)sender;
- (IBAction)saveTrendPlunge:(id)sender;

//Variables
@property (nonatomic, weak) id <TrendPlungeControllerDelegate> delegate;
@property (nonatomic, strong) NSString *trend, *plunge;

//Methods
-(void)setTrend:(NSString*)trend setPlunge:(NSString *)plunge;

@end
