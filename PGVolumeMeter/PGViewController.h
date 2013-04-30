//
//  PGViewController.h
//  PGVolumeMeter
//
//  Created by Bryan Tung on 4/17/13.
//  Copyright (c) 2013 positivegrid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGVolumeMeter.h"

@interface PGViewController : UIViewController
@property (nonatomic, weak) IBOutlet PGVolumeMeter *meterVerticalUp;
@property (nonatomic, weak) IBOutlet PGVolumeMeter *meterHorizontalRight;
@property (nonatomic, weak) IBOutlet PGVolumeMeter *meterVerticalDown;
@property (nonatomic, weak) IBOutlet PGVolumeMeter *meterHorizontalLeft;
@end
