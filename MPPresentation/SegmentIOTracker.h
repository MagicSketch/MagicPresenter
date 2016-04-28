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

@property (nonatomic, copy) NSString *writeKey;

+ (NSString *)basicAuthValueForUsername:(NSString *)username password:(NSString *)password;
+ (NSMutableURLRequest *)trackingRequestWithWriteKey:(NSString *)key
                                              userID:(NSString *)userID
                                          properties:(NSDictionary *)properties;
+ (void)sendRequest:(NSURLRequest *)request completion:(SegmentIOTrackerRequestCompletion)completion;

@end
