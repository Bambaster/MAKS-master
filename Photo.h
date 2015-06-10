//
//  Photo.h
//  VK_News
//
//  Created by Lowtrack on 29.05.15.
//  Copyright (c) 2015 Vladimir Popov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Jastor.h"
@interface Photo : Jastor

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, copy) NSString * src_big;

@end
