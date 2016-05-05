//
//  SegmentIOTracker.h
//  MagicPresenter
//
//  Created by James Tang on 28/4/2016.
//  Copyright © 2016 MagicSketch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tracker.h"

typedef void(^SegmentIOTrackerRequestCompletion)(NSDictionary *response, NSError *error);

@interface SegmentIOTracker : Tracker

@property (nonatomic, copy, readonly) NSString *writeKey;
@property (nonatomic, copy) NSDictionary *context;
@property (nonatomic, readonly) BOOL isObtainingLocation;

- (id)initWithWriteKey:(NSString *)writeKey;
- (NSArray <NSURLRequest *> *)preparedRequests;
- (void) handlePendingRequests;
- (NSArray *)pendingEvents;

@end


@interface SegmentIOTracker (Internal)

// For Internals, exposed for Testing
+ (NSString *)basicAuthValueForUsername:(NSString *)username password:(NSString *)password;
+ (NSMutableURLRequest *)trackingRequestWithEvent:(NSString *)event
                                         writeKey:(NSString *)key
                                           userID:(NSString *)userID
                                          context:(NSDictionary *)context
                                       properties:(NSDictionary *)properties;
+ (void)sendRequest:(NSURLRequest *)request completion:(SegmentIOTrackerRequestCompletion)completion;
+ (NSDictionary *)bodyForRequest:(NSURLRequest *)request;
+ (NSString *)getSystemStringForKey:(char*)ctlKey;

@end
