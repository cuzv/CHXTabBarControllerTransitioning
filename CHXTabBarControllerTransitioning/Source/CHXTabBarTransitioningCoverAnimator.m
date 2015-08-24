//
//  CHXTabBarTransitioningCoverAnimator.m
//  CHXTabBarControllerTransitioning
//
//  Created by Moch Xiao on 7/7/15.
//  Copyright (c) 2015 Moch Xiao (https://github.com/cuzv).
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
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
