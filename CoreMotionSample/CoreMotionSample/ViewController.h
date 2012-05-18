//
//  ViewController.h
//  CoreMotionSample
//
//  Created by UQ Times on 12/05/16.
//  Copyright (c) 2012年 Individual. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, retain) IBOutlet UILabel *accelerometerDataXLabel;
@property (nonatomic, retain) IBOutlet UILabel *accelerometerDataYLabel;
@property (nonatomic, retain) IBOutlet UILabel *accelerometerDataZLabel;
@property (nonatomic, retain) IBOutlet UILabel *gyroDataXLabel;
@property (nonatomic, retain) IBOutlet UILabel *gyroDataYLabel;
@property (nonatomic, retain) IBOutlet UILabel *gyroDataZLabel;
@property (nonatomic, retain) IBOutlet UILabel *magnetometerDataXLabel;
@property (nonatomic, retain) IBOutlet UILabel *magnetometerDataYLabel;
@property (nonatomic, retain) IBOutlet UILabel *magnetometerDataZLabel;
@property (nonatomic, retain) IBOutlet UILabel *deviceMotionAccelerometerXLabel;
@property (nonatomic, retain) IBOutlet UILabel *deviceMotionAccelerometerYLabel;
@property (nonatomic, retain) IBOutlet UILabel *deviceMotionAccelerometerZLabel;
@property (nonatomic, retain) IBOutlet UILabel *deviceMotionGyroXLabel;
@property (nonatomic, retain) IBOutlet UILabel *deviceMotionGyroYLabel;
@property (nonatomic, retain) IBOutlet UILabel *deviceMotionGyroZLabel;
@property (nonatomic, retain) IBOutlet UILabel *deviceMotionMagnetometerXLabel;
@property (nonatomic, retain) IBOutlet UILabel *deviceMotionMagnetometerYLabel;
@property (nonatomic, retain) IBOutlet UILabel *deviceMotionMagnetometerZLabel;
@property (nonatomic, retain) IBOutlet UILabel *deviceMotionMagnetometerCalibrationAccuracyLabel;
@property (nonatomic, retain) IBOutlet UILabel *deviceMotionMagnetometerAzimuthLabel;
@property (nonatomic, retain) IBOutlet UILabel *deviceMotionAttitudeRoll;
@property (nonatomic, retain) IBOutlet UILabel *deviceMotionAttitudePitch;
@property (nonatomic, retain) IBOutlet UILabel *deviceMotionAttitudeYaw;

@end
