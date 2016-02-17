//
//  PlayerDismissAnimator.m
//  InteractiveTransitionDemo
//
//  Created by Jerry on 16/2/3.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "PlayerDismissAnimator.h"
#import "ITunesTabViewController.h"

@implementation PlayerDismissAnimator

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.5f;
}

#pragma mark - From PlayerView To TabView
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    ITunesTabViewController *to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = [transitionContext containerView];
    
    UIView *transitionOveralControl = [to.view viewWithTag:OverallPlayerViewTag];
    UITabBar *transitionBar = to.tabBar;
    
    transitionOveralControl.transform = CGAffineTransformMakeTranslation(0, -1 * CGRectGetMaxY(transitionOveralControl.frame));

    transitionBar.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(transitionBar.frame));
    
    from.view.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(transitionOveralControl.frame));
    
    
    [container addSubview:to.view];
    [from.view removeFromSuperview];
    [transitionOveralControl addSubview:from.view];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:duration animations:^{
        transitionOveralControl.transform = CGAffineTransformIdentity;
        transitionBar.transform = CGAffineTransformIdentity;

    } completion:^(BOOL finished) {
        
        transitionOveralControl.transform = CGAffineTransformIdentity;
        transitionBar.transform = CGAffineTransformIdentity;
        from.view.transform = CGAffineTransformIdentity;
        [from.view removeFromSuperview];
        
        BOOL canceled = [transitionContext transitionWasCancelled];
        
        if (canceled) {
            [container addSubview:from.view];
        }
        
        [transitionContext completeTransition:!canceled];
    }];
}

@end
