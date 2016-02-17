//
//  ViewController.m
//  InteractiveTransitionDemo
//
//  Created by Jerry on 16/2/3.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "ITunesTabViewController.h"
#import "DemoContentVC.h"
#import "ItunesPlayerView.h"



@interface ITunesTabViewController ()<UIViewControllerTransitioningDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *controlView;
@property (strong, nonatomic) ItunesPlayerView *playerVC;

@end

@implementation ITunesTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTabs];
    [self initOverallPlayControl];
}

- (void)initTabs {
    NSArray *titles = @[@"为你推荐", @"新内容", @"广播", @"Connect", @"我的音乐"];
    NSArray *iconTitles = @[@"iHeart", @"iStar", @"iRadio", @"iAt", @"iMusic"];
    

    NSMutableArray *mutableControllers = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        UIViewController *controller = [DemoContentVC new];
        UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:controller];
        naviController.tabBarItem.title = titles[i];
        naviController.tabBarItem.image = [UIImage imageNamed:iconTitles[i]];
        [mutableControllers addObject:naviController];
    }
    self.viewControllers = mutableControllers;
}

- (void)initOverallPlayControl {
    self.controlView = [[[NSBundle mainBundle] loadNibNamed:@"ITunesOverallPlayerView" owner:nil options:nil] firstObject];
    self.controlView.tag = OverallPlayerViewTag;
    
    self.controlView.frame = CGRectMake(0, CGRectGetMinY(self.tabBar.frame) - CGRectGetHeight(self.controlView.frame), CGRectGetWidth(self.controlView.frame), CGRectGetHeight(self.controlView.frame));
    
    [self.view insertSubview:self.controlView belowSubview:self.tabBar];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPlayer)];
    [self.controlView addGestureRecognizer:tap];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showPlayer)];
    swipe.direction = UISwipeGestureRecognizerDirectionUp;
    [self.controlView addGestureRecognizer:swipe];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dealWithPanGesture:)];
    pan.delegate = self;
    [pan requireGestureRecognizerToFail:swipe];
    [self.controlView addGestureRecognizer:pan];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (ItunesPlayerView*)playerVC {
    if (!_playerVC) {
        _playerVC = [ItunesPlayerView new];
    }
    return _playerVC;
}

- (void)showPlayer {
    [self presentViewController:self.playerVC animated:YES completion:nil];
}

- (void)dealWithPanGesture:(UIPanGestureRecognizer*)sender {
    CGFloat progress = -1 * [sender translationInView:self.view].y / self.view.bounds.size.height;
    progress = MIN(1.0, MAX(0.0, progress));
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.playerVC.presentInteractiveTransition = [UIPercentDrivenInteractiveTransition new];
        self.playerVC.presentInteractiveTransition.completionCurve = UIViewAnimationCurveLinear;
        [self showPlayer];
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        [self.playerVC.presentInteractiveTransition updateInteractiveTransition:progress];
    } else {
        if (progress >= 0.4) {
            [self.playerVC.presentInteractiveTransition finishInteractiveTransition];
        } else {
            [self.playerVC.presentInteractiveTransition cancelInteractiveTransition];
        }
        self.playerVC.presentInteractiveTransition = nil;
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

@end
