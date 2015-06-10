//
//  BG_BlurView.m
//  ALCOMATH
//
//  Created by Lowtrack on 08.04.15.
//  Copyright (c) 2015 Vladimir Popov. All rights reserved.
//

#import "BG_BlurView.h"
#import "Animations.h"
#import "EIViewController.h"

@interface BG_BlurView ()

@property (nonatomic, strong) UIView * viewNews;

@end


@implementation BG_BlurView


- (void) setBlurView: (UIViewController *) controllerView bluredImage : (UIImage *) image View: (UIView *) view {
    
    self.viewNews = view;
    Animations * anim = [Animations new];
    self.imageView = [[UIImageView alloc] initWithFrame:controllerView.view.frame];
    self.imageView.image = image;
    [self.imageView addSubview:view];
    self.imageView.userInteractionEnabled = YES;
    self.imageView.alpha = 0;
    [controllerView.view addSubview:self.imageView];
    int64_t delayInSeconds = 10;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_MSEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [anim showView:self.imageView];
        
//        [controllerView.view addSubview: self.viewNews];

    });

    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.tapRecognizer setDelegate:self];
    [self.tapRecognizer setNumberOfTapsRequired:1];
    [self.imageView addGestureRecognizer:self.tapRecognizer];
    
}




- (void) dismiss_BG {
    
    Animations * anim = [Animations new];
    
    [anim hideView:self.imageView];
    
    int64_t delayInSeconds = 500;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_MSEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.imageView removeFromSuperview];
//        [NSNotificationCenter post_Notification:@"ChangeAlcoholPeriod"];
    });
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{

    
    [self dismiss_BG];

    
}

- (void) dealloc {
    
//    NSLog(@"dealloc");

}


@end
