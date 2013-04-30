//
//  PGVolumeMeter.m
//  PGVolumeMeter
//
//  Created by Bryan Tung on 4/17/13.
//  Copyright (c) 2013 positivegrid. All rights reserved.
//

#import "PGVolumeMeter.h"
#import <QuartzCore/QuartzCore.h>

@interface PGVolumeMeter(){
    float peakValue;
}

@property (nonatomic, strong) CALayer *upperMask;
@property (readonly) float currentPeak;
@property (nonatomic, strong) CALayer *peakMask;
@property (nonatomic, assign) volumeMeterOrientation orientation;

@end

@implementation PGVolumeMeter

- (float)dbValueToScale:(float)dbValue
{
    float scale = self.maximumValue-self.minimumValue;
    scale = (dbValue-self.minimumValue)/scale;  // linear scale
    return scale;
}

- (CALayer *)upperMask
{
    if (!_upperMask) {
        _upperMask = [CALayer layer];
        _upperMask.frame = self.bounds;
        _upperMask.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0].CGColor;
    }
    return _upperMask;
}

- (CALayer *)peakMask
{
    if (!_peakMask) {
        _peakMask = [CALayer layer];
        CGRect frame = self.bounds;
        if (_orientation==VerticalUpMeter||_orientation==VerticalDownMeter) {
            frame.size = CGSizeMake(frame.size.width, self.frame.size.height/_step);
        } else {
            frame.size = CGSizeMake(self.frame.size.width/_step, frame.size.height);
        }
        _peakMask.frame = frame;
        _peakMask.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0].CGColor;
    }
    return _peakMask;
}

- (void)_init
{
    self.step = 50;
    self.minimumValue = 0.0f;
    self.maximumValue = 1.0f;
    peakValue = self.minimumValue;
    self.orientation = VerticalUpMeter;
    self.valueIsDB = NO;
}

- (void)setMeterImage:(UIImage *)meterImage withOrientation:(volumeMeterOrientation)orientation withStep:(int)step
{
    self.step = step;
    self.meterImage = meterImage;
    self.orientation = orientation;
}

- (void)setOrientation:(volumeMeterOrientation)orientation
{
    _orientation = orientation;
    
    if (self.layer.mask) {
        [_peakMask removeFromSuperlayer];
        _peakMask = nil;
        [_upperMask removeFromSuperlayer];
        _upperMask = nil;
        [self.layer.mask removeFromSuperlayer];
        self.layer.mask = nil;
    }
    
    self.layer.mask = [CALayer layer];
    [self.layer.mask addSublayer:self.upperMask];
    [self.layer.mask addSublayer:self.peakMask];
}

// BT: auto detect orientation if orientation not specified through
// - (void)setMeterImage:(UIImage *)meterImage withOrientation:(volumeMeterOrientation)orientation
- (void)setMeterImage:(UIImage *)meterImage
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 1.0f);
    [meterImage drawInRect:self.bounds];
    [self setBackgroundColor:[UIColor colorWithPatternImage:UIGraphicsGetImageFromCurrentImageContext()]];
    UIGraphicsEndImageContext();
    if (meterImage.size.height>meterImage.size.width)
        self.orientation = VerticalUpMeter;
    else
        self.orientation = HorizontalRightMeter;
}

- (void)setOverflowIndication:(UIView *)overflowIndication
{
    _overflowIndication = overflowIndication;
    _overflowIndication.hidden = YES;
    UITapGestureRecognizer *tapReset = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(overflowReset)];
    [_overflowIndication addGestureRecognizer:tapReset];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) [self _init];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) [self _init];
    return self;
}

- (void)setValue:(float)value
{
    _value = MIN(MAX(value, self.minimumValue),self.maximumValue);
    if (value >= self.maximumValue) {
        [self _hasOverflown];
    }
    [self updateMeterValue];
}

- (void)updateMeterValue
{
    [CATransaction setDisableActions:YES];
    float totalSize = (_orientation==VerticalUpMeter||_orientation==VerticalDownMeter)?self.frame.size.height:self.frame.size.width;
    float stepSize = totalSize/_step;
    float maskSize = (_valueIsDB?[self dbValueToScale:_value]:_value)*totalSize;
    float maskStep = floorf(maskSize/stepSize);
    maskSize = maskStep*stepSize;
    
    CGRect frame = _upperMask.frame;
    switch (_orientation) {
        case VerticalUpMeter:
            frame.origin = CGPointMake(frame.origin.x, totalSize-maskSize);
            break;
            
        case VerticalDownMeter:
            frame.origin = CGPointMake(frame.origin.x, maskSize-totalSize);
            break;
            
        case HorizontalLeftMeter:
            frame.origin = CGPointMake(totalSize-maskSize, frame.origin.y);
            break;
            
        case HorizontalRightMeter:
            frame.origin = CGPointMake(maskSize-totalSize, frame.origin.y);
            break;
    }
    _upperMask.frame = frame;
    
    if (_value>=peakValue) {
        peakValue = MAX(peakValue,_value);
        CGRect peakFrame = _peakMask.frame;
        switch (_orientation) {
            case VerticalUpMeter:
                peakFrame.origin = CGPointMake(peakFrame.origin.x, totalSize-maskSize);
                break;
                
            case VerticalDownMeter:
                peakFrame.origin = CGPointMake(peakFrame.origin.x, maskSize-stepSize);
                break;
                
            case HorizontalLeftMeter:
                peakFrame.origin = CGPointMake(totalSize-maskSize, peakFrame.origin.y);
                break;
                
            case HorizontalRightMeter:
                peakFrame.origin = CGPointMake(maskSize-stepSize, peakFrame.origin.y);
                break;
        }
        _peakMask.frame = peakFrame;
    }
    [CATransaction setDisableActions:NO];
}

- (float)currentPeak
{
    return peakValue;
}

- (void)peakReset
{
    peakValue = self.minimumValue;
}

- (void)_hasOverflown
{
    if (self.overflowIndication) {
        _overflowIndication.hidden = NO;
    }
}

- (void)overflowReset
{
    if (self.overflowIndication) {
        _overflowIndication.hidden = YES;
        [self peakReset];
    }
}

- (BOOL)hasOverflown
{
    return !_overflowIndication.hidden;
}


@end
