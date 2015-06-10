//
//  NewsParser.m
//  MAKS
//
//  Created by Lowtrack on 13.05.15.
//  Copyright (c) 2015 Vladimir Popov. All rights reserved.
//

#import "NewsParser.h"
#import "APIManager.h"
#import "Result.h"
#import "TextCalculation.h"

@interface NewsParser ()<APIManagerDelegate>


@end

@implementation NewsParser

@synthesize array_images;



#pragma mark - API

+ (NewsParser *) newsManagerWithDelegate: (id<NewsParserDelegate>) aDelegate {
    return [[NewsParser alloc] initWithDelegate:aDelegate];
}



- (id)initWithDelegate:(id<NewsParserDelegate>) aDelegate
{
    self = [super init];
    if (self) {
        self.delegate = aDelegate;
    }
    return self;
}


- (void) getNewsFromWall: (NSString *) ownerID {
    
    
    if (![ownerID hasPrefix:@"-"]) {
        ownerID = [@"-" stringByAppendingString:ownerID];
    }
    
    NSDictionary * params = [[NSDictionary alloc] initWithObjectsAndKeys:
                             ownerID, @"owner_id",
                             @10, @"count",
                             @4, @"offset" ,
                             @"owner", @"filter", nil];
    
    
    [[APIManager managerWithDelegate:self] getDataFromWall:params];
    
    
}


- (void) response: (APIManager *) manager Answer: (id) respObject {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
    if ([respObject isKindOfClass:[Result class]]) {
        
        Result * res = (id) respObject;
        
        NSMutableArray * arrayResult = [[NSMutableArray alloc] init];
        
        int photoCount = 0;
        
        for (int i = 1; i < [res.response count]; i++) {
            
            if ([[[res.response objectAtIndex:i]attachment]photo]) {
                
                photoCount++;
                NSLog(@"YES");
            }
            else {
                NSLog(@"NO");
            }
            
        }
        
        
        for (int i = 1; i < [res.response count]; i++) {
            
            if ([[[res.response objectAtIndex:i]attachment]photo]) {

            
            NSString * link = [[[[res.response objectAtIndex:i]attachment]photo]src_big];
//            CGFloat height = [[[[res.response objectAtIndex:i]attachment]photo]height];
//            CGFloat width = [[[[res.response objectAtIndex:i]attachment]photo]width];
            
            NSString * text = [[res.response objectAtIndex:i]text];
            text = [text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
            NSURL * url = [NSURL URLWithString:link];

            
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *img = [[UIImage alloc] initWithData:data];
            CGFloat scaleFactorDetailImage = self.view.frame.size.width/ img.size.width;
            CGFloat targetHeightDetailImage = img.size.height * scaleFactorDetailImage;
            CGSize targetDetailImageSize = CGSizeMake (self.view.frame.size.width, targetHeightDetailImage);
            UIImage * resizingDetailImage = [img resizedImage:targetDetailImageSize interpolationQuality:kCGInterpolationHigh];
            
            
            NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   resizingDetailImage, DETAIL_IMAGE,
                                   text, DETAIL_TEXT, nil];
            
            [arrayResult addObject:dict];
            
            if (arrayResult.count == photoCount) {
                
                [self.delegate newsParsed:self NewsArray:arrayResult];
            }

          }
            
        }
        
     }
    
        
    });
    
}


- (void) responseError: (APIManager *) manager Error: (NSError *) error{
    
    NSLog(@"error %@", error);
}






/*
- (void) api_groups_request {
 
    NSDictionary* params =  [NSDictionary dictionaryWithObjectsAndKeys: @"military_aircraft",   @"gids", nil];
    
    [[API sharedManager]get_request:params method:Get_Groups onSuccess:^(NSDictionary *answer) {
        
        NSLog(@"JSON api_groups_request answer : %@", answer);
        
    } onFailure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"error = %@, code = %ld", [error localizedDescription], (long)statusCode);
    }];
}



- (void) api_wall_your_future {
    
    array_images = [[NSMutableArray alloc]init];
    
    __block int index_photo = 0;
    __block int index_no_photo = 0;
    
    NSString * your_future_ID;
    
    if (![Encyclopedia_Air hasPrefix:@"-"]) {
        your_future_ID = [@"-" stringByAppendingString:Encyclopedia_Air];
    }
    
    NSDictionary* params =  [NSDictionary dictionaryWithObjectsAndKeys:
                             your_future_ID,   @"owner_id",
                             @(10),            @"count",
                             @(2),             @"offset",
                             @"owner",         @"filter", nil];
    
    [[API sharedManager]get_request:params method:Get_Groups_Wall onSuccess:^(NSDictionary *answer) {
        
//        NSLog(@"JSON api_wall_your_future answer : %@", answer);
        NSArray * array = [ answer valueForKey:@"response"];
        
        [array enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
            
            index_photo ++;

            
            if (idx == 0 || idx ==1) {
                
                
//                index_photo ++;
//                index_no_photo = index_no_photo + 1;
            }
            
            else
            {
                
                
                
                NSDictionary * dict = [object valueForKey:@"attachment"];
                
                
                NSString * news_text = [[object valueForKey:@"text"]stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
                
                
                if ([[dict valueForKey:@"type"] isEqualToString:@"photo"]) {
                    
                    //                    NSLog(@"isEqualToString:photo");
                    
                    NSDictionary * photo = [dict valueForKey:@"photo"];
                    NSString * link = [photo valueForKey:@"src_big"];
                    CGFloat height = [[photo valueForKey:@"height"] intValue];
                    CGFloat width = [[photo valueForKey:@"width"] intValue];
                    
                    //                    NSLog(@"link : %@", link );
                    //                    NSURL* url = [NSURL URLWithString:link];
                    
                    NSMutableDictionary * dict_images = [NSMutableDictionary dictionary];
                    
                    
                    [dict_images setValue:[NSString stringWithFormat:@"%f", height] forKey:@"height"];
                    [dict_images setValue:[NSString stringWithFormat:@"%f", width] forKey:@"width"];
                    [dict_images setValue:link forKey:@"link"];
                    [dict_images setValue:news_text forKey:@"news_text"];
                    
                    [array_images addObject:dict_images];

                    if (stop) {
                        

                        if (index_photo == array.count) {

                            [self performSelector:@selector(setup_news_view) withObject:nil afterDelay:0.5];
                            
//                            NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:array_images, @"array", nil];
//                            [[NSNotificationCenter defaultCenter] postNotificationName:ArrayNews object:nil userInfo:dict];
//                            
                        }
                        
                    }

                }
                
                
                else {
                    
                    if (index_photo == array.count) {
                        
                        //    [self performSelector:@selector(setup_news_view) withObject:nil afterDelay:0.5];
                        
                        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:array_images, @"array", nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:ArrayNews object:nil userInfo:dict];
                        
                    }
                }
                
            }
            
        }];
        
    } onFailure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"error = %@, code = %ld", [error localizedDescription], (long)statusCode);

        
        
    }];
    
}



- (void) apiFacts {
    
    array_images = [[NSMutableArray alloc]init];
    
    __block int index_photo = 0;
    __block int index_no_photo = 0;
    
    NSString * your_future_ID;
    
    if (![Encyclopedia_Air hasPrefix:@"-"]) {
        your_future_ID = [@"-" stringByAppendingString:Encyclopedia_Air];
    }
    
    NSDictionary* params =  [NSDictionary dictionaryWithObjectsAndKeys:
                             your_future_ID,   @"owner_id",
                             @(10),            @"count",
                             @(2),             @"offset",
                             @"owner",         @"filter", nil];
    
    [[API sharedManager]get_request:params method:Get_Groups_Wall onSuccess:^(NSDictionary *answer) {
        
        //        NSLog(@"JSON api_wall_your_future answer : %@", answer);
        NSArray * array = [ answer valueForKey:@"response"];
        
        [array enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
            
            index_photo ++;
            
            
            if (idx == 0 || idx ==1) {
                
                
                //                index_photo ++;
                //                index_no_photo = index_no_photo + 1;
            }
            
            else
            {
                
                
                
                NSDictionary * dict = [object valueForKey:@"attachment"];
                
                
                NSString * news_text = [[object valueForKey:@"text"]stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
                
                
                if ([[dict valueForKey:@"type"] isEqualToString:@"photo"]) {
                    
                    //                    NSLog(@"isEqualToString:photo");
                    
                    NSDictionary * photo = [dict valueForKey:@"photo"];
                    NSString * link = [photo valueForKey:@"src_big"];
                    CGFloat height = [[photo valueForKey:@"height"] intValue];
                    CGFloat width = [[photo valueForKey:@"width"] intValue];
                    
                    //                    NSLog(@"link : %@", link );
                    //                    NSURL* url = [NSURL URLWithString:link];
                    
                    NSMutableDictionary * dict_images = [NSMutableDictionary dictionary];
                    
                    
                    [dict_images setValue:[NSString stringWithFormat:@"%f", height] forKey:@"height"];
                    [dict_images setValue:[NSString stringWithFormat:@"%f", width] forKey:@"width"];
                    [dict_images setValue:link forKey:@"link"];
                    [dict_images setValue:news_text forKey:@"news_text"];
                    
                    [array_images addObject:dict_images];
                    
                    if (stop) {
                        
                        
                        if (index_photo == array.count) {
                            
                            [self performSelector:@selector(setup_news_view) withObject:nil afterDelay:0.5];
                            
                            //                            NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:array_images, @"array", nil];
                            //                            [[NSNotificationCenter defaultCenter] postNotificationName:ArrayNews object:nil userInfo:dict];
                            //
                        }
                        
                    }
                    
                }
                
                
                else {
                    
                    if (index_photo == array.count) {
                        
                        //    [self performSelector:@selector(setup_news_view) withObject:nil afterDelay:0.5];
                        
                        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:array_images, @"array", nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:ArrayNews object:nil userInfo:dict];
                        
                    }
                }
                
            }
            
        }];
        
    } onFailure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"error = %@, code = %ld", [error localizedDescription], (long)statusCode);
        
        
        
    }];
    
}



















- (void) setup_news_view {
    
    self.array_slide_news_view = [[NSMutableArray alloc]init];

    __block NSString * news_text = [NSString string];
    
    
    for (int  i = 0; i < array_images.count; i++) {
    
        
        __block CGFloat prportion;
        __block CGFloat image_nuws_height;
        CGFloat height = [[[array_images objectAtIndex:i] valueForKey:@"height"] floatValue];
        CGFloat width = [[[array_images objectAtIndex:i] valueForKey:@"width"] floatValue];
        
        
        if (width > self.view.bounds.size.width) {
            
            
            if (height > width) {
                prportion = height/width;
                image_nuws_height = self.view.bounds.size.width * prportion;
                
            }
            else {
                prportion = width/height;
                
                //                    NSLog(@"image_nuws_height %f", prportion);
                
                image_nuws_height = self.view.bounds.size.width / prportion;
                
                //                    NSLog(@"image_nuws_height %f", image_nuws_height);
            }
            
            
        }
        
        else {
            
            
            if (width < self.view.bounds.size.width) {
                
                prportion = self.view.bounds.size.width - width;
                image_nuws_height = height + prportion;
                
            }
            else  {
                image_nuws_height = height;
                
            }
            
        }
        
        

        
        UIImageView* iimage_news = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, image_nuws_height)];
        
        UITextView * ttextView_News = [[UITextView alloc]initWithFrame:CGRectMake(0, image_nuws_height, self.view.frame.size.width, [self heightForText:[[array_images objectAtIndex:i] valueForKey:@"news_text"]])];
        
//        
//        UIScrollView * scr_view = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//        scr_view.scrollEnabled=YES;
//        scr_view.userInteractionEnabled=YES;
//        scr_view.bounces =YES;
//        scr_view.showsVerticalScrollIndicator=YES;
//        
//        float offset = ttextView_News.frame.size.height + image_nuws_height;
        
        [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:[[array_images objectAtIndex:i] valueForKey:@"link"]]
                                                            options:0
                                                           progress:^(NSInteger receivedSize, NSInteger expectedSize)
         {
             // progression tracking code
         }
                                                          completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
         {
             if (image && finished)
             {
                 // do something with image
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     iimage_news.image = [self resizing_Image:image height:image_nuws_height width:self.view.frame.size.width];
                     
                     ttextView_News.font = [UIFont systemFontOfSize:14];
                     
                     news_text = [[array_images objectAtIndex:i] valueForKey:@"news_text"];
                     ttextView_News.text = news_text;
                     ttextView_News.userInteractionEnabled = NO;
                     
                 });
                 
             }
             
             
         }];
        
//        [scr_view setContentInset:UIEdgeInsetsMake(0, 0, offset, 0)];
        
        UIView * view_presentation = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, iimage_news.bounds.size.height + ttextView_News.bounds.size.height)];
        view_presentation.backgroundColor = [UIColor whiteColor];
        
        
        
        [iimage_news addSubview:ttextView_News];
        
//        [scr_view addSubview:iimage_news];
        //                [scr_view addSubview:ttextView_News];
        //
        [view_presentation addSubview:iimage_news];
        
        
        
        //            [view_presentation addSubview:ttextView_News];
        
        
       [self.array_slide_news_view addObject:view_presentation];
        
        
        
        
        
        //    [text_news sizeToFit];
        
        
        if (self.array_slide_news_view.count == self.array_images.count) {
            

            NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:self.array_slide_news_view, @"array", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:ArrayNews object:nil userInfo:dict];

            
            
        }
        
    }
    //           });

    //    }
}


- (CGFloat) heightForText:(NSString*) text {
    
    CGFloat offset = 5.0;
    
    UIFont* font = [UIFont systemFontOfSize:14];
    
    NSShadow* shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0, -1);
    shadow.shadowBlurRadius = 0.5;
    
    NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineBreakMode:NSLineBreakByWordWrapping];
    [paragraph setAlignment:NSTextAlignmentCenter];
    
    NSDictionary* attributes =
    [NSDictionary dictionaryWithObjectsAndKeys:
     font, NSFontAttributeName,
     paragraph, NSParagraphStyleAttributeName,
     shadow, NSShadowAttributeName, nil];
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 2 * offset, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:attributes
                                     context:nil];
    
    return CGRectGetHeight(rect) + 2 * offset;
}



- (UIImage *) resizing_Image: (UIImage *) image height: (CGFloat) height width: (CGFloat) width  {
    
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = width/height;
    
    if(imgRatio!=maxRatio){
        if(imgRatio < maxRatio){
            imgRatio = height / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = height;
        }
        else{
            imgRatio = width / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = width;
        }
    }
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}





-(BOOL) isInternetReachable
{
    return [AFNetworkReachabilityManager sharedManager].reachable;
}
*/

@end
