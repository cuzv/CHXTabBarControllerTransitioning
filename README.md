
# How does it look like ?

<p align="left">
	<img src="./ScreenShoots/1.gif" width=40%">&nbsp;
</p>

# How to use ?

```
	UITabBarController
	#import "CHXTabBarControllerTransitioning.h"
	
	...
	
    self.carrier = [[CHXTabBarTransitioningAnimatorCarrier alloc] initWithTabBarController:self];
	// self.carrier.enablePanGestureRecognizer = NO;
    self.delegate = self.carrier;
	
```

