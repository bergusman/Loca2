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
NSString *VBLogItemKey = @"VBLogItemKey";

@implementation VBLog {
    NSMutableArray *_logs;
}

- (void)log:(NSString *)text {
    NSDictionary *logItem = @{
        @"text": text,
        @"timestamp": [NSDate date]
    };
    
    [_logs addObject:logItem];
    [self saveLogs];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:VBLogDidLogNotification
                                                        object:nil
                                                      userInfo:@{VBLogItemKey: logItem}];
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
