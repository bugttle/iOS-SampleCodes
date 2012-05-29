//
//  ViewController.m
//  MapKitSample-MapView
//
//  Created by UQ Times on 12/05/29.
//  Copyright (c) 2012年 Individual. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()
{
    int _lastSliderValue;
}
@end

@implementation ViewController

@synthesize mapView = _mapView;
@synthesize mapCoordinateLabel = _mapCoordinateLabel;
@synthesize mapPointLabel = _mapPointLabel;
@synthesize mapRegionLabel = _mapRegionLabel;
@synthesize headingSwitch = _headingSwitch;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 現在地を利用する (InterfaceBuilderでも指定可能)
    _mapView.showsUserLocation = YES;
    _mapView.mapType = MKMapTypeHybrid;
    [_mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
}

- (void)viewDidUnload
{
    _mapView.delegate = nil;
    
    self.mapView = nil;
    self.mapCoordinateLabel = nil;
    self.mapPointLabel = nil;
    self.mapRegionLabel = nil;
    self.headingSwitch = nil;
    
    [super viewDidUnload];
}

- (void)dealloc
{
    _mapView.delegate = nil;
    
    [_mapView release];
    [_mapCoordinateLabel release];
    [_mapPointLabel release];
    [_mapRegionLabel release];
    [_headingSwitch release];
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/* 指定された場所が中心になるようにパン */
- (void)mapViewCenterSetX:(CGFloat)x y:(CGFloat)y
{
    CLLocationCoordinate2D coord = [_mapView convertPoint:CGPointMake(x, y) toCoordinateFromView:_mapView];
    [_mapView setCenterCoordinate:coord animated:YES];
    
    if (_headingSwitch.on) {
        _mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
    }
}

/* 地図を上にパン */
- (IBAction)panUp:(UIButton *)sender {
    CGFloat nextX = _mapView.frame.size.width / 2;
    CGFloat nextY = 0;
    [self mapViewCenterSetX:nextX y:nextY];
}

/* 地図を右にパン */
- (IBAction)panRight:(UIButton *)sender {
    CGFloat nextX = _mapView.frame.size.width;
    CGFloat nextY = _mapView.frame.size.height / 2;
    [self mapViewCenterSetX:nextX y:nextY];
}

/* 地図を下にパン */
- (IBAction)panDown:(UIButton *)sender {
    CGFloat nextX = _mapView.frame.size.width / 2;
    CGFloat nextY = _mapView.frame.size.height;
    [self mapViewCenterSetX:nextX y:nextY];
}

/* 地図を左にパン */
- (IBAction)panLeft:(UIButton *)sender {
    CGFloat nextX = 0;
    CGFloat nextY = _mapView.frame.size.height / 2;
    [self mapViewCenterSetX:nextX y:nextY];
}

/* スライダーの変更に合わせて、地図を拡大・縮小する */
- (IBAction)sliderChanged:(UISlider *)sender {
    NSLog(@"%lf", sender.value);
    int value = round(sender.value);
    if (value == _lastSliderValue) {
        sender.value = _lastSliderValue;
        return;
    }
    
    // 左で縮小・右で拡大
    MKCoordinateRegion region = _mapView.region;
    if (value < _lastSliderValue) {
        region.span.latitudeDelta /= 2;
        region.span.longitudeDelta /= 2;
    } else {
        region.span.latitudeDelta *= 2;
        region.span.longitudeDelta *= 2;
        // 最大サイズを超えて拡大してしまうと、落ちるので判定
        if (180 < region.span.latitudeDelta) {
            region.span.latitudeDelta = 180;  // 緯度は180度
        }
        if (360 < region.span.longitudeDelta) {
            region.span.longitudeDelta = 360;  // 経度は360度
        }
    }
    
    [_mapView setRegion:region animated:YES];
    _lastSliderValue = value;
}

/* 離されたときに、スライダーをリセットする*/
- (IBAction)resetSliderValue:(UISlider *)sender {
    _lastSliderValue = 0;
    [sender setValue:0 animated:YES];
}

/* 東京タワーに飛ぶ */
- (IBAction)goToTokyoTower:(UIButton *)sender {
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(35.658608, 139.745396);
    MKCoordinateRegion coordRegion = MKCoordinateRegionMakeWithDistance(coord, 500, 500);
    [_mapView setRegion:coordRegion animated:YES];
}

/* ユーザトラッキング＋ヘディングアップをするかどうか */
- (IBAction)headingSwitchChanged:(UISwitch *)sender {
    if (sender.on) {
        [_mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
    } else {
        _mapView.userTrackingMode = MKUserTrackingModeNone;
    }
}

#pragma mark - MKMapViewDelegate methods

/* 地図が移動しようとするとき */
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

/* 地図が移動し終えた後 */
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // 地図座標
    MKCoordinateRegion region = [_mapView convertRect:_mapView.frame toRegionFromView:_mapView];
    _mapCoordinateLabel.text = [NSString stringWithFormat:@"%lf\n%lf", region.center.latitude, region.center.longitude];
    
    // 表示領域
    _mapRegionLabel.text = [NSString stringWithFormat:@"%lf\n%lf", region.span.latitudeDelta, region.span.longitudeDelta];
    
    // 地図点
    MKMapPoint point = MKMapPointForCoordinate(region.center);
    _mapPointLabel.text = [NSString stringWithFormat:@"%lf\n%lf", point.x, point.y];
}

/* 地図を読み込むとき */
- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

/* 地図を読み終えた後 */
- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

/* 地図の読み込みに失敗した場合 */
- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
    NSLog(@"%s | %@", __PRETTY_FUNCTION__, error);
}

/* 位置情報サービスを開始する前 */
- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

/* 位置情報サービスを停止した */
- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

/* 位置情報サービスを更新した */
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

/* 位置情報サービスの更新に失敗した */
- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"%s | %@", __PRETTY_FUNCTION__, error);
}

/* ユーザトラッキングが変更された */
- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // 移動するとユーザートラッキングが解除されるため、スイッチもオフにする
    if (_mapView.userTrackingMode == MKUserTrackingModeNone) {
        _headingSwitch.on = NO;
    }
}

@end
