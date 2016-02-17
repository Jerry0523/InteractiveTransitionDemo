//
//  PlayerPresentAnimator.m
//  InteractiveTransitionDemo
//
//  Created by Jerry on 16/2/14.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "PlayerPresentAnimator.h"
#import "ITunesTabViewController.h"

@implementation PlayerPresentAnimator

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.5f;
}

#pragma mark - From TabView To PlayerView
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    ITunesTabViewController *from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = [transitionContext containerView];
    
    UIView *transitionOveralControl = [from.view viewWithTag:OverallPlayerViewTag];
    UITabBar *transitionBar = from.tabBar;
    
    to.view.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(transitionOveralControl.frame));
    
    [transitionOveralControl addSubview:to.view];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:duration animations:^{
        transitionOveralControl.transform = CGAffineTransformMakeTranslation(0, -1 * CGRectGetMaxY(transitionOveralControl.frame));
        
        transitionBar.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(transitionBar.frame));
        
    } completion:^(BOOL finished) {
        
        transitionOveralControl.transform = CGAffineTransformIdentity;
        transitionBar.transform = CGAffineTransformIdentity;
        to.view.transform = CGAffineTransformIdentity;
        [to.view removeFromSuperview];
        
        BOOL canceled = [transitionContext transitionWasCancelled];
        
        if (!canceled) {
            [container addSubview:to.view];
        }
        
        [transitionContext completeTransition:!canceled];
    }];
}


@end
