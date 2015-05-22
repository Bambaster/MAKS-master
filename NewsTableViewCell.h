//
//  NewsTableViewCell.h
//  MAKS
//
//  Created by Lowtrack on 13.05.15.
//  Copyright (c) 2015 Vladimir Popov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableViewCell : UITableViewCell

@property (strong, nonatomic)  UIView *view;
@property (strong, nonatomic)  UIImageView *imageView_News;
@property (strong, nonatomic)  UITextView *textView_News;

@property (strong, nonatomic)  NSString *heightImage;
@property (strong, nonatomic)  NSString *widthImage;

@property (strong, nonatomic)  NSString *string_NewsText;

@property (strong, nonatomic)  NSString *string_Link;



- (void) setup_News_View;

@end
