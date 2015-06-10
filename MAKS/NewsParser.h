//
//  NewsParser.h
//  MAKS
//
//  Created by Lowtrack on 13.05.15.
//  Copyright (c) 2015 Vladimir Popov. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol NewsParserDelegate;


@interface NewsParser : NSObject

@property (strong, nonatomic) NSMutableArray * array_images;
@property (nonatomic, weak) id<NewsParserDelegate> delegate;
@property (strong, nonatomic) NSMutableArray * array_slide_news_view;
@property (strong, nonatomic) UIView * view;

- (void) getNewsFromWall: (NSString *) ownerID;

+ (NewsParser *) newsManagerWithDelegate: (id<NewsParserDelegate>) aDelegate;
- (id)initWithDelegate:(id<NewsParserDelegate>) aDelegate;


@end


@protocol NewsParserDelegate <NSObject>

- (void) newsParsed: (NewsParser *) parser NewsArray: (NSMutableArray *) array;

@end