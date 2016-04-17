//
//  PresentingItem.h
//  PluginController
//
//  Created by James Tang on 18/4/2016.
//  Copyright © 2016 Magic Mirror. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SlideLoadCompletion)(NSImage *image);

@protocol Slide

- (void)loadImage:(SlideLoadCompletion)completion;

@end
