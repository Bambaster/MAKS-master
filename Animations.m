//
//  Animations.m
//  MAKS
//
//  Created by Lowtrack on 20.05.15.
//  Copyright (c) 2015 Vladimir Popov. All rights reserved.
//

#import "Animations.h"

@implementation Animations


//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------
- (void) animate_Show_Pin: (UIView *) pin  {
    
    CATransition *transitionAnimationPin = [CATransition animation];
    [transitionAnimationPin setType:kCATransitionFade];
    [transitionAnimationPin setSubtype:kCATransitionFromBottom];
    [transitionAnimationPin setDuration:0.3];
    [transitionAnimationPin setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [transitionAnimationPin setFillMode:kCAFillModeForwards];
    
    [pin.layer addAnimation:transitionAnimationPin forKey:@"FromRightAnimation"];
     pin.alpha = 1;
}
    //----------------------------------------------------------------------------------------
+ (void) animate_Show_Stick: (UIView *) stick {

    CATransition *transitionAnimationStick = [CATransition animation];
    [transitionAnimationStick setType:kCATransitionFade];
    [transitionAnimationStick setSubtype:kCATransitionFromLeft];
    [transitionAnimationStick setDuration:0.3];
    [transitionAnimationStick setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [transitionAnimationStick setFillMode:kCAFillModeForwards];
    
    [stick.layer addAnimation:transitionAnimationStick forKey:@"FromRightAnimation"];
    stick.alpha = 1;
}



//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------


- (void) showView : (UIView *) view  {
    
    CATransition *transitionAnimation3 = [CATransition animation];
    [transitionAnimation3 setType:kCATransitionFade];
    //    [transitionAnimation3 setSubtype:kCATransitionFromLeft];
    [transitionAnimation3 setDuration:0.4];
    [transitionAnimation3 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [transitionAnimation3 setFillMode:kCAFillModeForwards];
    
    [view.layer addAnimation:transitionAnimation3 forKey:@"FromRightAnimation"];
    view.alpha = 1;
}




- (void) hideView : (UIView *) view  {
    
    CATransition *transitionAnimation3 = [CATransition animation];
    [transitionAnimation3 setType:kCATransitionFade];
    [transitionAnimation3 setDuration:0.4];
    [transitionAnimation3 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [transitionAnimation3 setFillMode:kCAFillModeForwards];
    
    [view.layer addAnimation:transitionAnimation3 forKey:@"FromRightAnimation"];
    view.alpha = 0;
}

@end
