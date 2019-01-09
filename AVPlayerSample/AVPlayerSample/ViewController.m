//
//  ViewController.m
//  AVPlayerSample
//
//  Created by Tsuruda Ryo on 13/01/29.
//  Copyright (c) 2013年 Tsuruda Ryo. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "ViewController.h"

static NSString * const videoName = @"video";
static NSString * const videoType = @"mp4";

@interface ViewController () {
@private
    AVPlayerLayer *_playerLayer;
    AVPlayer *_player;
}
@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSString *videoPath = [[NSBundle mainBundle] pathForResource:videoName ofType:videoType];
        _player = [[AVPlayer alloc] initWithURL:[NSURL fileURLWithPath:videoPath]];
        _player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    //playerLayer_ .frame = self.view.frame;
    _playerLayer.frame = CGRectMake(0, 0, 320, 180);
    [self.view.layer addSublayer:_playerLayer];
    
    /* 準備が整ったら再生 */
    [_playerLayer addObserver:self forKeyPath:@"readyForDisplay" options:NSKeyValueObservingOptionNew context:NULL];
    /* 最後まで再生したら、最初から */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:[_player currentItem]];
    
    /* 適当にブラウザを読み込む */
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://gmo-game.com/"]]];
}

/*
 * 再生開始
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"readyForDisplay"]) {
        [_playerLayer removeObserver:self forKeyPath:@"readyForDisplay"];
        [_player play];
    }
}

/*
 * 最初から再生。リピート
 */
- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    NSLog(@"finished");
    //[_player pause];
    [_player seekToTime:CMTimeMakeWithSeconds(1, 1)];
    [_player play];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushedPauseButton:(UIButton *)sender {
    [_player pause];
}

- (IBAction)pushedPlayButton:(UIButton *)sender {
    [_player play];
}

- (IBAction)resetRate:(UISlider *)sender {
    NSLog(@"reset");
    _player.rate = 1.0f;
    _rateSlider.value = 1.0f;
    _rateLabel.text = [NSString stringWithFormat:@"x%02.2f", _player.rate];
}

- (IBAction)changedRate:(UISlider *)sender {
    _player.rate = sender.value;
    _rateLabel.text = [NSString stringWithFormat:@"x%02.2f", _player.rate];
}

@end
