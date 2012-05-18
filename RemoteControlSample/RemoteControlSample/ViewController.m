//
//  ViewController.m
//  RemoteControlSample
//
//  Created by UQ Times on 12/05/15.
//  Copyright (c) 2012年 Individual. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@end

@implementation ViewController

@synthesize eventNameLabel = _eventNameLabel;
@synthesize replayButton = _replayButton;
@synthesize audioPlayer = _audioPlayer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // インスタンスを生成し、音を再生する
    NSString *path = [[NSBundle mainBundle] pathForResource:@"se_maoudamashii_magical13" ofType:@"mp3"];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
    self.audioPlayer.delegate = self;
    
    [self playMusic];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self.audioPlayer stop];
    
    self.eventNameLabel = nil;
    self.replayButton = nil;
    self.audioPlayer = nil;
}

- (void)dealloc
{
    _audioPlayer.delegate = nil;
    
    [_eventNameLabel release];
    [_replayButton release];
    [_audioPlayer release];
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark setting for first responder

/* ファーストレスポンダになるためのメソッドのオーバーライド */
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
    
    [super viewWillDisappear:animated];
}

#pragma mark -
#pragma mark UIResponder method

/* リモートコントロールで呼ばれるメソッド */
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    if (event.type == UIEventTypeRemoteControl) {
        NSString *eventName;
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay:
                eventName = @"Play";
                [self playMusic];
                break;
            case UIEventSubtypeRemoteControlPause:
                eventName = @"Pause";
                [self.audioPlayer pause];
                break;
            case UIEventSubtypeRemoteControlStop:
                eventName = @"Stop";
                [self.audioPlayer stop];
                break;
            case UIEventSubtypeRemoteControlTogglePlayPause:
                eventName = @"TogglePlayPause";
                [self playOrPauseMusic];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                eventName = @"NextTrack";
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                eventName = @"PreviousTrack";
                break;
            case UIEventSubtypeRemoteControlBeginSeekingBackward:
                eventName = @"BeginSeekingBackward";
                break;
            case UIEventSubtypeRemoteControlEndSeekingBackward:
                eventName = @"EndSeekingBackward";
                break;
            case UIEventSubtypeRemoteControlBeginSeekingForward:
                eventName = @"BeginSeekingForward";
                break;
            case UIEventSubtypeRemoteControlEndSeekingForward:
                eventName = @"EndSeekingForward";
                break;
            default:  // UIEventSubtypeNone と UIEventSubtypeMotionShake
                eventName = @"UNKNOWN";
                break;
        }
        [self.eventNameLabel setText:eventName];
    }
}

#pragma mark -
#pragma mark AVAudioPlayerDelegate methods

/* 再生終了後に呼ばれるメソッド　*/
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    // 再生終了後に有効にする
    self.replayButton.enabled = YES;
    self.replayButton.hidden = NO;
}

#pragma mark -
#pragma mark private methods

- (void)playMusic
{
    // 再生開始時に無効にする
    self.replayButton.hidden = YES;
    self.replayButton.enabled = NO;
    
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
}

- (void)playOrPauseMusic
{
    if (self.audioPlayer.playing) {
        // 再生中ならば一時停止
        [self.audioPlayer pause];
    } else {
        [self playMusic];
    }
}

- (IBAction)replayMusic:(UIButton *)sender
{
    [self playMusic];
}

@end
