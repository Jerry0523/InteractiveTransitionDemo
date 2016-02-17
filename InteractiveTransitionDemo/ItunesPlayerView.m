//
//  ItunesPlayerView.m
//  InteractiveTransitionDemo
//
//  Created by Jerry on 16/2/3.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "ItunesPlayerView.h"
#import "AudioTool.h"
#import "PlayerDismissAnimator.h"
#import "PlayerPresentAnimator.h"

@interface ItunesPlayerView ()<UIViewControllerTransitioningDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImgView;
@property (weak, nonatomic) IBOutlet UIImageView *albumImgView;
@property (strong, nonatomic) UIPercentDrivenInteractiveTransition *dismissInteractiveTransition;
@property (strong, nonatomic) PlayerDismissAnimator *dismissAnimator;
@property (strong, nonatomic) PlayerPresentAnimator *presentAnimator;


@end

@implementation ItunesPlayerView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMetadataInfo];
    [self initGestureRecognizer];
    self.dismissAnimator = [PlayerDismissAnimator new];
    self.presentAnimator = [PlayerPresentAnimator new];
    self.transitioningDelegate = self;
}

- (void)initGestureRecognizer {
    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dealWithSwipe:)];
    swipe.direction = UISwipeGestureRecognizerDirectionDown;
    [mainWindow addGestureRecognizer:swipe];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dealWithPanGesture:)];
    pan.delegate = self;
    [pan requireGestureRecognizerToFail:swipe];
    [mainWindow addGestureRecognizer:pan];
}

- (void)initMetadataInfo {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"ForYourEntertainment" withExtension:@"m4a"];
    AudioFileID audioFile;
    OSStatus error = AudioFileOpenURL((__bridge CFURLRef)(url), kAudioFileReadPermission, kAudioFileM4AType, &audioFile);
    if (error == noErr) {
        NSDictionary *metadata = [AudioTool metadataForFile:audioFile];
        AudioFileClose(audioFile);
        NSData *imgData = metadata[@"picture"];
        UIImage *albumImg = [UIImage imageWithData:imgData];
        self.backgroundImgView.image = albumImg;
        self.albumImgView.image = albumImg;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)dismissPlayer:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealWithSwipe:(UISwipeGestureRecognizer*)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealWithPanGesture:(UIPanGestureRecognizer*)sender {
    CGFloat progress = [sender translationInView:self.view].y / ((self.view.bounds.size.height - 44));
    progress = MIN(1.0, MAX(0.0, progress));
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.dismissInteractiveTransition = [UIPercentDrivenInteractiveTransition new];
        self.dismissInteractiveTransition.completionCurve = UIViewAnimationCurveLinear;
        [self dismissPlayer:nil];
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        [self.dismissInteractiveTransition updateInteractiveTransition:progress];
    } else {
        if (progress >= 0.4) {
            [self.dismissInteractiveTransition finishInteractiveTransition];
        } else {
            [self.dismissInteractiveTransition cancelInteractiveTransition];
        }
        self.dismissInteractiveTransition = nil;
    }
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return self.presentAnimator;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self.dismissAnimator;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    return self.dismissInteractiveTransition;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator {
    return self.presentInteractiveTransition;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

@end
