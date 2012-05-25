//
//  ViewController.h
//  CoreLocationSample-CurrentLocation
//
//  Created by UQ Times on 12/05/23.
//  Copyright (c) 2012年 Individual. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) IBOutlet UILabel *authorizationStatusLabel;
@property (nonatomic, retain) IBOutlet UILabel *distanceFilterLabel;
@property (nonatomic, retain) IBOutlet UILabel *desiredAccuracyLabel;
@property (nonatomic, retain) IBOutlet UILabel *latitudeLabel;
@property (nonatomic, retain) IBOutlet UILabel *longitudeLabel;
@property (nonatomic, retain) IBOutlet UILabel *horizontalAccuracyLabel;
@property (nonatomic, retain) IBOutlet UILabel *altitudeLabel;
@property (nonatomic, retain) IBOutlet UILabel *verticalAccuracyLabel;
@property (nonatomic, retain) IBOutlet UILabel *regionStatusLabel;
@property (nonatomic, retain) IBOutlet UILabel *regionMoniteringLatitudeLabel;
@property (nonatomic, retain) IBOutlet UILabel *regionMoniteringLongitudeLabel;
@property (nonatomic, retain) IBOutlet UILabel *regionMoniteringRadiusLabel;
@property (nonatomic, retain) IBOutlet UILabel *distanceLabel;
@property (nonatomic, retain) IBOutlet UILabel *speedLabel;
@property (nonatomic, retain) IBOutlet UILabel *courseLabel;
@property (nonatomic, retain) IBOutlet UISwitch *workInBackgroundSwitch;
@property (nonatomic, retain) IBOutlet UISwitch *regionMoniteringSwitch;

- (IBAction)regionMoniteringChanged:(UISwitch *)sender;

@end
