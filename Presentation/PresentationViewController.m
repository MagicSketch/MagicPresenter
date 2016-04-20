//
//  PresentationViewController.m
//  PluginController
//
//  Created by James Tang on 18/4/2016.
//  Copyright © 2016 Magic Mirror. All rights reserved.
//

#import "PresentationViewController.h"
#import "NSWindow+FullScreenMode.h"

@interface PresentationViewController ()

@property (weak) IBOutlet NSImageView *imageView;
@property (weak) IBOutlet NSButton *leftSideButton;
@property (weak) IBOutlet NSButton *rightSideButton;
@property (nonatomic, strong) NSArray *slides;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) CGSize size;

@end

@implementation PresentationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.

//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.view.window toggleFullScreen:nil];
//    });

    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [NSColor blackColor].CGColor;

    self.leftSideButton.focusRingType = NSFocusRingTypeNone;
    self.rightSideButton.focusRingType = NSFocusRingTypeNone;
}

- (void)viewWillAppear {
    [super viewWillAppear];
    [self centerWindow];
}

- (void)reloadData {
    NSImage *image = [_slides[_index] image];
    self.imageView.image = image;
    self.size = image.size;
}

- (void)setSlides:(NSArray *)slides atIndex:(NSUInteger)index {
    self.slides = slides;
    self.index = index;
    [self reloadData];
}

- (void)centerWindow {
    NSWindow *window = self.view.window;
    CGFloat xPos = NSWidth([[window screen] frame])/2 - _size.width/2;
    CGFloat yPos = NSHeight([[window screen] frame])/2 - _size.height/2;
    [window setFrame:NSMakeRect(xPos, yPos, _size.width, _size.height) display:YES];
}

- (void)keyDown:(NSEvent *)theEvent {
    NSLog(@"keyDown %@", theEvent);
    switch (theEvent.keyCode) {
        case 126: // Up
        case 123: // Left
            [self goPreviousPage];
            break;
        case 125: // Down
        case 124: // Right
            [self goNextPage];
            break;
        case 53: // Esc
            if ([self.view.window mn_isFullScreen]) {
                [self.view.window toggleFullScreen:nil];
            }
            break;
        case 36: // Enter
            if ((theEvent.modifierFlags & NSCommandKeyMask) == NSCommandKeyMask) {
                [self.view.window toggleFullScreen:nil];
            }
            break;
        default:
            break;
    }
}

- (void)goPreviousPage {
    if (_index + 1 < _slides.count) {
        _index++;
        [self reloadData];
    }
}

- (void)goNextPage {
    if (_index - 1 >= 0) {
        _index--;
        [self reloadData];
    }
}

#pragma mark Actions

- (IBAction)leftSideButtonDidPress:(id)sender {
    [self goPreviousPage];
}

- (IBAction)rightSideButtonDidPress:(id)sender {
    [self goNextPage];
}

@end
