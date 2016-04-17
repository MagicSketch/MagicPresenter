//
//  PresentationController.m
//  PluginController
//
//  Created by James Tang on 18/4/2016.
//  Copyright © 2016 Magic Mirror. All rights reserved.
//

#import "PresentationController.h"
#import "PresentationViewController.h"

@interface PresentationController ()

@property (nonatomic, strong) NSWindowController *window;
@property (nonatomic, strong) PresentationViewController *controller;

@end

@implementation PresentationController

- (BOOL)launchWithSlides:(NSArray *)slides atIndex:(NSUInteger)index {
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:@"Presentation" bundle:[NSBundle bundleForClass:[self class]]];
    NSWindowController *window = [storyboard instantiateInitialController];
    PresentationViewController *controller = (PresentationViewController *)window.contentViewController;
    controller.slides = slides;
    _controller = controller;
    _window = window;
    [window showWindow:window.window];
    return YES;
}

@end
