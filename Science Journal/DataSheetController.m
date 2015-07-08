//
//  DataSheetController.m
//  Science Journal
//
//  Created by Evan Teague on 5/28/15.
//  Copyright (c) 2015 Evan Teague. All rights reserved.
//

#import "DataSheetController.h"

@interface DataSheetController ()

@end
@implementation DataSheetController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_dataSheetScroll setScrollEnabled:YES];
    [_dataSheetScroll setContentSize:CGSizeMake(320, 570)];
    
    [self.view addSubview:_dataSheetScroll];
    //If there is already a datasheet to load
    if (numRows > 0) {
        _dataRowsField.text = [@(numRows) stringValue];
        _dataColumnsField.text = [@(numColumns) stringValue];
        [self loadDataArray];
    }
    _dataColumnsField.delegate = self;
    _dataRowsField.delegate = self;
    [self registerForKeyboardNotifications];
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//If the user selects cancel
- (IBAction)cancelDataSheet:(id)sender {
    [self.delegate dataSheetControllerCancel:self];
}

//If the user saves the datasheet
- (IBAction)saveDataSheet:(id)sender {
    
    NSMutableDictionary *dataToSave = [[NSMutableDictionary alloc] init];
    for (id key in _dataArray){
        UITextField *tempTextField = [_dataArray objectForKey:key];
        NSString *temp = tempTextField.text;
        [dataToSave setObject:temp forKey:key];
    }
     NSLog(@"data array: %@", dataToSave);
    [self.delegate dataSheetControllerSave:self didSaveArray:dataToSave];
    
}

//Creates the datasheet
- (void) createDataArray{
    //Have to remove any existing textfields
    for (id tf in _dataSheetScroll.subviews){
        if ([tf isKindOfClass:[UITextField class]]){
            [tf removeFromSuperview];
        }
    }
    [self redrawDataSheet];
    _dataArray = [[NSMutableDictionary alloc] init];
    int cellx = 10;
    int celly = 250;
    int cellwidth = 50;
    int cellheight = 30;
    //Creates the table with custom cell sizes
    for (int i = 0; i < numRows; i++){
        for (int j = 0; j < numColumns; j++){
            if (j == 0) {
                cellwidth = 80;
            }else{
                cellwidth = 50;
            }
            NSString *key = [NSString stringWithFormat:@"%i-%i",i,j];
            UITextField *text = [[UITextField alloc] initWithFrame:CGRectMake(cellx, celly, cellwidth, cellheight)];
            text.layer.borderColor=[UIColor blackColor].CGColor;
            text.layer.borderWidth=1.0f;
            text.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            
            text.delegate = self;
            
            
            [_dataSheetScroll addSubview:text];
           
            [_dataArray setObject:text forKey:key];
            if (j == 0){
                cellx+=80;
            }else{
                cellx+=50;
            }
            
            
        }
        cellx = 10;
        celly+=30;
    }
    
    [self drawTableWithRow];
}


//Action when the user selects the make table button
- (IBAction)makeTable:(id)sender {
    [self.view endEditing:YES];
    numColumns = [_dataColumnsField.text intValue];
    numRows = [_dataRowsField.text intValue];
    if ([_dataArrayPassedIn count] > 0){
        NSLog(@"Array has stuff existing: %@", _dataArrayPassedIn);
        [self loadDataArray];
        
    }else{
        NSLog(@"Array does not have stuff existing");
        [self createDataArray];
    }
    
    
}

//Re-adds the text entry fields
- (void) redrawDataSheet {
    [_dataSheetScroll addSubview:_dataColumnsField];
    [_dataSheetScroll addSubview:_dataRowsField];
    
}
//If the user is editing an existing datasheet, this finds the high row and column
- (void) setSheetData:(NSString*) dictionary {
   
    NSError *error;
    NSData *data = [dictionary dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *editableDataSheet = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    _dataArrayPassedIn = [[NSMutableDictionary alloc] init];
    _dataArrayPassedIn = editableDataSheet;
    int highColumn = 0;
    int highRow = 0;
    for (id key in [_dataArrayPassedIn allKeys]){
        NSArray *keyParts = [key componentsSeparatedByString:@"-"];
        if ([[keyParts objectAtIndex: 0] intValue] > highRow){
            highRow = [[keyParts objectAtIndex: 0] intValue];
            
            
        }
        if ([[keyParts objectAtIndex: 1] intValue] > highColumn){
            highColumn = [[keyParts objectAtIndex: 1] intValue];
        }
    }
    numRows = highRow + 1;
    numColumns = highColumn + 1;
    
}

//If the table is larger than the screen, it redraws the scrollview
-(void)drawTableWithRow {
    int newRowsSize = 0;
    int newColsSize = 0;
    if (numRows > 10 && numColumns > 5){
        newRowsSize = 570 + ((numRows - 10) * 30);
        newColsSize = 320 + ((numColumns - 5) * 50);
        [_dataSheetScroll setContentSize:CGSizeMake(newColsSize, newRowsSize)];
    }else if (numRows > 10 && numColumns <= 5){
        newRowsSize = 570 + ((numRows - 10) * 30);
        [_dataSheetScroll setContentSize:CGSizeMake(320, newRowsSize)];
    }else if (numRows <= 10 && numColumns > 5){
        newColsSize = 320 + ((numColumns - 5) * 50);
        [_dataSheetScroll setContentSize:CGSizeMake(newColsSize, 570)];
    }else{
        [_dataSheetScroll setContentSize:CGSizeMake(320, 570)];
    }
    
    screenWidth = newRowsSize;
    [self.view setNeedsDisplay];
}

//If the user is editing the datasheet, this loads the existing data
-(void)loadDataArray{
    for (id tf in _dataSheetScroll.subviews){
        if ([tf isKindOfClass:[UITextField class]]){
            [tf removeFromSuperview];
        }
    }
    [self redrawDataSheet];
    _dataArray = [[NSMutableDictionary alloc] init];
    int cellx = 10;
    int celly = 250;
    int cellwidth = 50;
    int cellheight = 30;
    for (int i = 0; i < numRows; i++){
        for (int j = 0; j < numColumns; j++){
            if (j == 0) {
                cellwidth = 80;
            }else{
                cellwidth = 50;
            }
            NSString *key = [NSString stringWithFormat:@"%i-%i",i,j];
            UITextField *text = [[UITextField alloc] initWithFrame:CGRectMake(cellx, celly, cellwidth, cellheight)];
            text.layer.borderColor=[UIColor blackColor].CGColor;
            text.layer.borderWidth=1.0f;
            text.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            text.text = [_dataArrayPassedIn objectForKey:key];
            text.delegate = self;
            [_dataSheetScroll addSubview:text];
            
            
            [_dataArray setObject:text forKey:key];
            if (j == 0){
                cellx+=80;
            }else{
                cellx+=50;
            }
            
            
        }
        cellx = 10;
        celly+=30;
    }
    
    [self drawTableWithRow];
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField
{
    [aTextField resignFirstResponder];
    return YES;
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];

    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{

    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    _dataSheetScroll.contentInset = contentInsets;
    _dataSheetScroll.scrollIndicatorInsets = contentInsets;
    
   
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}








@end
