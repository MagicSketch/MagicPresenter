//
//  Each.h
//  MagicSketch
//
//  Created by James Tang on 21/1/2016.
//
//

#import <Foundation/Foundation.h>

@interface Each <Object> : NSObject

@property (nonatomic, strong) NSArray <Object> *array;

- (instancetype)initWithArray:(NSArray <Object> *)array;

@end


@interface NSArray <Object> (Each)

@property (nonatomic, readonly) Object each;

@end