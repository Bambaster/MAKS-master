//
//  UIImage+UIImageURL.m
//  ALCOMATH
//
//  Created by Lowtrack on 02.04.15.
//  Copyright (c) 2015 Vladimir Popov. All rights reserved.
//

#import "UIImage+UIImageURL.h"

@implementation UIImage (UIImageURL)


+ (UIImage *) getImageFromURL : (NSString *) url {
    
    NSURL *pictureURL = [NSURL URLWithString:url];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];
    __block UIImage * image = [[UIImage alloc] init];
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (connectionError == nil && data != nil) {
                                   
                                   image = [UIImage imageWithData:data];
                                   
                               } else {
                                   NSLog(@"Failed to load profile photo.");
                               }
                           }];
    
    return image;
}




@end
