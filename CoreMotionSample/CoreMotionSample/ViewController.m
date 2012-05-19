//
//  ViewController.m
//  CoreMotionSample
//
//  Created by UQ Times on 12/05/16.
//  Copyright (c) 2012年 Individual. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>
#import "ViewController.h"

@interface ViewController ()
{
    float _systemVersion;
}
@property (nonatomic, retain) CMMotionManager *manager;
@end

@implementation ViewController
@synthesize accelerometerDataXLabel = _accelerometerDataXLabel;
@synthesize accelerometerDataYLabel = _accelerometerDataYLabel;
@synthesize accelerometerDataZLabel = _accelerometerDataZLabel;
@synthesize gyroDataXLabel = _gyroDataXLabel;
@synthesize gyroDataYLabel = _gyroDataYLabel;
@synthesize gyroDataZLabel = _gyroDataZLabel;
@synthesize magnetometerDataXLabel = _magnetometerDataXLabel;
@synthesize magnetometerDataYLabel = _magnetometerDataYLabel;
@synthesize magnetometerDataZLabel = _magnetometerDataZLabel;
@synthesize deviceMotionAccelerometerXLabel = _deviceMotionAccelerometerXLabel;
@synthesize deviceMotionAccelerometerYLabel = _deviceMotionAccelerometerYLabel;
@synthesize deviceMotionAccelerometerZLabel = _deviceMotionAccelerometerZLabel;
@synthesize deviceMotionGyroXLabel = _deviceMotionGyroXLabel;
@synthesize deviceMotionGyroYLabel = _deviceMotionGyroYLabel;
@synthesize deviceMotionGyroZLabel = _deviceMotionGyroZLabel;
@synthesize deviceMotionMagnetometerXLabel = _deviceMotionMagnetometerXLabel;
@synthesize deviceMotionMagnetometerYLabel = _deviceMotionMagnetometerYLabel;
@synthesize deviceMotionMagnetometerZLabel = _deviceMotionMagnetometerZLabel;
@synthesize deviceMotionMagnetometerCalibrationAccuracyLabel = _deviceMotionMagnetometerCalibrationAccuracyLabel;
@synthesize deviceMotionMagnetometerAzimuthLabel = _deviceMotionMagnetometerAzimuthLabel;
@synthesize deviceMotionAttitudeRoll = _deviceMotionAttitudeRoll;
@synthesize deviceMotionAttitudePitch = _deviceMotionAttitudePitch;
@synthesize deviceMotionAttitudeYaw = _deviceMotionAttitudeYaw;

@synthesize manager = _manager;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // iOSのバージョンを取得
    _systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    NSLog(@"iOS version: %f", _systemVersion);
    
    // 周波数(Hz)
    int frequency = 50;
    // インスタンスの生成
    self.manager = [[CMMotionManager alloc] init];
    
    /* 各種センサーの利用開始(全てを動作させると非常に遅くなるので注意) */
    // CMAccelerometerDataの開始
    [self startCMAccelerometerData:frequency];
    
    // CMGyroDataの開始
    [self startCMGyroData:frequency];
    
    // CMMagnetometerDataの開始
    [self startCMMagnetometerData:frequency];
    
    // CMDeviceMotionの開始
    [self startCMDeviceMotion:frequency];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // 各種センサーの利用停止
    if (4.0 < _systemVersion) {
        // CMAccelerometerDataの停止
        if (self.manager.accelerometerActive) {
            [self.manager stopAccelerometerUpdates];
        }
        // CMGyroDataの停止
        if (self.manager.gyroActive) {
            [self.manager stopGyroUpdates];
        }
        // CMDeviceMotionの停止
        if (self.manager.deviceMotionActive) {
            [self.manager stopDeviceMotionUpdates];
        }
        if (5.0 < _systemVersion) {
            // CMMagnetometerDataの停止
            if (self.manager.magnetometerActive) {
                [self.manager stopMagnetometerUpdates];
            }
        }
    }

    self.manager = nil;
    
    self.accelerometerDataXLabel = nil;
    self.accelerometerDataYLabel = nil;
    self.accelerometerDataZLabel = nil;
    self.gyroDataXLabel = nil;
    self.gyroDataYLabel = nil;
    self.gyroDataZLabel = nil;
    self.magnetometerDataXLabel = nil;
    self.magnetometerDataYLabel = nil;
    self.magnetometerDataZLabel = nil;
    self.deviceMotionAccelerometerXLabel = nil;
    self.deviceMotionAccelerometerYLabel = nil;
    self.deviceMotionAccelerometerZLabel = nil;
    self.deviceMotionGyroXLabel = nil;
    self.deviceMotionGyroYLabel = nil;
    self.deviceMotionGyroZLabel = nil;
    self.deviceMotionMagnetometerXLabel = nil;
    self.deviceMotionMagnetometerYLabel = nil;
    self.deviceMotionMagnetometerZLabel = nil;
    self.deviceMotionMagnetometerCalibrationAccuracyLabel = nil;
    self.deviceMotionMagnetometerAzimuthLabel = nil;
    self.deviceMotionAttitudeRoll = nil;
    self.deviceMotionAttitudePitch = nil;
    self.deviceMotionAttitudeYaw = nil;
}

- (void)dealloc
{
    [_manager release];
    
    [_accelerometerDataXLabel release];
    [_accelerometerDataYLabel release];
    [_accelerometerDataZLabel release];
    [_gyroDataXLabel release];
    [_gyroDataYLabel release];
    [_gyroDataZLabel release];
    [_magnetometerDataXLabel release];
    [_magnetometerDataYLabel release];
    [_magnetometerDataZLabel release];
    [_deviceMotionAccelerometerXLabel release];
    [_deviceMotionAccelerometerYLabel release];
    [_deviceMotionAccelerometerZLabel release];
    [_deviceMotionGyroXLabel release];
    [_deviceMotionGyroYLabel release];
    [_deviceMotionGyroZLabel release];
    [_deviceMotionMagnetometerXLabel release];
    [_deviceMotionMagnetometerYLabel release];
    [_deviceMotionMagnetometerZLabel release];
    [_deviceMotionMagnetometerCalibrationAccuracyLabel release];
    [_deviceMotionMagnetometerAzimuthLabel release];
    [_deviceMotionAttitudeRoll release];
    [_deviceMotionAttitudePitch release];
    [_deviceMotionAttitudeYaw release];
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark CoreMotion setup methods

- (void)startCMAccelerometerData:(int)frequency
{
    // 加速度センサーの有無を確認
    if (self.manager.accelerometerAvailable) {
        // 更新間隔の指定
        self.manager.accelerometerUpdateInterval = 1 / frequency;  // 秒
        // ハンドラ
        CMAccelerometerHandler handler = ^(CMAccelerometerData *data, NSError *error) {
            // double timestamp = data.timestamp;
            self.accelerometerDataXLabel.text = [NSString stringWithFormat:@"%lf", data.acceleration.x];
            self.accelerometerDataYLabel.text = [NSString stringWithFormat:@"%lf", data.acceleration.y];
            self.accelerometerDataZLabel.text = [NSString stringWithFormat:@"%lf", data.acceleration.z];
        };
        // センサーの利用開始
        [self.manager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:handler];
    }
}

- (void)startCMGyroData:(int)frequency
{
    // ジャイロスコープの有無を確認
    if (self.manager.gyroAvailable) {
        // 更新間隔の指定
        self.manager.gyroUpdateInterval = 1 / frequency;  // 秒
        // ハンドラ
        CMGyroHandler handler = ^(CMGyroData *data, NSError *error) {
            // double timestamp = data.timestamp;
            self.gyroDataXLabel.text = [NSString stringWithFormat:@"%lf", data.rotationRate.x];
            self.gyroDataYLabel.text = [NSString stringWithFormat:@"%lf", data.rotationRate.y];
            self.gyroDataZLabel.text = [NSString stringWithFormat:@"%lf", data.rotationRate.z];
        };
        // センサーの利用開始
        [self.manager startGyroUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:handler];
    }
}

- (void)startCMMagnetometerData:(int)frequency
{
    // 磁力計の有無を確認
    if (5.0 < _systemVersion && self.manager.magnetometerAvailable) {
        // 更新間隔の指定
        self.manager.magnetometerUpdateInterval = 1 / frequency;  // 秒
        // ハンドラ
        CMMagnetometerHandler handler = ^(CMMagnetometerData *data, NSError *error) {
            // double timestamp = data.timestamp;
            self.magnetometerDataXLabel.text = [NSString stringWithFormat:@"%lf", data.magneticField.x];
            self.magnetometerDataYLabel.text = [NSString stringWithFormat:@"%lf", data.magneticField.y];
            self.magnetometerDataZLabel.text = [NSString stringWithFormat:@"%lf", data.magneticField.z];
        };
        // センサーの利用開始
        [self.manager startMagnetometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:handler];
    }
}

- (void)startCMDeviceMotion:(int)frequency
{
    // センサーの有無を確認
    if (self.manager.deviceMotionAvailable) {
        // 更新間隔の指定
        self.manager.deviceMotionUpdateInterval = 1 / frequency;  // 秒
        // ハンドラ
        CMDeviceMotionHandler handler = ^(CMDeviceMotion *motion, NSError *error) {
            //double timestamp = motion.timestamp;
            
            /* accelerometer */
            self.deviceMotionAccelerometerXLabel.text = [NSString stringWithFormat:@"%lf", motion.userAcceleration.x + motion.gravity.x];
            self.deviceMotionAccelerometerYLabel.text = [NSString stringWithFormat:@"%lf", motion.userAcceleration.y + motion.gravity.y];
            self.deviceMotionAccelerometerZLabel.text = [NSString stringWithFormat:@"%lf", motion.userAcceleration.z + motion.gravity.z];
            
            /* gyro */
            self.deviceMotionGyroXLabel.text = [NSString stringWithFormat:@"%lf", motion.rotationRate.x];
            self.deviceMotionGyroYLabel.text = [NSString stringWithFormat:@"%lf", motion.rotationRate.y];
            self.deviceMotionGyroZLabel.text = [NSString stringWithFormat:@"%lf", motion.rotationRate.z];
            
            /* magnetometer */
            if (5.0 < _systemVersion && self.manager.magnetometerAvailable) {
                /* startDeviceMotionUpdatesUsingReferenceFrame で以下の値を指定した場合のみ取得可能
                     - CMAttitudeReferenceFrameXArbitraryCorrectedZVertical
                     - CMAttitudeReferenceFrameXMagneticNorthZVertical
                     - CMAttitudeReferenceFrameXTrueNorthZVertical
                   startDeviceMotionUpdatesToQueue や CMAttitudeReferenceFrameXArbitraryZVertical を指定した場合は取得できない */
                self.deviceMotionMagnetometerXLabel.text = [NSString stringWithFormat:@"%lf", motion.magneticField.field.x];
                self.deviceMotionMagnetometerYLabel.text = [NSString stringWithFormat:@"%lf", motion.magneticField.field.y];
                self.deviceMotionMagnetometerZLabel.text = [NSString stringWithFormat:@"%lf", motion.magneticField.field.z];
                switch (motion.magneticField.accuracy) {
                    case CMMagneticFieldCalibrationAccuracyUncalibrated:
                        self.deviceMotionMagnetometerCalibrationAccuracyLabel.text = @"Uncalibrated";
                        break;
                    case CMMagneticFieldCalibrationAccuracyLow:
                        self.deviceMotionMagnetometerCalibrationAccuracyLabel.text = @"Low";
                        break;
                    case CMMagneticFieldCalibrationAccuracyMedium:
                        self.deviceMotionMagnetometerCalibrationAccuracyLabel.text = @"Medium";
                        break;
                    case CMMagneticFieldCalibrationAccuracyHigh:
                        self.deviceMotionMagnetometerCalibrationAccuracyLabel.text = @"High";
                        break;
                }
                // "磁北"か"真北"からの角度。Y軸方向を起点にするため、(x, y)を渡す
                double radian = atan2(motion.magneticField.field.x, motion.magneticField.field.y);
                self.deviceMotionMagnetometerAzimuthLabel.text = [NSString stringWithFormat:@"%.1lf", radian / M_PI * 180];
            }

            /* CMAttitude */
            self.deviceMotionAttitudeRoll.text = [NSString stringWithFormat:@"%lf", motion.attitude.roll];
            self.deviceMotionAttitudePitch.text = [NSString stringWithFormat:@"%lf", motion.attitude.pitch];
            self.deviceMotionAttitudeYaw.text = [NSString stringWithFormat:@"%lf", motion.attitude.yaw];
        };
        
        // DeviceMotionの開始
        if (5.0 < _systemVersion) {
            /* 調整をせずに開始 */
            //[self.manager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:handler];
            
            /* Z軸を鉛直として、X軸を横とする(FaceUp) */
            //[self.manager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical toQueue:[NSOperationQueue currentQueue] withHandler:handler];
            
            /* 上記に加えて、電子コンパスで位置を修正する(ただし、上記のものよりもCPUを消費する) */
            //[self.manager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryCorrectedZVertical toQueue:[NSOperationQueue currentQueue] withHandler:handler];
            
            /* Z軸を鉛直として、X軸を横とする。その際、電子コンパスを利用して、X軸を"磁北"に設定 */
            //[self.manager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXMagneticNorthZVertical toQueue:[NSOperationQueue currentQueue] withHandler:handler];
            
            /* Z軸を鉛直として、X軸を横とする。その際、GPSと電子コンパスを利用して、X軸を"真北"に設定 */
            [self.manager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXTrueNorthZVertical toQueue:[NSOperationQueue currentQueue] withHandler:handler];
        } else {
            /* 調整できるのはiOS 5以降 */
            [self.manager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:handler];
        }
    }
}

@end
