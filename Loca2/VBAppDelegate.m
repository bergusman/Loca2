//
//  VBAppDelegate.m
//  Loca2
//
//  Created by Vitaliy Berg on 5/10/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "VBAppDelegate.h"
#import "VBLog.h"

@interface VBAppDelegate () <CLLocationManagerDelegate>

@end

@implementation VBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    return YES;
}

#pragma mark - Local Notifications

- (void)postLocalNotificationWithText:(NSString *)text {
    UILocalNotification *localNotifiation = [[UILocalNotification alloc] init];
    localNotifiation.alertBody = text;
    localNotifiation.soundName = @"Piano Riff Long";
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotifiation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    [[VBLog sharedLog] log:[NSString stringWithFormat:@"didStart: %@", region]];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    [[VBLog sharedLog] log:[NSString stringWithFormat:@"didEnter: %@", region]];
    [self postLocalNotificationWithText:[NSString stringWithFormat:@"Did enter %@", region.identifier]];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    [[VBLog sharedLog] log:[NSString stringWithFormat:@"didExit: %@", region]];
    [self postLocalNotificationWithText:[NSString stringWithFormat:@"Did exit %@", region.identifier]];
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    [[VBLog sharedLog] log:[NSString stringWithFormat:@"didFail: %@ %@", region, error]];
}

#pragma mark - Singleton

+ (VBAppDelegate *)sharedDelegate {
    return (VBAppDelegate *)[UIApplication sharedApplication].delegate;
}

@end
