//
//  NSWindow+FullScreenMode.m
//  Presentation
//
//  Created by James Tang on 21/4/2016.
//  Copyright © 2016 Magic Mirror. All rights reserved.
//

#import "NSWindow+FullScreenMode.h"

@implementation NSWindow (FullScreenMode)

- (BOOL)mn_isFullScreen
{
    return (([self styleMask] & NSFullScreenWindowMask) == NSFullScreenWindowMask);
}

@end
