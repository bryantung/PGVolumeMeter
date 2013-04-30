//
//  PGViewController.m
//  PGVolumeMeter
//
//  Created by Bryan Tung on 4/17/13.
//  Copyright (c) 2013 positivegrid. All rights reserved.
//

#import "PGViewController.h"
#import "VolumeMeterMappingTransformer.h"

@interface PGViewController ()
@property (nonatomic, strong) VolumeMeterMappingTransformer *volumeMeterTransformer;    // by default is 1 segment, linear from 0~1
@end

@implementation PGViewController

- (void)meterUpdateTimer
{
    float val = arc4random()%71;
    val -= 64;
    _meterVerticalUp.value = [_volumeMeterTransformer scaleForDb:val];
    _meterHorizontalLeft.value = [_volumeMeterTransformer scaleForDb:val];
    
    val = arc4random()%71;
    val -= 64;
    _meterHorizontalRight.value = [_volumeMeterTransformer scaleForDb:val];
    _meterVerticalDown.value = [_volumeMeterTransformer scaleForDb:val];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#if 0
    _volumeMeterTransformer = [[VolumeMeterMappingTransformer alloc] init];
#if 0
    [_volumeMeterTransformer setDbToScaleMapping:@[
                                                  @[@(6.0f),@(1.0f)],
                                                  @[@(0.0f),@(0.9f)],
                                                  @[@(-6.0f),@(0.8f)],
                                                  @[@(-24.0f),@(0.5f)],
                                                  @[@(-64.0f),@(0.0f)]
     ]];
#endif
#if 0
    [_volumeMeterTransformer setDbValue:6.0f atScale:1.0f];
    [_volumeMeterTransformer setDbValue:0.0f atScale:0.9f];
    [_volumeMeterTransformer setDbValue:-6.0f atScale:0.8f];
    [_volumeMeterTransformer setDbValue:-24.0f atScale:0.5f];
    [_volumeMeterTransformer setDbValue:-64.0f atScale:0.0f];
#endif
#endif
    
#if 1
    _volumeMeterTransformer = [VolumeMeterMappingTransformer createWithMappingDictionary:@[
                               @[@(6.0f),@(1.0f)],
                               @[@(0.0f),@(0.9f)],
                               @[@(-6.0f),@(0.8f)],
                               @[@(-24.0f),@(0.5f)],
                               @[@(-64.0f),@(0.0f)]
                               ]
                               ];
#endif
    
    [_meterVerticalUp setMeterImage:[UIImage imageNamed:@"meter-level-vertical.png"] withOrientation:VerticalUpMeter withStep:32];
    
    [_meterVerticalDown setMeterImage:[UIImage imageNamed:@"meter-level-vertical-x.png"] withOrientation:VerticalDownMeter withStep:32];
    
    [_meterHorizontalRight setMeterImage:[UIImage imageNamed:@"meter-level-horizontal.png"] withOrientation:HorizontalRightMeter withStep:32];
    
    [_meterHorizontalLeft setMeterImage:[UIImage imageNamed:@"meter-level-horizontal-x.png"] withOrientation:HorizontalLeftMeter withStep:32];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(meterUpdateTimer) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
