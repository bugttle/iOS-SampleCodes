//
//  ViewController.h
//  CoreLocationSample-HeadingRelated
//
//  Created by UQ Times on 12/05/25.
//  Copyright (c) 2012年 Individual. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>

@property (retain, nonatomic) IBOutlet UILabel *headingFilterLabel;
@property (retain, nonatomic) IBOutlet UILabel *headingOrientationLabel;
@property (retain, nonatomic) IBOutlet UILabel *headingAccuracyLabel;
@property (retain, nonatomic) IBOutlet UILabel *magneticHeadingLabel;
@property (retain, nonatomic) IBOutlet UILabel *trueHeadingLabel;
@property (retain, nonatomic) IBOutlet UILabel *xLabel;
@property (retain, nonatomic) IBOutlet UILabel *yLabel;
@property (retain, nonatomic) IBOutlet UILabel *zLabel;
@property (nonatomic, retain) IBOutlet UILabel *arrowLabel;
@property (retain, nonatomic) IBOutlet UISegmentedControl *northSegment;

- (IBAction)northSegmentChanged:(UISegmentedControl *)sender;

@end
