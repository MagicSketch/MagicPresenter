//
//  TrackerPersister.h
//  MagicSketch
//
//  Created by James Tang on 28/1/2016.
//
//

#import <Foundation/Foundation.h>

@protocol TrackerPersister <NSObject>

- (void)setObject:(id)object forKey:(NSString *)key;
- (id)objectForKey:(NSString *)key;
- (void)removeObjectForKey:(id)aKey;

@end

@interface TrackerPersister : NSObject <TrackerPersister>

@end

@interface NSMutableDictionary (TrackerPersister) <TrackerPersister>


@end