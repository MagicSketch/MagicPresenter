//
//  PresentationWindowController.m
//  MPPresentation
//
//  Created by James Tang on 18/4/2016.
//  Copyright © 2016 Magic Mirror. All rights reserved.
//

#import "MPPresentationWindowController.h"

@interface MPPresentationWindowController ()

@end

@implementation MPPresentationWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

    [self.window makeKeyAndOrderFront:self];
    });
}

@end
