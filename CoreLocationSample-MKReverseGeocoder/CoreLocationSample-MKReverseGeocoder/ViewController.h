//
//  ViewController.h
//  CoreLocationSample-MKReverseGeocoder
//
//  Created by UQ Times on 12/05/28.
//  Copyright (c) 2012年 Individual. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController <MKReverseGeocoderDelegate, UITableViewDelegate, UITableViewDataSource>

@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (retain, nonatomic) IBOutlet UITableView *resultTableView;

- (IBAction)convertCoordinate:(UIButton *)sender;

@end
