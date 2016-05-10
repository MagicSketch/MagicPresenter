//
//  Event.h
//  MagicSketch
//
//  Created by James Tang on 22/1/2016.
//
//

#import <Foundation/Foundation.h>


@interface Event : NSObject

@property (nonnull, copy, nonatomic) NSString *name;
@property (nullable, copy, nonatomic) NSDictionary *properties;

+ (__nonnull instancetype)eventWithName:(NSString * _Nonnull)name properties:(NSDictionary * _Nonnull)properties;

@end
