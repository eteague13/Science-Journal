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
    //Just in case I need more help on this scroller
    //https://agilewarrior.wordpress.com/2012/05/18/uiscrollview-examples/
    _annotationScroller.frame = self.view.frame;
    [self.view addSubview:_annotationScroller];
    
    _annotationEntryName.text = _associatedEntry.name;
    _annotationDate.text = _associatedEntry.date;
    _annotationProjectName.text = _associatedEntry.projectName;
    _annotationGoal.text = _associatedEntry.goal;;
    _annotationLatitude.text = _associatedEntry.latitude;
    _annotationLongitude.text = _associatedEntry.longitude;
    _annotationWeather.text = _associatedEntry.weather;
    _annotationMagnetic.text = _associatedEntry.magnet;
    _annotationPartners.text = _annotationDetailsModel[8];
    _annotationPermissions.text = _associatedEntry.permissions;
    _annotationOutcrop.text = _associatedEntry.outcrop;
    _annotationStructuralData.text = _associatedEntry.structuralData;
    _annotationSampleNum.text = _associatedEntry.sampleNum;
    _annotationNotes.text = _associatedEntry.notes;
    if (_associatedEntry.sketch != nil){
        _annotationSketch  .image = _associatedEntry.sketch;
    }
    if (_associatedEntry.photo != nil){
        _annotationPicture.image = _associatedEntry.photo;
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

/*
- (void) viewDidLayoutSubviews
{
    [self resizeScrollViewContent];
}

- (void) resizeScrollViewContent
{
    self.annotationScroller.contentSize = CGSizeMake(320, 2500);
}
 */


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
