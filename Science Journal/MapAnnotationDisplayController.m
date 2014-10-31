//
//  MapAnnotationDisplayController.m
//  Science Journal
//
//  Created by Evan Teague on 10/3/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

#import "MapAnnotationDisplayController.h"

@interface MapAnnotationDisplayController ()

@end

@implementation MapAnnotationDisplayController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_annotationScroller setScrollEnabled:YES];
    [_annotationScroller setContentSize:CGSizeMake(320, 2500)];
    _annotationEntryName.text = _annotationDetailsModel[0];
    _annotationDate.text = _annotationDetailsModel[1];
    _annotationProjectName.text = _annotationDetailsModel[2];
    _annotationGoal.text = _annotationDetailsModel[3];
    _annotationLatitude.text = _annotationDetailsModel[4];
    _annotationLongitude.text = _annotationDetailsModel[5];
    _annotationWeather.text = _annotationDetailsModel[6];
    _annotationMagnetic.text = _annotationDetailsModel[7];
    _annotationPartners.text = _annotationDetailsModel[8];
    _annotationPermissions.text = _annotationDetailsModel[9];
    _annotationOutcrop.text = _annotationDetailsModel[10];
    _annotationStructuralData.text = _annotationDetailsModel[11];
    _annotationSampleNum.text = _annotationDetailsModel[12];
    _annotationNotes.text = _annotationDetailsModel[13];
    if (_annotationDetailsModel[14] != nil){
        _annotationSketch.image = _annotationDetailsModel[14];
    }
    if (_annotationDetailsModel[15] != nil){
        _annotationPicture.image = _annotationDetailsModel[15];
    }
    
    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    _annotationScroller.contentSize  = CGSizeMake(320, 2500);
    _annotationScroller.scrollEnabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidLayoutSubviews
{
    [self resizeScrollViewContent];
}

- (void) resizeScrollViewContent
{
    self.annotationScroller.contentSize = CGSizeMake(320, 2500);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
