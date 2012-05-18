//
//  ViewController.h
//  RemoteControlSample
//
//  Created by UQ Times on 12/05/15.
//  Copyright (c) 2012年 Individual. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController <AVAudioPlayerDelegate>

@property (nonatomic, retain) IBOutlet UILabel *eventNameLabel;
@property (nonatomic, retain) IBOutlet UIButton *replayButton;

- (IBAction)replayMusic:(UIButton *)sender;

@end
