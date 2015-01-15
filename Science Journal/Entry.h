    //
//  Entry.h
//  Science Journal
//
//  Created by Evan Teague on 8/25/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Entry : NSObject{
    @public
    int entryIdentifier;
}
    

@property (strong, nonatomic) NSString *name, *date, *projectName, *goal, *latitude, *longitude, *weather, *magnet, *partners, *permissions, *outcrop, *structuralData, *sampleNum, *notes, *stopNum;
@property (strong, nonatomic) UIImage *sketch;
@property (strong, nonatomic) UIImage *photo;
@property (strong, nonatomic) NSString *magneticValue1, *magneticValue2, *magneticType;




@end
