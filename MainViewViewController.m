//
//  MainViewViewController.m
//  MAKS
//
//  Created by Lowtrack on 20.05.15.
//  Copyright (c) 2015 Vladimir Popov. All rights reserved.
//

#import "MainViewViewController.h"
#import "UIView+MotionBlur.h"
#import "ASProgressPopUpView.h"
#import "BG_BlurView.h"


#define TAG_NEWS_CONTAINER 10
#define TAG_WATHER_CONTAINER 20
#define TAG_VIDEO_CONTAINER 30



@interface MainViewViewController ()<ASProgressPopUpViewDataSource>
@property (weak, nonatomic) IBOutlet ASProgressPopUpView *progressView;
@property (nonatomic, strong) BG_BlurView * blur;


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

@property (weak, nonatomic) IBOutlet UIView *viewTopBox;

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
    
    [self.viewTopBox.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.viewTopBox.layer setShadowOpacity:0.0];
    [self.viewTopBox.layer setShadowRadius:0.0];
    [self.viewTopBox.layer setShadowOffset:CGSizeMake(0.0, 0.0)];

    //подписываемся на нотификации
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setShadow) name:NEWS_IS_LOADED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProgress:) name:PROGRESS_UPDATE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showDetailNewsOverBlur:) name:SHOW_DETAIL_NEWS object:nil];


    
    
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
    
    self.blur = [BG_BlurView new];

    
}

- (void) dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (void) setupView {
    isZoomed = NO;
    self.navigationController.navigationBar.hidden = YES;
    
    self.progressView.popUpViewCornerRadius = 8.0;
    self.progressView.font = [UIFont fontWithName:MAIN_FONT_LIGHT size:18];

    self.progressView.progress = 0.0;
    self.progressView.dataSource = self;


//    [self.imageView_Annotation addSubview:self.imageView_StckAnnotation];
    
    self.imageView_Annotation.alpha = 1;
    
//    UIImage * image_Annotation = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MainViewAnnotation" ofType:@"png"]];
//    image_Annotation = [UIImage imageWithCGImage:image_Annotation.CGImage
//                                                scale:image_Annotation.scale
//                                          orientation:UIImageOrientationUpMirrored];
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



//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//



#pragma mark - Container View Animations 


- (void) setShadow {
    
    
    CATransition *transitionAnimationPin = [CATransition animation];
    [transitionAnimationPin setType:kCATransitionFade];
//    [transitionAnimationPin setSubtype:kCATransitionFromBottom];
    [transitionAnimationPin setDuration:0.3];
    [transitionAnimationPin setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [transitionAnimationPin setFillMode:kCAFillModeForwards];
    
    [self.viewTopBox.layer addAnimation:transitionAnimationPin forKey:@"FromRightAnimation"];
    [self.viewTopBox.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.viewTopBox.layer setShadowOpacity:10.8];
    [self.viewTopBox.layer setShadowRadius:15.0];
    [self.viewTopBox.layer setShadowOffset:CGSizeMake(8.3, 0.0)];

    
}



- (void) action_ButtonNews {
    //метод по нажатию на кнопку News
    
    if (self.isMeteo == YES) {
        //если открыт блок с погодой
        [self containerAnimations:self.container_News HideView:self.container_Meteo];

        self.isNews = YES;
        self.isMeteo = NO;
        
    }
    
    if (self.isOther == YES) {
        //если открыт блок "другое"
        [self containerAnimations:self.container_News HideView:self.container_Other];
        self.isNews = YES;
        self.isOther = NO;
    }
    
    
    
    
}

- (void) action_ButtonMeteo {
    //метод по нажатию на кнопку Meteo
    
    if (self.isNews == YES) {
        //если открыт блок с новостями

        [self containerAnimations:self.container_Meteo HideView:self.container_News];

        self.isMeteo = YES;
        self.isNews = NO;
    }
    
    if (self.isOther == YES) {
        //если открыт блок "другое"
        [self containerAnimations:self.container_Meteo HideView:self.container_Other];

        
        self.isMeteo = YES;
        self.isOther = NO;
    }
    
    
    
}

- (void) action_ButtonOther {
    //метод по нажатию на кнопку Other
    
    if (self.isNews == YES) {
        //если открыт блок с новостями
        
        [self containerAnimations:self.container_Other HideView:self.container_News];
        self.isOther = YES;
        self.isNews = NO;
        
    }
    
    if (self.isMeteo == YES) {
        //если открыт блок с погодой
        
        [self containerAnimations:self.container_Other HideView:self.container_Meteo];

        
        self.isOther = YES;
        self.isMeteo = NO;
        
    }
    
}



- (void) containerAnimations : (UIView *) showView HideView: (UIView *) hideView {
    
    [UIView animateWithDuration:0.35 delay:0.00 usingSpringWithDamping:0.8 initialSpringVelocity:0.3 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        CGRect frame_Meteo = [hideView frame];
        frame_Meteo.origin.x = frame_Meteo.origin.x - 600;
        hideView.frame = frame_Meteo;
        hideView.alpha = 0;
        
        CGRect frame_Other = [showView frame];
        frame_Other.origin.x = frame_Other.origin.x - 600;
        showView.frame = frame_Other;
        showView.alpha = 1;
//        if (showView.tag == TAG_NEWS_CONTAINER) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:NEWS_IS_NOT_HIDEN object:nil];
//            
//        }
        
        
    } completion:^(BOOL finished) {
        CGRect frame_Meteo = [hideView frame];
        frame_Meteo.origin.x = frame_Meteo.origin.x +1200;
        hideView.frame = frame_Meteo;
        
//        if (hideView.tag == TAG_NEWS_CONTAINER) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:NEWS_IS_HIDEN object:nil];
//
//        }
        

        
        
    }];
}


//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//


#pragma mark - Progress Animations

- (void) updateProgress: (NSNotification *) notif {
    
    NSString * strCurrentPoint = [notif.userInfo valueForKey:@"ProgressPoint"];
    NSString * strTotalPoints = [notif.userInfo valueForKey:@"TotalPoints"];

    float pr = [strCurrentPoint floatValue] / [strTotalPoints floatValue];
    
    if (pr == 0) {
        [self.progressView showPopUpViewAnimated:YES];
    }
        
    [self.progressView setProgress:pr animated:YES];

}

#pragma mark - ASProgressPopUpView dataSource

// <ASProgressPopUpViewDataSource> is entirely optional
// it allows you to supply custom NSStrings to ASProgressPopUpView
- (NSString *)progressView:(ASProgressPopUpView *)progressView stringForProgress:(float)progress
{
    NSString * start = NSLocalizedString(@"На взлет", nil);
    NSString * mark = NSLocalizedString(@"Рубеж", nil);
    NSString * safetySet = NSLocalizedString(@"Безопасная Набора", nil);
    NSString * complete = NSLocalizedString(@"Шасси убрать", nil);

    
    NSString *s;
    if (progress < 0.2) {
        s = start;
    } else if (progress > 0.4 && progress < 0.6) {
        s = mark;
    } else if (progress > 0.75 && progress < 1.0) {
        s = safetySet;
    } else if (progress >= 1.0) {
        s = complete;
        [self hidePop];
    }
    return s;
}

- (void) hidePop {
    int64_t delayInSeconds = 400;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_MSEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [self.progressView hidePopUpViewAnimated:YES];
        
        int64_t delayInSeconds = 700;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_MSEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [self.progressView setProgress:0.0f animated:YES];
            
        });


    });

}

// by default ASProgressPopUpView precalculates the largest popUpView size needed
// it then uses this size for all values and maintains a consistent size
// if you want the popUpView size to adapt as values change then return 'NO'
- (BOOL)progressViewShouldPreCalculatePopUpViewSize:(ASProgressPopUpView *)progressView;
{
    return NO;
}



//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//



#pragma mark - Detail News


- (void) showDetailNewsOverBlur: (NSNotification *) notif  {
    
    NSString * textNews = [notif.userInfo valueForKey:DETAIL_TEXT];
    UIImage * image = [notif.userInfo valueForKey:DETAIL_IMAGE];

    UIView * newsView = [self viewDetailNews:image Text:textNews];
    UIImage * image_BG = [UIImage blurBackgroundView:self.view Radius:4];
    
    [self.blur setBlurView:self bluredImage:image_BG View:newsView];
//    self.viewTopBox = newsView;
//    [self.view addSubview:newsView];
    
    
}


- (UIView *) viewDetailNews: (UIImage *) image Text:(NSString *) text {
    
    CGFloat textHight = [UITextView heightForText:text View:[[UIView alloc]initWithFrame:CGRectMake(0, 0, image.size.width, 10) ] Font:[UIFont fontWithName:MAIN_FONT_LIGHT size:18]];

    
    UIView * resultView = [[UIView alloc] initWithFrame:CGRectMake(10, 70, image.size.width, image.size.width + textHight)];
    resultView.backgroundColor = [UIColor clearColor];
    
    UIImageView* image_News = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, resultView.bounds.size.width, image.size.height)];
    image_News.image = image;
    UILabel * text_News = [[UILabel alloc]initWithFrame:CGRectMake(0, image.size.height, resultView.bounds.size.width, textHight)];
    text_News.text = text;
    text_News.numberOfLines = 0;
    text_News.lineBreakMode = NSLineBreakByWordWrapping;
    text_News.textColor = [UIColor blackColor];
    text_News.textAlignment = NSTextAlignmentLeft;
    text_News.backgroundColor = [UIColor clearColor];
    text_News.font = [UIFont fontWithName:MAIN_FONT_REGULAR size:18];
    [text_News.layer setShadowColor:[UIColor whiteColor].CGColor];
    [text_News.layer setShadowOpacity:5.8];
    [text_News.layer setShadowRadius:1.0];
    [text_News.layer setShadowOffset:CGSizeMake(1.3, 1.3)];
    
//    
//    UITextView * textView_News = [[UITextView alloc]initWithFrame:CGRectMake(0, image.size.height, resultView.bounds.size.width, textHight)];
//    textView_News.text = text;
//    textView_News.font = [UIFont fontWithName:MAIN_FONT_LIGHT size:18];
//    textView_News.userInteractionEnabled = NO;
//    textView_News.backgroundColor = [UIColor clearColor];
    
    UIScrollView * scr_View = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, resultView.bounds.size.width, resultView.bounds.size.height)];
    scr_View.delegate = self;
    scr_View.scrollEnabled=YES;
    scr_View.userInteractionEnabled=YES;
    scr_View.bounces =YES;
    scr_View.showsVerticalScrollIndicator=YES;
    
    float offset = text_News.frame.size.height + image.size.height;
    [scr_View setContentInset:UIEdgeInsetsMake(0, 0, offset, 0)];
    
    [image_News addSubview:text_News];
    [scr_View addSubview:image_News];
    [resultView addSubview:scr_View];

    return resultView;

    

}


- (void) hideDetailNewsOverBlur {
    
    
    
}

@end
