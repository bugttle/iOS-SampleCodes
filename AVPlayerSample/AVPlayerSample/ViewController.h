//
//  ViewController.h
//  AVPlayerSample
//
//  Created by Tsuruda Ryo on 13/01/29.
//  Copyright (c) 2013年 Tsuruda Ryo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet UISlider *rateSlider;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;

- (IBAction)pushedPauseButton:(UIButton *)sender;
- (IBAction)pushedPlayButton:(UIButton *)sender;
- (IBAction)resetRate:(UISlider *)sender;
- (IBAction)changedRate:(UISlider *)sender;

@end
