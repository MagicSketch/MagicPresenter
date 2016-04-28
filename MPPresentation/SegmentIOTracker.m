//
//  SegmentIOTracker.m
//  MagicPresenter
//
//  Created by James Tang on 28/4/2016.
//  Copyright © 2016 MagicSketch. All rights reserved.
//

#import "SegmentIOTracker.h"
#import "NSString+MD5.h"

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
    NSURLRequest *request = [[self class] trackingRequestWithWriteKey:self.writeKey
                                                               userID:self.uuid
                                                           properties:properties];
    [[self class] sendRequest:request completion:^(NSDictionary *response, NSError *error) {

    }];
}

+ (NSString *)basicAuthValueForUsername:(NSString *)username password:(NSString *)password {
    return [[NSString stringWithFormat:@"%@:%@", username ?: @"", password ?: @""] base64String];
}

+ (NSMutableURLRequest *)trackingRequestWithWriteKey:(NSString *)key userID:(NSString *)userID properties:(NSDictionary *)properties {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.segment.io/v1/track"]];
    request.HTTPMethod = @"POST";
    NSString *base64 = [[self class] basicAuthValueForUsername:key password:nil];

    NSAssert(base64, nil);
    [request setValue:[@"Basic " stringByAppendingString:base64] forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSAssert(properties, nil);
    if (properties) {
        [dict addEntriesFromDictionary:@{@"properties": properties}];
    }
    NSAssert(userID, nil);
    if (userID) {
        [dict addEntriesFromDictionary:@{@"userId":userID}];
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

@end
