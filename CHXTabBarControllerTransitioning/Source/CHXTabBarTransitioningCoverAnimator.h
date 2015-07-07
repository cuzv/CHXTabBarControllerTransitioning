//
//  CHXTabBarTransitioningCoverAnimator.h
//  CHXTabBarControllerTransitioning
//
//  Created by Moch Xiao on 7/7/15.
//  Copyright (c) 2015 Moch Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHXTabBarTransitioningCoverAnimator : NSObject <UIViewControllerAnimatedTransitioning>

- (instancetype)initWithTabBarViewController:(UITabBarController *)tabBarController;

@end
