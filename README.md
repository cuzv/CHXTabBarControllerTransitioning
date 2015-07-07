
# How does it look like ?

<p align="left">
	<img src="./ScreenShoots/1.gif" width=30%">&nbsp;
	<img src="./ScreenShoots/3.gif" width=30%">&nbsp;
	<img src="./ScreenShoots/2.gif" width=30%">&nbsp;		
</p>

# How to use ?

```
	UITabBarController
	#import "CHXTabBarControllerTransitioning.h"
	
	...
	
    // self.carrier = [[CHXTabBarTransitioningAnimatorCarrier alloc] initWithTabBarController:self];
    self.carrier = [[CHXTabBarTransitioningAnimatorCarrier alloc] initWithTabBarController:self transitioningAnimatorStyle:CHXTabBarTransitioningAnimatorStyleCover];
	// self.carrier.enablePanGestureRecognizer = NO;
    self.delegate = self.carrier;
	
```

