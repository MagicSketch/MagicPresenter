//
//  PresentationController.m
//  PluginController
//
//  Created by James Tang on 18/4/2016.
//  Copyright © 2016 Magic Mirror. All rights reserved.
//

#import "MPPresentationController.h"
#import "MPPresentationViewController.h"

@interface MPPresentationController ()

@property (nonatomic, strong) NSWindowController *window;
@property (nonatomic, strong) MPPresentationViewController *controller;

@end

@implementation MPPresentationController

- (BOOL)launchWithSlides:(NSArray *)slides atIndex:(NSUInteger)index {
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:@"MPPresentation" bundle:[NSBundle bundleForClass:[self class]]];
    NSWindowController *window = [storyboard instantiateInitialController];
    MPPresentationViewController *controller = (MPPresentationViewController *)window.contentViewController;
    _controller = controller;
    [_controller setSlides:slides atIndex:index];
    _window = window;
    [window showWindow:window.window];
    return YES;
}

@end
