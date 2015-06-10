//
//  ConstruktorForDetailView.m
//  MAKS
//
//  Created by Lowtrack on 10.06.15.
//  Copyright (c) 2015 Vladimir Popov. All rights reserved.
//

#import "ConstruktorForDetailView.h"

@implementation ConstruktorForDetailView


#pragma mark - Constructor View for Detail View


+ (UIView *) getViewDetailNews: (UIImage *) image Text:(NSString *) text {
    
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
    [scr_View addSubview:image_News];
    [scr_View addSubview:text_News];
    [resultView addSubview:scr_View];
    
    return resultView;
    
    
    
}


@end
