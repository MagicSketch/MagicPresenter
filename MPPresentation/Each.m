//
//  Each.m
//  MagicSketch
//
//  Created by James Tang on 21/1/2016.
//
//

#import "Each.h"

@implementation Each

- (instancetype)initWithArray:(NSArray *)array {
  self = [super init];
  self.array = array;
  return self;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
  if (! [_array count]) {
    return;
  }
  [_array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    if ([obj respondsToSelector:[invocation selector]]) {
      [invocation invokeWithTarget:obj];
    }
  }];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
  __block NSMethodSignature *sign = nil;
  [_array enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    if ([obj respondsToSelector:aSelector]) {
      sign = [obj methodSignatureForSelector:aSelector];
      *stop = YES;
    }
  }];
  return sign;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
  __block BOOL respondsToSelector = NO;
  [_array enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    respondsToSelector = [obj respondsToSelector:aSelector];
    if (respondsToSelector == YES) {
      *stop = YES;
    }
  }];

  if ( ! respondsToSelector) {
    respondsToSelector = [super respondsToSelector:aSelector];
  }
  return respondsToSelector;
}

@end



@implementation NSArray (Each)

- (id)each {
  Each *each = [[Each alloc] initWithArray:self];
  return each;
}

@end
