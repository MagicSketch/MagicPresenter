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

@end

@implementation SegmentIOTracker

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
    [request setValue:[@"Basic " stringByAppendingString:[[self class] basicAuthValueForUsername:key
                                                                                        password:nil]] forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict addEntriesFromDictionary:@{@"properties": properties}];
    [dict addEntriesFromDictionary:@{@"userId":userID}];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0
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
