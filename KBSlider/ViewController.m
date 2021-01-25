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
    _kbSlider.minimumTrackTintColor = [UIColor orangeColor];
}


- (void)sliderValueChanges:(KBSlider *)slider {
    _valueLabel.text = [NSString stringWithFormat:@"%f", slider.value];
}

- (void)toggleMode:(id)sender {
    if (self.kbSlider.sliderMode == KBSliderModeDefault){
        self.kbSlider.sliderMode = KBSliderModeTransport;
        [self.kbSlider setTotalDuration:120];
        [self.kbSlider setCurrentTime:1.0];
        [self startTimer];
    } else {
        self.kbSlider.sliderMode = KBSliderModeDefault;
        [self stopTimer];
    }
}

- (void)startTimer {
    [self stopTimer];
    self.simulatedPlaybackTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:true block:^(NSTimer * _Nonnull timer) {
        if (self.kbSlider.currentTime+1 <= self.kbSlider.totalDuration){
            self.kbSlider.currentTime++;
        } else {
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

@end
