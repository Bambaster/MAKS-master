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
@property (weak, nonatomic) IBOutlet UIImageView *imageView_Annotation;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_StckAnnotation;

@property (strong, nonatomic) IBOutlet UIView *container_News;
@property (strong, nonatomic) IBOutlet UIView *container_Meteo;
@property (strong, nonatomic) IBOutlet UIView *container_Other;
@property (strong, nonatomic) IBOutlet UIButton *button_ContainerNews;
@property (strong, nonatomic) IBOutlet UIButton *button_ContainerMeteo;
@property (strong, nonatomic) IBOutlet UIButton *button_ContainerOther;

@property (nonatomic, assign) BOOL isNews;
@property (nonatomic, assign) BOOL isMeteo;
@property (nonatomic, assign) BOOL isOther;


@end

@implementation MainViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    
    //устанавливаем булевые значения (по умолчанию, открыт контент с Новостями)
    self.isNews = YES;
    self.isMeteo = NO;
    self.isOther = NO;
    
    self.container_News.alpha = 1;
    self.container_Meteo.alpha = 0;
    self.container_Other.alpha = 0;
    
   
    //устанавливаем положение контентов с погодой и "другое" справа, за пределами экрана
    CGRect frame_Meteo = [self.container_Meteo frame];
    frame_Meteo.origin.x = frame_Meteo.origin.x + 600;
    self.container_Meteo.frame = frame_Meteo;
    
    CGRect frame_Other = [self.container_Other frame];
    frame_Other.origin.x = frame_Other.origin.x + 600;
    self.container_Other.frame = frame_Other;
    
    
    [self.button_ContainerNews addTarget:self action:@selector(action_ButtonNews) forControlEvents:UIControlEventTouchUpInside];
    [self.button_ContainerMeteo addTarget:self action:@selector(action_ButtonMeteo) forControlEvents:UIControlEventTouchUpInside];
    [self.button_ContainerOther addTarget:self action:@selector(action_ButtonOther) forControlEvents:UIControlEventTouchUpInside];
    
   
    
}


- (void) action_ButtonNews {
    //метод по нажатию на кнопку News
    
    if (self.isMeteo == YES) {
        //если открыт блок с погодой
        [UIView animateWithDuration:0.5 delay:0.00 usingSpringWithDamping:0.8 initialSpringVelocity:0.3 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
            
            CGRect frame_Meteo = [self.container_Meteo frame];
            frame_Meteo.origin.x = frame_Meteo.origin.x - 600;
            self.container_Meteo.frame = frame_Meteo;
            self.container_Meteo.alpha = 0;
            
            CGRect frame_News = [self.container_News frame];
            frame_News.origin.x = frame_News.origin.x - 600;
            self.container_News.frame = frame_News;
            self.container_News.alpha = 1;
            
            
            
        } completion:^(BOOL finished) {
            CGRect frame_Meteo = [self.container_Meteo frame];
            frame_Meteo.origin.x = frame_Meteo.origin.x +1200;
            self.container_Meteo.frame = frame_Meteo;
        }];
        
        self.isNews = YES;
        self.isMeteo = NO;
        
    }
    
    if (self.isOther == YES) {
        //если открыт блок "другое"
        
        [UIView animateWithDuration:0.5 delay:0.00 usingSpringWithDamping:0.8 initialSpringVelocity:0.3 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
            
            CGRect frame_Other = [self.container_Other frame];
            frame_Other.origin.x = frame_Other.origin.x - 600;
            self.container_Other.frame = frame_Other;
            self.container_Other.alpha = 0;
            
            CGRect frame_News = [self.container_News frame];
            frame_News.origin.x = frame_News.origin.x - 600;
            self.container_News.frame = frame_News;
            self.container_News.alpha = 1;
            
            
        } completion:^(BOOL finished) {
            CGRect frame_Other = [self.container_Other frame];
            frame_Other.origin.x = frame_Other.origin.x +1200;
            self.container_Other.frame = frame_Other;
        }];
        
        self.isNews = YES;
        self.isOther = NO;
    }
    
    
    
    
}

- (void) action_ButtonMeteo {
    //метод по нажатию на кнопку Meteo
    
    if (self.isNews == YES) {
        //если открыт блок с новостями
        [UIView animateWithDuration:0.5 delay:0.00 usingSpringWithDamping:0.8 initialSpringVelocity:0.3 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
            
            CGRect frame_News = [self.container_News frame];
            frame_News.origin.x = frame_News.origin.x - 600;
            self.container_News.frame = frame_News;
            self.container_News.alpha = 0;
            
            CGRect frame_Meteo = [self.container_Meteo frame];
            frame_Meteo.origin.x = frame_Meteo.origin.x - 600;
            self.container_Meteo.frame = frame_Meteo;
            self.container_Meteo.alpha = 1;
           
            
        } completion:^(BOOL finished) {
            CGRect frame_News = [self.container_News frame];
            frame_News.origin.x = frame_News.origin.x +1200;
            self.container_News.frame = frame_News;
        }];
        
        self.isMeteo = YES;
        self.isNews = NO;
    }
    
    if (self.isOther == YES) {
        //если открыт блок "другое"
        
        [UIView animateWithDuration:0.5 delay:0.00 usingSpringWithDamping:0.8 initialSpringVelocity:0.3 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
            
            CGRect frame_Other = [self.container_Other frame];
            frame_Other.origin.x = frame_Other.origin.x - 600;
            self.container_Other.frame = frame_Other;
            self.container_Other.alpha = 0;
            
            CGRect frame_Meteo = [self.container_Meteo frame];
            frame_Meteo.origin.x = frame_Meteo.origin.x - 600;
            self.container_Meteo.frame = frame_Meteo;
            self.container_Meteo.alpha = 1;
            
            
        } completion:^(BOOL finished) {
            CGRect frame_Other = [self.container_Other frame];
            frame_Other.origin.x = frame_Other.origin.x +1200;
            self.container_Other.frame = frame_Other;
        }];
        
        self.isMeteo = YES;
        self.isOther = NO;
    }
    


}

- (void) action_ButtonOther {
    //метод по нажатию на кнопку Other
    
    if (self.isNews == YES) {
        //если открыт блок с новостями
        [UIView animateWithDuration:0.5 delay:0.00 usingSpringWithDamping:0.8 initialSpringVelocity:0.3 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
            
            CGRect frame_News = [self.container_News frame];
            frame_News.origin.x = frame_News.origin.x - 600;
            self.container_News.frame = frame_News;
            self.container_News.alpha = 0;
            
            CGRect frame_Other = [self.container_Other frame];
            frame_Other.origin.x = frame_Other.origin.x - 600;
            self.container_Other.frame = frame_Other;
            self.container_Other.alpha = 1;
            
            
        } completion:^(BOOL finished) {
            CGRect frame_News = [self.container_News frame];
            frame_News.origin.x = frame_News.origin.x +1200;
            self.container_News.frame = frame_News;
        }];
        
        self.isOther = YES;
        self.isNews = NO;
        
    }
    
    if (self.isMeteo == YES) {
        //если открыт блок с погодой
        [UIView animateWithDuration:0.5 delay:0.00 usingSpringWithDamping:0.8 initialSpringVelocity:0.3 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
            
            CGRect frame_Meteo = [self.container_Meteo frame];
            frame_Meteo.origin.x = frame_Meteo.origin.x - 600;
            self.container_Meteo.frame = frame_Meteo;
            self.container_Meteo.alpha = 0;
            
            CGRect frame_Other = [self.container_Other frame];
            frame_Other.origin.x = frame_Other.origin.x - 600;
            self.container_Other.frame = frame_Other;
            self.container_Other.alpha = 1;
           
            
        } completion:^(BOOL finished) {
            CGRect frame_Meteo = [self.container_Meteo frame];
            frame_Meteo.origin.x = frame_Meteo.origin.x +1200;
            self.container_Meteo.frame = frame_Meteo;
        }];
        
        self.isOther = YES;
        self.isMeteo = NO;
        
    }

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




- (CGAffineTransform)transformWithDirection : (CGFloat) translateX TranslateY:(CGFloat) translateY Scale: (CGFloat) transcale
{
    
    CGAffineTransform transT = CGAffineTransformMakeTranslation(translateX, translateY);
    CGAffineTransform scaleT = CGAffineTransformMakeScale(transcale, transcale);
    CGAffineTransform conT = CGAffineTransformConcat(transT, scaleT);
    
    return conT;
}




@end
