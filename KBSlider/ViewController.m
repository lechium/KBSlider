//
//  ViewController.m
//  KBSlider
//
//  Created by Kevin Bradley on 12/25/20.
//  Copyright © 2020 nito. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property NSTimer *simulatedPlaybackTimer;
@property BOOL ignoreNextEvent;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_kbSlider addTarget:self action:@selector(sliderValueChanges:) forControlEvents:UIControlEventValueChanged];
    _kbSlider.minimumValue = 0;
    _kbSlider.maximumValue = 100;
    _kbSlider.stepValue = 10;
    _kbSlider.isContinuous = false;
    _kbSlider.minimumTrackTintColor = [UIColor orangeColor];
    _kbSlider.fadeOutTransport = false;
    _kbSlider.timeSelectedBlock = ^(CGFloat currentTime) {
        NSLog(@"scrubbing time selected: %f actualTime: %f", currentTime, _kbSlider.value);
        _kbSlider.value = currentTime;
        _kbSlider.currentTime = currentTime;
        _kbSlider.isPlaying = true;
        _ignoreNextEvent = true;
        [self startTimer];
    };
}


- (void)sliderValueChanges:(KBSlider *)slider {
    _valueLabel.text = [NSString stringWithFormat:@"%f", slider.value];
    if (self.kbSlider.sliderMode == KBSliderModeTransport){
        self.kbSlider.currentTime = slider.value;
    }
}

- (void)toggleMode:(id)sender {
    if (self.kbSlider.sliderMode == KBSliderModeDefault){
        self.kbSlider.sliderMode = KBSliderModeTransport;
        [self.kbSlider setTotalDuration:120];
        [self.kbSlider setCurrentTime:1.0];
        self.kbSlider.isPlaying = true;
        [self startTimer];
    } else {
        self.kbSlider.sliderMode = KBSliderModeDefault;
        [self stopTimer];
    }
}

- (void)startTimer {
    [self stopTimer];
    self.simulatedPlaybackTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:true block:^(NSTimer * _Nonnull timer) {
        if (self.kbSlider.isPlaying){
            NSLog(@"kbSlider currentTime: %f", self.kbSlider.currentTime);
            if (self.kbSlider.currentTime+1 <= self.kbSlider.totalDuration){
                self.kbSlider.currentTime++;
            } else {
                [self stopTimer];
            }
        } else {
            NSLog(@"kbslider isnt playing...?");
            [self stopTimer];
        }
    }];
}

- (void)stopTimer {
    if (self.simulatedPlaybackTimer){
        [self.simulatedPlaybackTimer invalidate];
        self.simulatedPlaybackTimer = nil;
    }
}

- (void)pressesEnded:(NSSet<UIPress *> *)presses withEvent:(UIPressesEvent *)event {
    if (self.ignoreNextEvent) {
        DLog(@"ignore next event");
        self.ignoreNextEvent = false;
        return;
    }
    for (UIPress *press in presses) {
        switch (press.type){
                
            case UIPressTypeMenu:
                break;
                
            case UIPressTypePlayPause:
            case UIPressTypeSelect:
                if (![self.kbSlider isPlaying]) {
                    self.kbSlider.isPlaying = true;
                } else {
                    self.kbSlider.isPlaying = false;
               }
                break;
                
            default:
                NSLog(@"[KBSlider] unhandled type: %lu", press.type);
                [super pressesEnded:presses withEvent:event];
                break;
        }
    }
}


@end
