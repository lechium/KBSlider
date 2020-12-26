//
//  ViewController.m
//  KBSlider
//
//  Created by Kevin Bradley on 12/25/20.
//  Copyright © 2020 nito. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

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

@end
