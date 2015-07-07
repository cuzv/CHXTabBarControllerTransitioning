//
//  TabBarController.m
//  CHXTabBarControllerTransitioning
//
//  Created by Moch Xiao on 7/6/15.
//  Copyright (c) 2015 Moch Xiao. All rights reserved.
//

#import "TabBarController.h"
#import "CHXTabBarTransitioningAnimatorCarrier.h"

@interface TabBarController ()
@property (nonatomic, strong) CHXTabBarTransitioningAnimatorCarrier *carrier;
@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    self.carrier = [[CHXTabBarTransitioningAnimatorCarrier alloc] initWithTabBarController:self];
    self.carrier = [[CHXTabBarTransitioningAnimatorCarrier alloc] initWithTabBarController:self transitioningAnimatorStyle:CHXTabBarTransitioningAnimatorStyleRotate];
//    self.carrier.enablePanGestureRecognizer = NO;
    self.delegate = self.carrier;
}

@end
