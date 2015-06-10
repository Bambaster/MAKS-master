//
//  APIManager.m
//  VK_News
//
//  Created by Lowtrack on 29.05.15.
//  Copyright (c) 2015 Vladimir Popov. All rights reserved.
//

#import "APIManager.h"
#import "Result.h"


#define MAIN_URL @"https://api.vk.com/method/"

@implementation APIManager

+ (APIManager *) managerWithDelegate: (id<APIManagerDelegate>) aDelegate {
    return [[APIManager alloc] initWithDelegate:aDelegate];
}



- (id)initWithDelegate:(id<APIManagerDelegate>) aDelegate
{
    self = [super init];
    if (self) {
        self.delegate = aDelegate;
    }
    return self;
}


- (void) getDataFromWall: (NSDictionary *) params {

    
    NSURL * url = [NSURL URLWithString:MAIN_URL];
    
    AFHTTPRequestOperationManager * manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    
    [manager GET:Get_Groups_Wall parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {

        Result * res = [[Result alloc] initWithDictionary:responseObject];
        
        if ([self.delegate respondsToSelector:@selector(response:Answer:)]) {
            [self.delegate response:self Answer:res];
        }
        
            
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(responseError:Error:)]) {
            
            [self.delegate responseError:self Error:error];
        }
    }];
    
}

@end
