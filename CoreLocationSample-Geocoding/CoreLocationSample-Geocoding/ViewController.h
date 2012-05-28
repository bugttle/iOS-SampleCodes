//
//  ViewController.h
//  CoreLocationSample-Geocoding
//
//  Created by UQ Times on 12/05/27.
//  Copyright (c) 2012年 Individual. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (retain, nonatomic) IBOutlet UILabel *placeNameLabel;
@property (retain, nonatomic) IBOutlet UITextField *placeNameText;
@property (retain, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (retain, nonatomic) IBOutlet UITextField *latitudeText;
@property (retain, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (retain, nonatomic) IBOutlet UITextField *longitudeText;
@property (retain, nonatomic) IBOutlet UITableView *resultTableView;

- (IBAction)searchPlaceName:(id)sender;
- (IBAction)convertCoordinate:(id)sender;

@end
