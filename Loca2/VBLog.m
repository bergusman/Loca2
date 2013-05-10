//
//  VBLog.m
//  Loca2
//
//  Created by Vitaliy Berg on 5/10/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "VBLog.h"

#define VBLogsKey @"VBLogs"

NSString *VBLogDidLogNotification = @"VBLogDidLogNotification";

@implementation VBLog {
    NSMutableArray *_logs;
}

- (void)log:(NSString *)text {
    [_logs addObject:text];
    [self saveLogs];
    [[NSNotificationCenter defaultCenter] postNotificationName:VBLogDidLogNotification
                                                        object:nil
                                                      userInfo:@{@"item":text}];
}

- (void)loadLogs {
    _logs = [[[NSUserDefaults standardUserDefaults] objectForKey:VBLogsKey] mutableCopy];
    if (!_logs) {
        _logs = [NSMutableArray array];
    }
}

- (void)saveLogs {
    [[NSUserDefaults standardUserDefaults] setObject:self.logs forKey:VBLogsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)init {
    self = [super init];
    if (self) {
        [self loadLogs];
    }
    return self;
}

#pragma mark - Singleton

+ (VBLog *)sharedLog {
    static VBLog *_sharedLog;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedLog = [[VBLog alloc] init];
    });
    return _sharedLog;
}

@end
