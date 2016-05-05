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
#include <sys/sysctl.h>
//#import "LocationObject.h"

@interface SegmentIOTracker ()

@property (nonatomic, copy) NSString *writeKey;
@property (nonatomic, strong) NSMutableArray *pendingEvents;
@property (nonatomic) BOOL isObtainingLocation;

@end

@implementation SegmentIOTracker

- (id)initWithWriteKey:(NSString *)writeKey {
    if (self = [super init]) {
        _writeKey = [writeKey copy];
        _pendingEvents = [NSMutableArray array];
        _isObtainingLocation = NO;
    }
    return self;
}

- (void)track:(NSString *)event properties:(NSDictionary *)properties {
    
    // if no location, save this event to array;
    // return
    
    if ( ! _context) {
        if(!_isObtainingLocation){
            _isObtainingLocation = YES;
            NSURLRequest *locationRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://ip-api.com/json"]];
            
//            [[self class] sendRequest:locationRequest completion:^(NSDictionary *response, NSError *error) {
//                NSLog(@"Segment: response %@ error %@", response, error);
//                
//                if(!error){
//                    _context =  [NSDictionary dictionaryWithDictionary:response];
//                    NSLog(@"%@", _context);
//                }else{
//                    _isObtainingLocation = NO;
//                }
//            }];
            
            __weak __typeof (self) weakSelf = self;
            NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:locationRequest
                                                                         completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

                                                                             NSError *parseError;
                                                                             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                                  options:0
                                                                                                                                    error:&parseError];
                                                                             
                                                                             if(!parseError){
                                                                                 _context =  [NSDictionary dictionaryWithDictionary:dict];
                                                                                 [weakSelf handlePendingRequests];
                                                                             }else{
                                                                                 _isObtainingLocation = NO;
                                                                             }
                                                                             
                                                                         }];
            [task resume];
        }
        [_pendingEvents addObject:@{
                                    @"event": event,
                                    @"properties": properties
                                    }];
        
        return;
    } else {
        [self handlePendingRequests];
    }
    
    // then
    NSURLRequest *request = [[self class] trackingRequestWithEvent:event
                                                          writeKey:self.writeKey
                                                            userID:self.uuid
                                                           context:self.context
                                                        properties:properties];
    [[self class] sendRequest:request completion:^(NSDictionary *response, NSError *error) {
        NSLog(@"Segment: response %@ error %@", response, error);
    }];
}

- (NSArray<NSURLRequest *> *)preparedRequests {
    NSMutableArray<NSURLRequest *> *pendingRequests = [[NSMutableArray alloc] init];
    
    for (NSDictionary* event in _pendingEvents) {
        [pendingRequests addObject: [[self class] trackingRequestWithEvent:[event objectForKey:@"event"]
                                                                  writeKey:self.writeKey
                                                                    userID:self.uuid
                                                                   context:self.context
                                                                properties:[event objectForKey:@"properties"]]];
    }

    return pendingRequests;
}

- (void) handlePendingRequests{
    NSArray<NSURLRequest *> *requestList = [self preparedRequests];
    
    for (NSURLRequest* request in requestList) {
        [[self class] sendRequest:request completion:^(NSDictionary *response, NSError *error) {
            NSLog(@"Segment: response %@ error %@", response, error);
        }];
    }
    
    [_pendingEvents removeAllObjects];
}

@end

@implementation SegmentIOTracker (Internal)

+ (NSString *)basicAuthValueForUsername:(NSString *)username password:(NSString *)password {
    return [[NSString stringWithFormat:@"%@:%@", username ?: @"", password ?: @""] base64String];
}

+ (NSString *)getSystemStringForKey:(char*)ctlKey {
    size_t len = 0;
    sysctlbyname(ctlKey, NULL, &len, NULL, 0);
    
    if (len)
    {
        char *model = malloc(len*sizeof(char));
        sysctlbyname(ctlKey, model, &len, NULL, 0);
        free(model);
        
        return [NSString stringWithUTF8String:model];
    }
    
    return @"";
}

+ (NSMutableURLRequest *)trackingRequestWithEvent:(NSString *)event writeKey:(NSString *)key userID:(NSString *)userID context:(NSDictionary *)context3 properties:(NSDictionary *)properties {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.segment.io/v1/track"]];
    request.HTTPMethod = @"POST";
    NSString *base64 = [[self class] basicAuthValueForUsername:key password:nil];
    NSString *model_ns = @"";

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
        
#if DEBUG
        NSLog(@"here is debug");
        [context addEntriesFromDictionary:@{ @"app": @{
                                                     @"version": @"Debug does not have a version",
                                                     @"build": @"Debug does not have a version",
                                                     @"name": @"Debug does not have a version"
                                                     }}];
#else
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSAssert(mainBundle, @"main bundle should not be nil if it is not in debug mode");
        [context addEntriesFromDictionary:@{ @"app": @{
                                                     @"version": [mainBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                                                     @"build": [mainBundle objectForInfoDictionaryKey:@"CFBundleVersion"],
                                                     @"name": [mainBundle objectForInfoDictionaryKey:@"CFBundleName"]
                                                     }}];
#endif
        
        [context addEntriesFromDictionary:@{ @"device": @{
                                                     @"manufacturer": @"",
                                                     @"name": [[self class] getSystemStringForKey: "hw.model"],
                                                     @"model": [[self class] getSystemStringForKey: "hw.machine"]
                                                     }}];
        
        
        
        if(context3){
//            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//            f.numberStyle = NSNumberFormatterDecimalStyle;
            
            [context addEntriesFromDictionary:@{ @"location": @{
                                                         @"city": [context3 objectForKey:@"city"],
                                                         @"country": [context3 objectForKey:@"country"],
                                                         @"latitude": [context3 objectForKey:@"lat"],
                                                         @"longitude": [context3 objectForKey:@"lon"],
                                                         @"region": [context3 objectForKey:@"regionName"]
                                                         } }];
            
            [context addEntriesFromDictionary:@{ @"ip": [context3 objectForKey:@"query"] }];
        }
        
        [context addEntriesFromDictionary:@{ @"network":@{
                                                     @"wifi": @"",
                                                     @"cellular": @"",
                                                     @"carrier": @"",
                                                     @"bluetooth": @"",
                                                     } }];
        
        [context addEntriesFromDictionary:@{ @"os":@{
                                                     @"name": @"",
                                                     @"version": [[NSProcessInfo processInfo] operatingSystemVersionString]
                                                     } }];
        
//        [context addEntriesFromDictionary:@{ @"library":@{
//                                                     @"name": @"",
//                                                     @"version": @""
//                                                     } }];
        
//        NSBundle *pluginBundle = [NSBundle bundleForClass:NSClassFromString(@"MPPresenterController")];
//        NSAssert(pluginBundle, @"plugin bundle should not be nil");
//        NSLog(@"%@", pluginBundle);
//        [context addEntriesFromDictionary:@{ @"plugin":@{
//                                                     @"build": [pluginBundle objectForInfoDictionaryKey:@"CFBundleVersion"],
//                                                     @"environment": @"",
//                                                     @"version": [pluginBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
//                                                     } }];
        
        [context addEntriesFromDictionary:@{ @"mixpanelLibrary":@"" }];
        
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *timeString = [formatter stringFromDate:date];
        
        [dict addEntriesFromDictionary:@{
                                         @"context": context,
                                         @"sentAt": timeString
                                          }];
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
