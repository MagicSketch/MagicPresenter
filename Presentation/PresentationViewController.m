//
//  PresentationViewController.m
//  PluginController
//
//  Created by James Tang on 18/4/2016.
//  Copyright © 2016 Magic Mirror. All rights reserved.
//

#import "PresentationViewController.h"

@interface PresentationViewController ()
@property (weak) IBOutlet NSImageView *imageView;

@end

@implementation PresentationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view.window toggleFullScreen:nil];
    });
}

@end
