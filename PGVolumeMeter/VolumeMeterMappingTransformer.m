//
//  VolumeMeterMappingTransformer.m
//  Mastering
//
//  Created by Bryan Tung on 4/22/13.
//  Copyright (c) 2013 yikai. All rights reserved.
//

#import "VolumeMeterMappingTransformer.h"

@implementation VolumeMeterMappingTransformer

+ (VolumeMeterMappingTransformer *)createWithMappingDictionary:(NSArray *)arrayDictionary
{
    VolumeMeterMappingTransformer *transformer = [[VolumeMeterMappingTransformer alloc] init];
    [transformer setDbToScaleMapping:arrayDictionary];
    return transformer;
}

- (id)init
{
    self = [super init];
    if (self) {
        // BT: default range db:-12.0f~12.0f, scale:0.0f~1.0f
        // @[@[@(-12.0f),@(0.0f)], @[@(12.0f),@(1.0f)]];
        self.minimum = -12.0f;
        self.maximum = 12.0f;
        NSArray *defaultMapping = @[
                                    @[@(self.minimum),@(0.0f)],
                                    @[@(self.maximum),@(1.0f)]
                                    ];
        self.dbToScaleMapping = defaultMapping;
    }
    return self;
}

- (void)setDbToScaleMapping:(NSArray *)dbToScaleMapping
{
    if (_dbToScaleMapping) {
        _dbToScaleMapping = nil;
    }
    _dbToScaleMapping = [self _sortMappingWithMappingArray:dbToScaleMapping];
    self.minimum = [[_dbToScaleMapping objectAtIndex:0][0] floatValue];
    self.maximum = [[_dbToScaleMapping lastObject][0] floatValue];
}

- (void)setDbValue:(float)value atScale:(float)scale
{
    scale = MIN(MAX(0.0f, scale),1.0f); // 0.0f <= scale <= 1.0f
    NSMutableArray *newArray = [NSMutableArray arrayWithArray:_dbToScaleMapping];
    [newArray addObject:@[@(value),@(scale)]];
    self.dbToScaleMapping = (NSArray *)newArray;
    newArray = nil;
}

- (NSArray *)_sortMappingWithMappingArray:(NSArray *)sortArray
{
    // sort with ascending order, ex: @[ @[@(-12.0f),@(0.0f)], @[@(0.0f),@(0.5f)], @[@(12.0f),@(1.0f)] ]
    NSArray *sortedArray = [sortArray sortedArrayUsingComparator:^NSComparisonResult(NSArray *item1, NSArray *item2){
        if ([item1[0] floatValue]>[item2[0] floatValue]) {
            return 1;
        } else if ([item1[0] floatValue]<[item2[0] floatValue]) {
            return -1;
        }
        return 0;
    }];
    return sortedArray;
}

- (float)scaleForDb:(float)dbValue
{
    if (dbValue>self.maximum) {
        return 1.0f;
    }
    if (dbValue<self.minimum) {
        return 0.0f;
    }
    __block float minScale = 0.0f;
    __block float maxScale = 1.0f;
    __block float minDb = _minimum;
    __block float maxDb = _maximum;
    // range finder
    [_dbToScaleMapping enumerateObjectsUsingBlock:^(NSArray *item, NSUInteger idx, BOOL *stop){
        if ([item[0] floatValue]<dbValue) {
            minScale = [item[1] floatValue];
            minDb = [item[0] floatValue];
        }
        if ([item[0] floatValue]>=dbValue) {
            maxScale = [item[1] floatValue];
            maxDb = [item[0] floatValue];
            *stop = YES;
        }
    }];
    return minScale+((dbValue-minDb)/(maxDb-minDb))*(maxScale-minScale);
}

- (float)dbForScale:(float)scale
{
    __block float minScale = 0.0f;
    __block float maxScale = 1.0f;
    __block float minDb = _minimum;
    __block float maxDb = _maximum;
    [_dbToScaleMapping enumerateObjectsUsingBlock:^(NSArray *item, NSUInteger idx, BOOL *stop){
        if ([item[1] floatValue]<scale) {
            minScale = [item[1] floatValue];
            minDb = [item[0] floatValue];
        }
        if ([item[1] floatValue]>=scale) {
            maxScale = [item[1] floatValue];
            maxDb = [item[0] floatValue];
            *stop = YES;
        }
    }];
    return minDb+((scale-minScale)/(maxScale-minScale))*(maxDb-minDb);
}

@end
