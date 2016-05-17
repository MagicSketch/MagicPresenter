//
//  PresentationViewController.m
//  PluginController
//
//  Created by James Tang on 18/4/2016.
//  Copyright © 2016 Magic Mirror. All rights reserved.
//

#import "MPPresentationViewController.h"
#import "NSWindow+FullScreenMode.h"
#import "TrackerManager.h"
#import "MPHelper.h"

@interface MPPresentationViewController ()

@property (weak) IBOutlet NSImageView *imageView;
@property (weak) IBOutlet NSButton *leftSideButton;
@property (weak) IBOutlet NSButton *rightSideButton;
@property (nonatomic, strong) NSArray *slides;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) CGSize size;

@end

@implementation MPPresentationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.

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

- (void)mouseMoved:(NSEvent *)theEvent {
    [super mouseMoved:theEvent];
    DLog(@"controller mouseMoved");
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(becomesIdle:) object:self];
    [self performSelector:@selector(becomesIdle:) withObject:self afterDelay:2];
}

- (void)keyDown:(NSEvent *)theEvent {
    DLog(@"keyDown %@", theEvent);
    NSString *string = [theEvent charactersIgnoringModifiers];

    if ([string length] > 0) {
        unichar key = [string characterAtIndex:0];
        DLog(@"key %d", key);

        switch (key) {
            case NSUpArrowFunctionKey: // Up
                [[TrackerManager sharedInstance] track:@"Press UpArrow" properties:nil];
                [self goPreviousPage];
                break;
            case NSLeftArrowFunctionKey: // Left
                [[TrackerManager sharedInstance] track:@"Press LeftArrow" properties:nil];
                [self goPreviousPage];
                break;
            case NSDownArrowFunctionKey: // Down
                [[TrackerManager sharedInstance] track:@"Press DownArrow" properties:nil];
                [self goNextPage];
                break;
            case NSRightArrowFunctionKey: // Right
                [[TrackerManager sharedInstance] track:@"Press RightArrow" properties:nil];
                [self goNextPage];
                break;
            case 27: // Esc
                [[TrackerManager sharedInstance] track:@"Press Esc" properties:nil];
                if ([self isFullScreen]) {
                    [self exitFullScreen];
                } else {
                    [self exitWindow];
                }
                break;
            case 13: // Enter
                [[TrackerManager sharedInstance] track:@"Press Enter" properties:nil];
                if ((theEvent.modifierFlags & NSCommandKeyMask) == NSCommandKeyMask) {
                    [self goFullScreen];
                }
                break;
            default:
                break;
        }
    }

}

- (BOOL)isFullScreen {
    return [self.view.window mn_isFullScreen];
}

- (void)goFullScreen {
    if ( ! [self.view.window mn_isFullScreen]) {
        [self.view.window toggleFullScreen:nil];
        [self performSelector:@selector(becomesIdle:) withObject:self afterDelay:2];
    }
}

- (void)exitFullScreen {
    if ([self.view.window mn_isFullScreen]) {
        [self.view.window toggleFullScreen:nil];
    }
}

- (void)exitWindow {
    [self.view.window close];

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

- (void)becomesIdle:(id)sender {
    DLog(@"becomesIdle");
    if ([self isFullScreen]) {
        [NSCursor setHiddenUntilMouseMoves:YES];
    }
}

#pragma mark Actions

- (IBAction)leftSideButtonDidPress:(id)sender {
    [[TrackerManager sharedInstance] track:@"Click OverlayLeftButton" properties:nil];
    [self goPreviousPage];
}

- (IBAction)rightSideButtonDidPress:(id)sender {
    [[TrackerManager sharedInstance] track:@"Click OverlayRightButton" properties:nil];
    [self goNextPage];
}

@end
