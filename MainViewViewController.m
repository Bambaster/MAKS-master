//
//  MainViewViewController.m
//  MAKS
//
//  Created by Lowtrack on 20.05.15.
//  Copyright (c) 2015 Vladimir Popov. All rights reserved.
//

#import "MainViewViewController.h"
#import "UIView+MotionBlur.h"

@interface MainViewViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView_BG_View;
@property (weak, nonatomic) IBOutlet UIView *view_Annotation;
- (IBAction)actionTestAnimations:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_Annotation;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_StckAnnotation;



@end

@implementation MainViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    
    
}

- (void) setupView {
    isZoomed = NO;
    self.navigationController.navigationBar.hidden = YES;

//    [self.imageView_Annotation addSubview:self.imageView_StckAnnotation];
    
    self.imageView_Annotation.alpha = 1;
    
    UIImage * image_Annotation = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MainViewAnnotation" ofType:@"png"]];
    image_Annotation = [UIImage imageWithCGImage:image_Annotation.CGImage
                                                scale:image_Annotation.scale
                                          orientation:UIImageOrientationUpMirrored];
//    UIColor * tintColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.5];
//    self.imageView_BG_View.image = image_original;
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)actionTestAnimations:(id)sender {
    

    
    
    
//[self.imageView_Annotation enableBlurWithAngle:M_PI_2 completion:^{
//    
//    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0.3 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
//        if (!isZoomed) {
////            self.imageView_BG_View.transform = [self transformWithDirection:-50 TranslateY:-30 Scale: 2.75];
////            isZoomed = YES;
//        self.imageView_Annotation.frame = CGRectMake(self.view.bounds.size.width/2 - 50, self.view.bounds.size.height/2 - 100, self.imageView_Annotation.bounds.size.width, self.imageView_Annotation.bounds.size.height);
//        }
//        
//        else {
////            self.imageView_BG_View.transform = [self transformWithDirection:0 TranslateY:0 Scale: 1];
////            isZoomed = NO;
//            
//        }
//        
//
//    
//    } completion:^(BOOL finished) {
//        
//        [self showPinAnnotation];
//    }];
//}];


}




- (CGAffineTransform)transformWithDirection : (CGFloat) translateX TranslateY:(CGFloat) translateY Scale: (CGFloat) transcale
{
    
    CGAffineTransform transT = CGAffineTransformMakeTranslation(translateX, translateY);
    CGAffineTransform scaleT = CGAffineTransformMakeScale(transcale, transcale);
    CGAffineTransform conT = CGAffineTransformConcat(transT, scaleT);
    
    return conT;
}




@end
