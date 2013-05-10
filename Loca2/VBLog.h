//
//  VBLog.h
//  Loca2
//
//  Created by Vitaliy Berg on 5/10/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *VBLogDidLogNotification;

@interface VBLog : NSObject

@property (nonatomic, strong, readonly) NSArray *logs;

- (void)log:(NSString *)text;

+ (VBLog *)sharedLog;

@end
