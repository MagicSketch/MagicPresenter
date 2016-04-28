//
//  PresentationWindow.m
//  MPPresentation
//
//  Created by James Tang on 18/4/2016.
//  Copyright © 2016 Magic Mirror. All rights reserved.
//

#import "MPPresentationWindow.h"

@implementation MPPresentationWindow

- (BOOL)canBecomeMainWindow {
    return YES;
}

- (BOOL)canBecomeKeyWindow {
    return YES;
}

@end
