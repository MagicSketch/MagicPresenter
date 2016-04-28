//
//  PresentationViewController.h
//  PluginController
//
//  Created by James Tang on 18/4/2016.
//  Copyright © 2016 Magic Mirror. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol MPSlide;

@interface MPPresentationViewController : NSViewController


- (void)setSlides:(NSArray *)slides atIndex:(NSUInteger)index;

@end
