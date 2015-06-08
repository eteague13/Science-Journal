//
//  ProjectCell.h
//  Science Journal
//
//  Created by Evan Teague on 6/5/15.
//  Copyright (c) 2015 Evan Teague. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectCell : UITableViewCell

@property (nonatomic) int identifier;
@property (weak, nonatomic) IBOutlet UILabel *projectLabel;

@end
