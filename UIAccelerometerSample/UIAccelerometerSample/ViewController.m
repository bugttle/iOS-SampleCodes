//
//  ViewController.m
//  UIAccelerometerSample
//
//  Created by UQ Times on 12/05/13.
//  Copyright (c) 2012年 Individual. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    // ローパスフィルタで利用する
    struct {
        UIAccelerationValue x, y, z;
    } _lowpass;
    
    // ハイパスフィルタで利用する
    struct {
        UIAccelerationValue x, y, z;
    } _highpass;
}
@end

@implementation ViewController

@synthesize normalLabel = _normalLabel;
@synthesize lowpassFilterLabel = _lowpassFilterLabel;
@synthesize highpassFilterLabel = _highpassFilterLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];

	// UIAccelermeterの設定
    const float accelerometerFrequency = 60.0; //Hz:取得する間隔
    UIAccelerometer* theAccelerometer = [UIAccelerometer sharedAccelerometer];
    theAccelerometer.updateInterval = 1 / accelerometerFrequency;
    // デリゲータに代入することですぐに加速度センサーからの情報が取得できる
    theAccelerometer.delegate = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.normalLabel = nil;
    self.lowpassFilterLabel = nil;
    self.highpassFilterLabel = nil;
}

- (void)dealloc
{
    [_normalLabel release];
    [_lowpassFilterLabel release];
    [_highpassFilterLabel release];
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark UIAccelerometerDelegate method

/* 加速度センサーからの入力を受ける */
-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    NSLog(@"%s | %f, %f, %f", __PRETTY_FUNCTION__, acceleration.x, acceleration.y, acceleration.z);
    const float filteringFactor = 0.1;  // ローパス・ハイパスのフィルタで利用する値

    /* normal */
    [self moveLabel:self.normalLabel x:acceleration.x y:acceleration.y];
    
    /* Low-pass filter */
    _lowpass.x = (acceleration.x * filteringFactor) + (_lowpass.x * (1.0 - filteringFactor));
    _lowpass.y = (acceleration.y * filteringFactor) + (_lowpass.y * (1.0 - filteringFactor));
    _lowpass.z = (acceleration.z * filteringFactor) + (_lowpass.z * (1.0 - filteringFactor));
    [self moveLabel:self.lowpassFilterLabel x:_lowpass.x y:_lowpass.y];
    
    /* High-pass filter */
    _highpass.x = acceleration.x - ((acceleration.x * filteringFactor) + (_highpass.x * (1.0 - filteringFactor)));
    _highpass.y = acceleration.y - ((acceleration.y * filteringFactor) + (_highpass.y * (1.0 - filteringFactor)));
    _highpass.z = acceleration.z - ((acceleration.z * filteringFactor) + (_highpass.z * (1.0 - filteringFactor)));
    [self moveLabel:self.highpassFilterLabel x:_highpass.x y:_highpass.y];
}

/*
 * ラベルを移動させる
 * 移動範囲の判定をしていないため、どこまででも移動する
 */
- (void)moveLabel:(UILabel *)label x:(UIAccelerationValue)x y:(UIAccelerationValue)y
{
    const float boostFactor = 10.0;  // そのままではラベルの移動が遅いため、加速させる

    CGPoint center = label.center;
    center.x += x * boostFactor;
    center.y -= y * boostFactor;
    label.center = center;
}

@end
