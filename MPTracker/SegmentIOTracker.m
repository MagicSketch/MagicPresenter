//
//  SegmentIOTracker.m
//  MagicPresenter
//
//  Created by James Tang on 28/4/2016.
//  Copyright © 2016 MagicSketch. All rights reserved.
//

#import "SegmentIOTracker.h"
#import "NSString+MD5.h"
#import <AppKit/AppKit.h>

@interface SegmentIOTracker ()

@property (nonatomic, copy) NSString *writeKey;

@end

@implementation SegmentIOTracker

- (id)initWithWriteKey:(NSString *)writeKey {
    if (self = [super init]) {
        _writeKey = [writeKey copy];
    }
    return self;
}

- (void)track:(NSString *)event properties:(NSDictionary *)properties {
    NSURLRequest *request = [[self class] trackingRequestWithEvent:event
                                                          writeKey:self.writeKey
                                                            userID:self.uuid
                                                        properties:properties];
    [[self class] sendRequest:request completion:^(NSDictionary *response, NSError *error) {
//        NSLog(@"Segment: response %@ error %@", response, error);
    }];
}


@end

@implementation SegmentIOTracker (Internal)

+ (NSString *)basicAuthValueForUsername:(NSString *)username password:(NSString *)password {
    return [[NSString stringWithFormat:@"%@:%@", username ?: @"", password ?: @""] base64String];
}

+ (NSMutableURLRequest *)trackingRequestWithEvent:(NSString *)event writeKey:(NSString *)key userID:(NSString *)userID properties:(NSDictionary *)properties {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.segment.io/v1/track"]];
    request.HTTPMethod = @"POST";
    NSString *base64 = [[self class] basicAuthValueForUsername:key password:nil];

    NSAssert(base64, nil);
    [request setValue:[@"Basic " stringByAppendingString:base64] forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (properties) {
        [dict addEntriesFromDictionary:@{@"properties": properties}];
    }
    NSAssert(event, @"event should not be nil");
    if (event) {
        [dict addEntriesFromDictionary:@{@"event":event}];
    }
    NSAssert(userID, @"userID should not be nil");
    if (userID) {
        [dict addEntriesFromDictionary:@{@"userId":userID}];
    }

    {
        NSMutableDictionary *context = [[NSMutableDictionary alloc] init];
        [context addEntriesFromDictionary:@{
                                            @"locale":[NSString stringWithFormat:
                                                       @"%@-%@",
                                                       [NSLocale.currentLocale objectForKey:NSLocaleLanguageCode],
                                                       [NSLocale.currentLocale objectForKey:NSLocaleCountryCode]]
                                            }];
        [context addEntriesFromDictionary:@{ @"timezone":[[NSTimeZone localTimeZone] name] }];
        
        CGRect screen = [[NSScreen mainScreen] frame];
        [context addEntriesFromDictionary:@{ @"screen": @{
                                                  @"width":@(screen.size.width),
                                                  @"height":@(screen.size.height),
                                                  @"density":@([[NSScreen mainScreen] backingScaleFactor])
                                                  }}];
        [dict addEntriesFromDictionary:@{ @"context": context }];
    }


    NSData *data = [NSJSONSerialization dataWithJSONObject:dict
                                                   options:0
                                                     error:nil];
    [request setHTTPBody:data];
    return request;
}

+ (void)sendRequest:(NSURLRequest *)request completion:(SegmentIOTrackerRequestCompletion)completion {
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                    completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

                                        NSError *parseError;
                                        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                                             options:0
                                                                                               error:&parseError];
                                        if (completion) {
                                            completion(dict, parseError ?: error);
                                        }

                                    }];
    [task resume];
}

+ (NSDictionary *)bodyForRequest:(NSURLRequest *)request {
    NSError *error;
    NSDictionary *expected = [NSJSONSerialization JSONObjectWithData:request.HTTPBody
                                                               options:0
                                                               error:&error];
    return expected;
}

@end
