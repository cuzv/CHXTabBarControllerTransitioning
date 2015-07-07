//
//  CHXTabBarTransitioningCoverAnimator.m
//  CHXTabBarControllerTransitioning
//
//  Created by Moch Xiao on 7/7/15.
//  Copyright (c) 2015 Moch Xiao. All rights reserved.
//

#import "CHXTabBarTransitioningCoverAnimator.h"

@interface CHXTabBarTransitioningCoverAnimator ()
@property (nonatomic, weak) UITabBarController *tabBarController;;
@end

@implementation CHXTabBarTransitioningCoverAnimator

- (instancetype)initWithTabBarViewController:(UITabBarController *)tabBarController {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    NSParameterAssert(tabBarController);
    _tabBarController = tabBarController;
    
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.5f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    // Get viewcontrollers
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // Setup toViewController frame
    CGRect toFinalFrame = [transitionContext finalFrameForViewController:toViewController];
    toViewController.view.frame = toFinalFrame;
    
    // Add target view to the container
    UIView *containerView = [transitionContext containerView];
    [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
    
    NSInteger fromIndex = [self.tabBarController.viewControllers indexOfObject:fromViewController];
    NSInteger toIndex = [self.tabBarController.viewControllers indexOfObject:toViewController];
    
    // Set toViewController animation init positon
    void(^animations)(void) = nil;
    if (fromIndex < toIndex) {
        toViewController.view.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(toViewController.view.bounds) * 0.3f, 0);
        animations = ^{
            toViewController.view.transform = CGAffineTransformIdentity;
            fromViewController.view.transform = CGAffineTransformMakeTranslation(-CGRectGetWidth(fromViewController.view.bounds), 0);
        };
    } else {
        toViewController.view.transform = CGAffineTransformMakeTranslation(-CGRectGetWidth(toViewController.view.bounds) * 0.3f, 0);
        animations = ^{
            toViewController.view.transform = CGAffineTransformIdentity;
            fromViewController.view.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(fromViewController.view.bounds), 0);
        };
    }
    
    // Run the animation
    UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction;
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
                        options:options
                     animations:animations
                     completion:^(BOOL finished) {
                         // If cancel animation, recover the toViewController's position
                         toViewController.view.transform = CGAffineTransformIdentity;
                         fromViewController.view.transform = CGAffineTransformIdentity;
                         
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
}

@end
