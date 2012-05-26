//
//  ViewController.m
//  CoreLocationSample-CurrentLocation
//
//  Created by UQ Times on 12/05/23.
//  Copyright (c) 2012年 Individual. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize locationManager = _locationManager;
@synthesize authorizationStatusLabel = _authorizationStatusLabel;
@synthesize distanceFilterLabel = _distanceFilterLabel;
@synthesize desiredAccuracyLabel = _desiredAccuracyLabel;
@synthesize latitudeLabel = _latitudeLabel;
@synthesize longitudeLabel = _longitudeLabel;
@synthesize horizontalAccuracyLabel = _horizontalAccuracyLabel;
@synthesize altitudeLabel = _altitudeLabel;
@synthesize verticalAccuracyLabel = _verticalAccuracyLabel;
@synthesize regionStatusLabel = _regionStatusLabel;
@synthesize regionMoniteringLatitudeLabel = _regionMoniteringLatitudeLabel;
@synthesize regionMoniteringLongitudeLabel = _regionMoniteringLongitudeLabel;
@synthesize regionMoniteringRadiusLabel = _regionMoniteringRadiusLabel;
@synthesize distanceLabel = _distanceLabel;
@synthesize speedLabel = _speedLabel;
@synthesize courseLabel = _courseLabel;
@synthesize workInBackgroundSwitch = _workInBackgroundSwitch;
@synthesize regionMoniteringSwitch = _regionMoniteringSwitch;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 標準位置情報サービスで利用する値
    CLLocationDistance distanceFilter = kCLDistanceFilterNone;  // 常に更新
    CLLocationAccuracy desiredAccuracy = kCLLocationAccuracyBest;  // 最高レベル
    
    // インスタンスを生成
    _locationManager = [[CLLocationManager alloc] init];
    // 標準位置情報サービスが利用可能ならば、設定をして開始
    if ([CLLocationManager locationServicesEnabled]) {
        _locationManager.delegate = self;
        _locationManager.purpose = @"Because, it's a SAMPLE.";
        _locationManager.distanceFilter = distanceFilter;
        _locationManager.desiredAccuracy = desiredAccuracy;
        
        [_locationManager startUpdatingLocation];
    }
    
    /* Viewに反映する */
    _distanceFilterLabel.text = [NSString stringWithFormat:@"%lf", distanceFilter];
    _desiredAccuracyLabel.text = [NSString stringWithFormat:@"%lf", desiredAccuracy];
}

- (void)viewDidUnload
{
    _locationManager.delegate = nil;
    
    self.locationManager = nil;
    self.authorizationStatusLabel = nil;
    self.distanceFilterLabel = nil;
    self.desiredAccuracyLabel = nil;
    self.latitudeLabel = nil;
    self.longitudeLabel = nil;
    self.horizontalAccuracyLabel = nil;
    self.altitudeLabel = nil;
    self.verticalAccuracyLabel = nil;
    self.regionMoniteringLatitudeLabel = nil;
    self.regionMoniteringLongitudeLabel = nil;
    self.regionMoniteringRadiusLabel = nil;
    self.distanceLabel = nil;
    self.speedLabel = nil;
    self.courseLabel = nil;
    self.workInBackgroundSwitch = nil;
    self.regionMoniteringSwitch = nil;
    
    [super viewDidUnload];
}

- (void)dealloc
{
    _locationManager.delegate = nil;
    
    [_locationManager release];
    [_authorizationStatusLabel release];
    [_distanceFilterLabel release];
    [_desiredAccuracyLabel release];
    [_latitudeLabel release];
    [_longitudeLabel release];
    [_horizontalAccuracyLabel release];
    [_altitudeLabel release];
    [_verticalAccuracyLabel release];
    [_regionMoniteringLatitudeLabel release];
    [_regionMoniteringLongitudeLabel release];
    [_regionMoniteringRadiusLabel release];
    [_distanceLabel release];
    [_speedLabel release];
    [_courseLabel release];
    [_workInBackgroundSwitch release];
    [_regionMoniteringSwitch release];

    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/* 領域観測のスイッチ変更 */
- (IBAction)regionMoniteringChanged:(UISwitch *)sender {
    if (sender.on) {
        /* 領域観測を有効にする */
        // 領域観測の半径
        CLLocationDistance radius = 100.0;
        
        // 設定したい場所の情報を作成
        CLLocationCoordinate2D location = _locationManager.location.coordinate;
        // 半径、キー文字列をもとにオブジェクトを生成
        CLRegion *region = [[CLRegion alloc] initCircularRegionWithCenter:location radius:radius identifier:@"CurrentLocation"];
        // サービスの開始
        [_locationManager startMonitoringForRegion:region desiredAccuracy:kCLLocationAccuracyBest];
        // 不要なものを解放
        [region release];
        
        /* Viewに反映 */
        self.regionMoniteringLatitudeLabel.text = [NSString stringWithFormat:@"%lf", location.latitude];
        self.regionMoniteringLongitudeLabel.text = [NSString stringWithFormat:@"%lf", location.longitude];
        self.regionMoniteringRadiusLabel.text = [NSString stringWithFormat:@"%lf", radius];
    } else {
        /* 領域観測の停止 */
        for (CLRegion *region in _locationManager.monitoredRegions) {
            // サンプルでは"CurrentLocation"のみ
            [_locationManager stopMonitoringForRegion:region];
        }
        
        /* Viewに反映 */
        self.regionMoniteringLatitudeLabel.text = @"None";
        self.regionMoniteringLongitudeLabel.text = @"None";
        self.regionMoniteringRadiusLabel.text = @"None";
    }
}

#pragma mark - CLLocationManagerDelegate methods

/* 位置情報サービスのオン・オフが切り替えられた */
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    // 現在の状態を表示
    self.authorizationStatusLabel.text = [self authorizationStatusToString:status];
    
    if (status == kCLAuthorizationStatusAuthorized) {
        // 大幅変更位置情報サービスが利用できるかどうか
        if ([CLLocationManager significantLocationChangeMonitoringAvailable]) {
            _workInBackgroundSwitch.enabled = YES;
        } else{
            // 利用できなければ無効
            _workInBackgroundSwitch.enabled = NO;
            _workInBackgroundSwitch.on = NO;
        }
        // 領域観測が利用できるかどうか
        if ([CLLocationManager regionMonitoringAvailable] && [CLLocationManager regionMonitoringEnabled]) {
            _regionMoniteringSwitch.enabled = YES;
            if (0 < [_locationManager.monitoredRegions count]) {
                // 前回登録していたら位置を復元し、スイッチをONにする
                for (CLRegion *region in _locationManager.monitoredRegions) {
                    // サンプルでは"CurrentLocation"のみ
                    self.regionMoniteringLatitudeLabel.text = [NSString stringWithFormat:@"%lf", region.center.latitude];
                    self.regionMoniteringLongitudeLabel.text = [NSString stringWithFormat:@"%lf", region.center.longitude];
                    self.regionMoniteringRadiusLabel.text = [NSString stringWithFormat:@"%lf", region.radius];
                }
                _regionMoniteringSwitch.on = YES;
            }
        } else{
            // 利用できなければ無効
            _regionMoniteringSwitch.enabled = NO;
            _regionMoniteringSwitch.on = NO;
        }
    } else {
        // それ以外の状態の場合は、スイッチを無効にする
        _workInBackgroundSwitch.enabled = NO;
        _workInBackgroundSwitch.on = NO;
        _regionMoniteringSwitch.enabled = NO;
        _regionMoniteringSwitch.on = NO;
    }
}

/* 位置情報の取得に失敗した　*/
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	NSLog(@"%s | %@", __PRETTY_FUNCTION__, error);
    
    if ([error code] == kCLErrorDenied) {
        // 位置情報サービスがユーザにより拒否されたので停止
        NSLog(@"%s | stopUpdatingLocation", __PRETTY_FUNCTION__);
        [_locationManager stopUpdatingLocation];
    }
}

/* 標準位置情報サービス・大幅変更位置情報サービスからの情報を受け取った */
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSDate *eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (15.0 < abs(howRecent)) {
        return;  // 古い情報は無視
    }
    
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground) {
        NSLog(@"%s | (BG): %@", __PRETTY_FUNCTION__, newLocation);
        [self fireLocalNotificationNow:@"didUpdateToLocation(BG)"];
    } else {
        NSLog(@"%s", __PRETTY_FUNCTION__);
        // 現在地
        self.latitudeLabel.text = [NSString stringWithFormat:@"%lf", newLocation.coordinate.latitude];
        self.longitudeLabel.text = [NSString stringWithFormat:@"%lf", newLocation.coordinate.longitude];
        self.altitudeLabel.text = [NSString stringWithFormat:@"%lf", newLocation.altitude];
        self.horizontalAccuracyLabel.text = [NSString stringWithFormat:@"%lf", newLocation.horizontalAccuracy];
        self.verticalAccuracyLabel.text = [NSString stringWithFormat:@"%lf", newLocation.verticalAccuracy];
        // 速度
        self.speedLabel.text = [NSString stringWithFormat:@"%lf", newLocation.speed];
        // 距離
        if (oldLocation != nil) {
            self.distanceLabel.text = [NSString stringWithFormat:@"%lf", [newLocation distanceFromLocation:oldLocation]];
        }
        // 方向
        self.courseLabel.text = [NSString stringWithFormat:@"%lf", newLocation.course];
    }
}

/* 領域観測の登録に失敗した */
- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    NSLog(@"%s | %@, %@", __PRETTY_FUNCTION__, region, error);
}

/* 指定した領域に入った */
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground) {
        // バックグラウンドでの処理
        NSLog(@"%s | (BG): %@", __PRETTY_FUNCTION__, region);
        [self fireLocalNotificationNow:@"didEnterRegion"];
    } else {
        NSLog(@"%s | %@", __PRETTY_FUNCTION__, region);
        self.regionStatusLabel.text = @"didEnterRegion";
    }
}

/* 指定した領域から出た */
- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground) {
        // バックグラウンドでの処理
        NSLog(@"%s | (BG): %@", __PRETTY_FUNCTION__, region);
        [self fireLocalNotificationNow:@"didExitRegion"];
    } else {
        NSLog(@"%s | %@", __PRETTY_FUNCTION__, region);
        self.regionStatusLabel.text = @"didExitRegion";
    }
}

#pragma mark - private methods

/* 位置情報サービスの利用可否を文字列に変換 */
- (NSString *)authorizationStatusToString:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            return @"NotDetermined";
        case kCLAuthorizationStatusRestricted:
            return @"Restricted";
        case kCLAuthorizationStatusDenied:
            return @"Denied";
        case kCLAuthorizationStatusAuthorized:
            return @"Authorized";
    }
}

/* ローカル通知を発生させる */
- (void)fireLocalNotificationNow:(NSString *)alertBody
{
    UILocalNotification *lc = [[UILocalNotification alloc] init];
    lc.alertBody = alertBody;
    lc.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] presentLocalNotificationNow:lc];
    [lc release];
}

@end
