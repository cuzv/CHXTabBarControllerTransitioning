//
//  CHXTabBarTransitioningAnimatorCarrier.m
//  CHXTabBarControllerTransitioning
//
//  Created by Moch Xiao on 7/6/15.
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

#import "CHXTabBarTransitioningAnimatorCarrier.h"
#import "CHXTabBarTransitioningFlipAnimator.h"
#import "CHXTabBarTransitioningCoverAnimator.h"
#import "CHXTabBarTransitioningRotateAnimator.h"

@interface CHXTabBarTransitioningAnimatorCarrier () <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UITabBarController *tabBarController;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) id <UIViewControllerAnimatedTransitioning> transitioningAnimator;
@property (strong, nonatomic) UIPercentDrivenInteractiveTransition *interactiveTransition;

@end

@implementation CHXTabBarTransitioningAnimatorCarrier

- (instancetype)initWithTabBarController:(UITabBarController *)tabBarController {
    return [self initWithTabBarController:tabBarController transitioningAnimatorStyle:CHXTabBarTransitioningAnimatorStyleFlip];
}

- (instancetype)initWithTabBarController:(UITabBarController *)tabBarController transitioningAnimatorStyle:(CHXTabBarTransitioningAnimatorStyle)transitioningAnimatorStyle {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    NSParameterAssert(tabBarController);
    _tabBarController = tabBarController;
    
    [self commitInit];
    [self setupTransitioningAnimatorWithStyle:transitioningAnimatorStyle];
    
    return self;
}

- (void)commitInit {
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    _panGestureRecognizer.maximumNumberOfTouches = 1;
    _panGestureRecognizer.delegate = self;
    _panGestureRecognizer.enabled = YES;
    [_tabBarController.view addGestureRecognizer:_panGestureRecognizer];
}

- (void)setupTransitioningAnimatorWithStyle:(CHXTabBarTransitioningAnimatorStyle)transitioningAnimatorStyle {
    switch (transitioningAnimatorStyle) {
        case CHXTabBarTransitioningAnimatorStyleFlip:
            _transitioningAnimator = [[CHXTabBarTransitioningFlipAnimator alloc] initWithTabBarViewController:_tabBarController];
            break;
        case CHXTabBarTransitioningAnimatorStyleCover:
            _transitioningAnimator = [[CHXTabBarTransitioningCoverAnimator alloc] initWithTabBarViewController:_tabBarController];
            break;
        case CHXTabBarTransitioningAnimatorStyleRotate:
            _transitioningAnimator = [[CHXTabBarTransitioningRotateAnimator alloc] initWithTabBarViewController:_tabBarController];
            break;
        default:
            break;
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)sender {
    UIView *tabBarControllerView = self.tabBarController.view;
    UIGestureRecognizerState state = sender.state;

    CGFloat percentComplete = fabs([sender translationInView:tabBarControllerView].x / CGRectGetWidth(tabBarControllerView.bounds));
    if (state == UIGestureRecognizerStateBegan) {
        self.interactiveTransition = [UIPercentDrivenInteractiveTransition new];
        CGFloat velocityX = [sender velocityInView:tabBarControllerView].x;
        NSInteger currentSelectedIndex = self.tabBarController.selectedIndex;
        if (velocityX > 0) {
            // reverse
            self.tabBarController.selectedIndex = MAX(0, currentSelectedIndex - 1);
            self.tabBarController.selectedViewController = self.tabBarController.viewControllers[self.tabBarController.selectedIndex];
        } else {
            // forward
            self.tabBarController.selectedIndex = MAX(0, currentSelectedIndex + 1);
            self.tabBarController.selectedViewController = self.tabBarController.viewControllers[self.tabBarController.selectedIndex];
        }
    } else if (state == UIGestureRecognizerStateChanged) {
        [self.interactiveTransition updateInteractiveTransition:percentComplete];
    } else if (state == UIGestureRecognizerStateEnded) {
        if (fabs(percentComplete) > 0.5) {
            [self.interactiveTransition finishInteractiveTransition];
        } else {
            [self.interactiveTransition cancelInteractiveTransition];
        }
        self.interactiveTransition = nil;
    }
}

- (BOOL)enablePanGestureRecognizer {
    return self.panGestureRecognizer.enabled;
}

- (void)setEnablePanGestureRecognizer:(BOOL)enablePanGestureRecognizer {
    self.panGestureRecognizer.enabled = enablePanGestureRecognizer;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController NS_AVAILABLE_IOS(3_0) {
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
}

- (void)tabBarController:(UITabBarController *)tabBarController willBeginCustomizingViewControllers:(NSArray *)viewControllers NS_AVAILABLE_IOS(3_0) {

}

- (void)tabBarController:(UITabBarController *)tabBarController willEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed NS_AVAILABLE_IOS(3_0) {

}

- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {

}

- (id <UIViewControllerInteractiveTransitioning>)tabBarController:(UITabBarController *)tabBarController
                      interactionControllerForAnimationController: (id <UIViewControllerAnimatedTransitioning>)animationController NS_AVAILABLE_IOS(7_0) {
    return self.interactiveTransition;
}

- (id <UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController
            animationControllerForTransitionFromViewController:(UIViewController *)fromVC
                                              toViewController:(UIViewController *)toVC  NS_AVAILABLE_IOS(7_0) {
    return self.transitioningAnimator;
}

@end
