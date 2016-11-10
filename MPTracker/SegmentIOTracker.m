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
@property (nonatomic, copy) NSDictionary *superProperties;

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
    // return;
    
    if ( ! _context) {
        if(!_isObtainingLocation){
            _isObtainingLocation = YES;
            NSURLRequest *locationRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://pro.ip-api.com/json/?key=XVLXbT9sFRPwcUv"]];
            // NSURLRequest *locationRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://ip-api.com/json"]];

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
                                                                             if(!parseError && !error){
                                                                                 _context =  [NSDictionary dictionaryWithDictionary:dict];
                                                                                 [weakSelf handlePendingRequests];
                                                                             }else{
                                                                                 // Skip getting location again and handle pending request
//                                                                                 _isObtainingLocation = NO;
                                                                                 
                                                                                 [weakSelf handlePendingRequests];
                                                                             }
                                                                             
                                                                         }];
            [task resume];
        }

        [_pendingEvents addObject:@{
                                    @"event": event,
                                    @"properties": properties,
                                    @"_date":[NSDate date]
                                    }];
        
        return;
    } else {
        [self handlePendingRequests];
    }
    
    // then
    NSMutableDictionary *fullProperties = [[NSMutableDictionary alloc] init];
    [fullProperties addEntriesFromDictionary:_superProperties];
    [fullProperties addEntriesFromDictionary:properties];
    NSURLRequest *request = [[self class] trackingRequestWithEvent:event
                                                              date:[NSDate date]
                                                          writeKey:self.writeKey
                                                            userID:self.uuid
                                                           context:self.context
                                                        properties:fullProperties];
    [[self class] sendRequest:request completion:^(NSDictionary *response, NSError *error) {
    }];
}

- (NSArray<NSURLRequest *> *)preparedRequests {
    NSMutableArray<NSURLRequest *> *pendingRequests = [[NSMutableArray alloc] init];
    
    for (NSDictionary* event in _pendingEvents) {
        NSMutableDictionary *fullProperties = [[NSMutableDictionary alloc] init];
        [fullProperties addEntriesFromDictionary:_superProperties];
        [fullProperties addEntriesFromDictionary:[event objectForKey:@"properties"]];
        [pendingRequests addObject: [[self class] trackingRequestWithEvent:[event objectForKey:@"event"]
                                                                      date:[event objectForKey:@"_date"]
                                                                  writeKey:self.writeKey
                                                                    userID:self.uuid
                                                                   context:self.context
                                                                properties:fullProperties]];

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

+ (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *formatter;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ( ! formatter) {
            formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
            NSLocale* posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            formatter.locale = posix;
        }
    });

    return formatter;
}

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
        // free(model);
   
        NSString *m = [NSString stringWithUTF8String:model];

        free(model);

        return m;
    }
    
    return @"";
}

+ (NSMutableURLRequest *)trackingRequestWithEvent:(NSString *)event
                                             date:(NSDate *)date
                                         writeKey:(NSString *)key
                                           userID:(NSString *)userID
                                          context:(NSDictionary *)context3
                                       properties:(NSDictionary *)properties {

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
    // NSAssert(userID, @"userID should not be nil");
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
        NSBundle *sketchBundle = [NSBundle bundleForClass:NSClassFromString(@"MSDocument")]; // Sketch App classes
        if ([[sketchBundle infoDictionary] count] > 0) {
            [context addEntriesFromDictionary:@{ @"app": @{
                                                         @"version": [sketchBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                                                         @"build": [sketchBundle objectForInfoDictionaryKey:@"CFBundleVersion"],
                                                         @"name": [sketchBundle objectForInfoDictionaryKey:@"CFBundleName"]
                                                         }}];
        } else {
            [context addEntriesFromDictionary:@{ @"app": @{
                                                         @"version": @"MSDocument not available",
                                                         @"build": @"MSDocument not available",
                                                         @"name": @"MSDocument not available",
                                                         }}];
        }

        [context addEntriesFromDictionary:@{ @"device": @{
                                                     @"manufacturer": @"",
                                                     @"name": [[self class] getSystemStringForKey: "hw.model"],
                                                     @"model": [[self class] getSystemStringForKey: "hw.machine"]
                                                     }}];
        
        
        if(context3){
//            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//            f.numberStyle = NSNumberFormatterDecimalStyle;
            
            [context addEntriesFromDictionary:@{ @"location": @{
                                                         @"city": [context3 objectForKey:@"city"] ?: @"",
                                                         @"country": [context3 objectForKey:@"country"] ?: @"",
                                                         @"latitude": [context3 objectForKey:@"lat"] ?: @"",
                                                         @"longitude": [context3 objectForKey:@"lon"] ?: @"",
                                                         @"region": [context3 objectForKey:@"regionName"] ?: @""
                                                         } }];
            
            [context addEntriesFromDictionary:@{ @"ip": [context3 objectForKey:@"query"]  ?: @""}];
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

        NSBundle *currentBundle = [NSBundle bundleForClass:[self class]];
        [context addEntriesFromDictionary:@{ @"library":@{
                                                     @"name": [currentBundle objectForInfoDictionaryKey:@"CFBundleName"],
                                                     @"version": [currentBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                                                     } }];

        [context addEntriesFromDictionary:@{ @"mixpanelLibrary":@"" }];
        
        NSString *timeString = [[self dateFormatter] stringFromDate:date];

        [dict addEntriesFromDictionary:@{
                                         @"context": context,
                                         @"timestamp":timeString,
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
