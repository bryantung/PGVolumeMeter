//
//  PGVolumeMeter.h
//  PGVolumeMeter
//
//  Created by Bryan Tung on 4/17/13.
//  Copyright (c) 2013 positivegrid. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
	HorizontalRightMeter = 0,
    HorizontalLeftMeter,
    VerticalUpMeter,
	VerticalDownMeter
} volumeMeterOrientation;

@interface PGVolumeMeter:UIControl

@property (nonatomic, assign) float value;
@property (assign) float maximumValue;
@property (assign) float minimumValue;
@property (assign) int step;    // number of level meter blocks
@property (nonatomic, strong) UIImage *meterImage;
@property (nonatomic, strong) IBOutlet UIView *overflowIndication;
@property (assign) BOOL valueIsDB;  // default is scale 0.0~1.0

-(void)setMeterImage:(UIImage *)meterImage withOrientation:(volumeMeterOrientation)orientation withStep:(int)step;
-(float)currentPeak;
-(void)peakReset;
-(void)overflowReset;
-(BOOL)hasOverflown;

@end
