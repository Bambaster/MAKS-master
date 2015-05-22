//
//  NewsParser.h
//  MAKS
//
//  Created by Lowtrack on 13.05.15.
//  Copyright (c) 2015 Vladimir Popov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsParser : NSObject

@property (strong, nonatomic) NSMutableArray * array_images;

@property (strong, nonatomic) NSMutableArray * array_slide_news_view;
@property (strong, nonatomic) UIView * view;


- (void) api_groups_request;
- (void) api_wall_your_future;


@end
