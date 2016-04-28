//
//  PresentationController.h
//  PluginController
//
//  Created by James Tang on 18/4/2016.
//  Copyright © 2016 Magic Mirror. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MPSlide;

@interface MPPresentationController : NSObject

- (BOOL)launchWithSlides:(NSArray *)slides atIndex:(NSUInteger)index;

@end
