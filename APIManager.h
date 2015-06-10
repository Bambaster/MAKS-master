//
//  APIManager.h
//  VK_News
//
//  Created by Lowtrack on 29.05.15.
//  Copyright (c) 2015 Vladimir Popov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>


@protocol APIManagerDelegate;

@interface APIManager : NSObject

@property (nonatomic, weak) id<APIManagerDelegate> delegate;

- (void) getDataFromWall: (NSDictionary *) params;
+ (APIManager *) managerWithDelegate: (id<APIManagerDelegate>) aDelegate;
- (id)initWithDelegate:(id<APIManagerDelegate>) aDelegate;

@end



@protocol APIManagerDelegate <NSObject>
@required
- (void) response: (APIManager *) manager Answer: (id) respObject;
- (void) responseError: (APIManager *) manager Error: (NSError *) error;



@end