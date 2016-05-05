//
//  NSMutableArray+Shuffle.m
//  MagicSketch
//
//  Created by James Tang on 19/2/2016.
//
//
// http://stackoverflow.com/questions/56648/whats-the-best-way-to-shuffle-an-nsmutablearray

#import "NSMutableArray+Shuffle.h"

@implementation NSMutableArray (Shuffle)

- (instancetype)shuffle
{
    NSUInteger count = [self count];
    if (count < 1) return self;
    for (NSUInteger i = 0; i < count - 1; ++i) {
        NSInteger remainingCount = count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
        [self exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
    return self;
}

@end
