//
//  VBAppDelegate.h
//  Loca2
//
//  Created by Vitaliy Berg on 5/10/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface VBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) CLLocationManager *locationManager;

+ (VBAppDelegate *)sharedDelegate;

@end
