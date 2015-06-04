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
//Next step is to be able to add the datasheet back in
@implementation DataSheetController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Sandcropped1.jpg"]];
    [_dataSheetScroll setScrollEnabled:YES];
    [_dataSheetScroll setContentSize:CGSizeMake(320, 570)];
    _dataSheetScroll.pagingEnabled = YES;
    [self.view addSubview:_dataSheetScroll];
    if (numRows > 0) {
        _dataRowsField.text = [@(numRows) stringValue];
        _dataColumnsField.text = [@(numColumns) stringValue];
        [self loadDataArray];
    }
    _dataColumnsField.delegate = self;
    _dataRowsField.delegate = self;
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancelDataSheet:(id)sender {
    [self.delegate dataSheetControllerCancel:self];
}
- (IBAction)saveDataSheet:(id)sender {
    
    
    NSMutableDictionary *dataToSave = [[NSMutableDictionary alloc] init];
    for (id key in _dataArray){
        UITextField *tempTextField = [_dataArray objectForKey:key];
        NSString *temp = tempTextField.text;
        [dataToSave setObject:temp forKey:key];
    }
    
    for (id key in dataToSave){
        NSLog(@"Key: %@, Value: %@", key, [dataToSave objectForKey:key]);
    }
    
     
    [self.delegate dataSheetControllerSave:self didSaveArray:dataToSave];
    
}

- (void) createDataArray{
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
    NSLog(@"Number of rows: %i", numRows);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)makeTable:(id)sender {
    numColumns = [_dataColumnsField.text intValue];
    numRows = [_dataRowsField.text intValue];
    [self createDataArray];
    
    
}

- (void) redrawDataSheet {
    [_dataSheetScroll addSubview:_dataColumnsField];
    [_dataSheetScroll addSubview:_dataRowsField];
    
}

- (void) setSheetData:(NSString*) dictionary {
    NSError *error;
    NSData *data = [dictionary dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *editableDataSheet = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    _dataArray = editableDataSheet;
    NSLog(@"Keys %@", [_dataArray allKeys]);
    NSLog(@"Values %@", [_dataArray allValues]);
    int highColumn = 0;
    int highRow = 0;
    for (id key in [_dataArray allKeys]){
        NSArray *keyParts = [key componentsSeparatedByString:@"-"];
        if ([[keyParts objectAtIndex: 0] intValue] > highRow){
            highRow = [[keyParts objectAtIndex: 0] intValue];
            
        }
        if ([[keyParts objectAtIndex: 1] intValue] > highColumn){
            highColumn= [[keyParts objectAtIndex: 0] intValue];
        }
    }
    
    //NSLog(@"Editing data %@", dictionary);
    NSLog(@"Row: %i", highRow);
    NSLog(@"Column: %i", highColumn);
    numRows = highRow + 1;
    numColumns = highColumn + 1;
    
}

-(void)drawTableWithRow {
    //[self createDataArray];
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
    
    [self.view setNeedsDisplay];
}

-(void)loadDataArray{
    int cellx = 10;
    int celly = 250;
    int cellwidth = 50;
    int cellheight = 30;
    NSLog(@"Number of rows in load: %i", numRows);
    NSLog(@"values in load: %@", [_dataArray allValues]);
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
            text.text = [_dataArray objectForKey:key];
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
