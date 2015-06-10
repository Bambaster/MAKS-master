//
//  BG_BlurView.h
//  ALCOMATH
//
//  Created by Lowtrack on 08.04.15.
//  Copyright (c) 2015 Vladimir Popov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BG_BlurView : NSObject <UIGestureRecognizerDelegate>



@property (nonatomic, assign) BOOL isAnonim;
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;




- (void) setBlurView: (UIViewController *) controllerView bluredImage : (UIImage *) image View: (UIView *) view;

@end
