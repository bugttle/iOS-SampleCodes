//
//  ViewController.h
//  MapKitSample-MapView
//
//  Created by UQ Times on 12/05/29.
//  Copyright (c) 2012年 Individual. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController <MKMapViewDelegate>

@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (retain, nonatomic) IBOutlet UILabel *mapCoordinateLabel;
@property (retain, nonatomic) IBOutlet UILabel *mapPointLabel;
@property (retain, nonatomic) IBOutlet UILabel *mapRegionLabel;
@property (retain, nonatomic) IBOutlet UISwitch *headingSwitch;

- (IBAction)panUp:(UIButton *)sender;
- (IBAction)panRight:(UIButton *)sender;
- (IBAction)panDown:(UIButton *)sender;
- (IBAction)panLeft:(UIButton *)sender;
- (IBAction)sliderChanged:(UISlider *)sender;
- (IBAction)resetSliderValue:(UISlider *)sender;
- (IBAction)goToTokyoTower:(UIButton *)sender;
- (IBAction)headingSwitchChanged:(UISwitch *)sender;

@end
