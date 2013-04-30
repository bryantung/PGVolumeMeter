//
//  VolumeMeterMappingTransformer.h
//  Mastering
//
//  Created by Bryan Tung on 4/22/13.
//  Copyright (c) 2013 yikai. All rights reserved.
//
//* BT: usage - **********************************************************************************
//  create in each controller to map db to scale on PGVolumeMeter
//  default is 1 segment, linear scale 0.0 ~ 1.0
//  ========
//  use + (VolumeMeterMappingTransformer *)createWithMappingDictionary:(NSArray *)arrayDictionary
//  to set mapping segment in bulk
//  ========
//  use - (void)setDbValue:(float)value atScale:(float)scale
//  to set individual segment
//  ========
//  use - (float)scaleForDb:(float)dbValue
//  to return scale (0.0~1.0) to draw level meter height for PGVolumeMeter
//  ========
//  use - (float)dbForScale:(float)scale
//  inverse of - (float)scaleForDb:(float)dbValue
//************************************************************************************************

#import <Foundation/Foundation.h>

@interface VolumeMeterMappingTransformer : NSObject

@property (nonatomic, assign) float maximum;
@property (nonatomic, assign) float minimum;
@property (nonatomic, strong) NSArray *dbToScaleMapping;

- (void)setDbValue:(float)value atScale:(float)scale;
+ (VolumeMeterMappingTransformer *)createWithMappingDictionary:(NSArray *)arrayDictionary;
- (float)scaleForDb:(float)dbValue;
- (float)dbForScale:(float)scale;

@end
