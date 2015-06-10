//
//  DataSheetController.h
//  Science Journal
//
//  Created by Evan Teague on 5/28/15.
//  Copyright (c) 2015 Evan Teague. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DataSheetController;
@protocol DataSheetControllerDelegate <NSObject>
- (void)dataSheetControllerCancel:(DataSheetController *) controller;
- (void)dataSheetControllerSave:(DataSheetController *)controller didSaveArray:(NSMutableDictionary*) array;
@end
@interface DataSheetController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate> {
    int numColumns;
    int numRows;
}

//IBOutlets
@property (weak, nonatomic) IBOutlet UITextField *dataColumnsField;
@property (weak, nonatomic) IBOutlet UITextField *dataRowsField;
@property (weak, nonatomic) IBOutlet UIScrollView *dataSheetScroll;
@property (weak, nonatomic) IBOutlet UIButton *makeTableButton;
@property (weak, nonatomic) IBOutlet UILabel *rowsLabel;
@property (weak, nonatomic) IBOutlet UILabel *columnsLabel;

//IBActions
- (IBAction)makeTable:(id)sender;

//Variables
@property (nonatomic, strong) NSMutableDictionary *dataArray;
@property (nonatomic, weak) id <DataSheetControllerDelegate> delegate;

//Methods
-(void) setSheetData:(NSString*) dictionary;
-(void)drawTableWithRow;
-(void)loadDataArray;

@end
