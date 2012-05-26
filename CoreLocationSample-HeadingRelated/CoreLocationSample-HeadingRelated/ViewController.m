//
//  ViewController.m
//  CoreLocationSample-HeadingRelated
//
//  Created by UQ Times on 12/05/25.
//  Copyright (c) 2012年 Individual. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, retain) CLLocationManager *locationManager;
@end

@implementation ViewController

@synthesize locationManager = _locationManager;

@synthesize headingFilterLabel = _headingFilterLabel;
@synthesize headingOrientationLabel = _headingOrientationLabel;
@synthesize headingAccuracyLabel = _headingAccuracyLabel;
@synthesize magneticHeadingLabel = _magneticHeadingLabel;
@synthesize trueHeadingLabel = _trueHeadingLabel;
@synthesize xLabel = _xLabel;
@synthesize yLabel = _yLabel;
@synthesize zLabel = _zLabel;
@synthesize arrowLabel = _arrowLabel;
@synthesize northSegment = _northSegment;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // ヘディングの設定
    CLLocationDegrees headingFilter = kCLHeadingFilterNone;  // 常に
    CLDeviceOrientation headingOrientation = CLDeviceOrientationPortrait;  // 上部を基準とする
    
    // インスタンスの生成
    _locationManager = [[CLLocationManager alloc] init];
    // ヘディングが有効ならば設定をして開始
    if ([CLLocationManager headingAvailable]) {
        _locationManager.delegate = self;
        _locationManager.headingFilter = headingFilter;
        _locationManager.headingOrientation = headingOrientation;
        [_locationManager startUpdatingHeading];
        
        // Viewのスイッチの設定
        self.northSegment.selectedSegmentIndex = 1;  // 磁北を選択
        self.northSegment.enabled = YES;
    }
    
    /* Viewに反映 */
    self.headingFilterLabel.text = [NSString stringWithFormat:@"%lf", headingFilter];
    self.headingOrientationLabel.text = [self deviceOrientationToString:headingOrientation];
}

- (void)viewDidUnload
{
    _locationManager.delegate = nil;
    
    self.locationManager = nil;
    self.headingFilterLabel = nil;
    self.headingOrientationLabel = nil;
    self.headingAccuracyLabel = nil;
    self.magneticHeadingLabel = nil;
    self.trueHeadingLabel = nil;
    self.xLabel = nil;
    self.yLabel = nil;
    self.zLabel = nil;
    self.arrowLabel = nil;
    self.northSegment = nil;
    
    [super viewDidUnload];
}

- (void)dealloc
{
    _locationManager.delegate = nil;
    
    [_locationManager release];
    [_headingFilterLabel release];
    [_headingOrientationLabel release];
    [_headingAccuracyLabel release];
    [_magneticHeadingLabel release];
    [_trueHeadingLabel release];
    [_xLabel release];
    [_yLabel release];
    [_zLabel release];
    [_northSegment release];
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/* セグメントが変更された */
- (IBAction)northSegmentChanged:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:  // 停止
            NSLog(@"%s | stopUpdatingLocation & stopUpdatingHeading", __PRETTY_FUNCTION__);
            [_locationManager stopUpdatingLocation];
            [_locationManager stopUpdatingHeading];
            break;
        case 1:  // 磁北
            NSLog(@"%s | stopUpdatingLocation & startUpdatingHeading", __PRETTY_FUNCTION__);
            [_locationManager stopUpdatingLocation];
            [_locationManager startUpdatingHeading];
            break;
        case 2:  // 真北
            NSLog(@"%s | startUpdatingLocation & startUpdatingHeading", __PRETTY_FUNCTION__);
            _locationManager.distanceFilter = kCLDistanceFilterNone;
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            [_locationManager startUpdatingLocation];
            [_locationManager startUpdatingHeading];
            break;
    }
}

#pragma mark - CLLocationManagerDelegate methods

/* ヘディング情報が更新された */
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    if (newHeading.headingAccuracy < 0) {
        return;  // 正しく取得できていない
    }

    // 磁北か真北か
    CLLocationDirection heading = (self.northSegment.selectedSegmentIndex == 1) ? newHeading.magneticHeading : newHeading.trueHeading;
    // 値が正しくなければ0度で固定
    if (heading < 0) {
        heading = 0;
    }
    
    /* Viewに反映 */
    CGFloat radius = (heading / 180) * M_PI;
    self.arrowLabel.transform = CGAffineTransformMakeRotation(-radius);  // 回転方向が逆なので符号を反転
    
    self.headingAccuracyLabel.text = [NSString stringWithFormat:@"%lf", newHeading.headingAccuracy];
    self.magneticHeadingLabel.text = [NSString stringWithFormat:@"%lf", newHeading.magneticHeading];
    self.trueHeadingLabel.text = [NSString stringWithFormat:@"%lf", newHeading.trueHeading];
    self.xLabel.text = [NSString stringWithFormat:@"%lf", newHeading.x];
    self.yLabel.text = [NSString stringWithFormat:@"%lf", newHeading.y];
    self.zLabel.text = [NSString stringWithFormat:@"%lf", newHeading.z];
}

/* コンパスの調整を画面に表示するかどうか */
- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager
{
    return YES;
}

/* 下部スイッチの変更のため、位置情報サービスのオン・オフの変更を受け取る */
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if ([CLLocationManager headingAvailable]) {
        // ヘディングが有効な場合のみ
        if (status == kCLAuthorizationStatusAuthorized || status == kCLAuthorizationStatusNotDetermined) {
            // 真北を有効化
            [self.northSegment setEnabled:YES forSegmentAtIndex:2];
        } else {
            // それ以外は無効化
            if (self.northSegment.selectedSegmentIndex == 2) {
                // 真北が選ばれていたならば、磁北に移動
                self.northSegment.selectedSegmentIndex = 1;
            }
            [self.northSegment setEnabled:NO forSegmentAtIndex:2];
        }
    }
}

#pragma mark - private methods

/* デバイスの向きを文字列に変換する */
- (NSString *)deviceOrientationToString:(CLDeviceOrientation)orientation
{
    switch (orientation) {
        case CLDeviceOrientationUnknown:
            return @"Unknown";
        case CLDeviceOrientationPortrait:
            return @"Portrait";
        case CLDeviceOrientationPortraitUpsideDown:
            return @"UpsideDown";
        case CLDeviceOrientationLandscapeLeft:
            return @"LandscapeLeft";
        case CLDeviceOrientationLandscapeRight:
            return @"LandscapeRight";
        case CLDeviceOrientationFaceUp:
            return @"FaceUp";
        case CLDeviceOrientationFaceDown:
            return @"FaceDown";
    }
}

@end
