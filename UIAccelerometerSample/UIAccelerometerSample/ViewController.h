//
//  ViewController.h
//  UIAccelerometerSample
//
//  Created by UQ Times on 12/05/13.
//  Copyright (c) 2012年 Individual. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIAccelerometerDelegate>

@property (nonatomic, retain) IBOutlet UILabel *normalLabel;
@property (nonatomic, retain) IBOutlet UILabel *lowpassFilterLabel;
@property (nonatomic, retain) IBOutlet UILabel *highpassFilterLabel;

@end
