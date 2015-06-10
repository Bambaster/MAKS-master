//
//  Response.h
//  VK_News
//
//  Created by Lowtrack on 29.05.15.
//  Copyright (c) 2015 Vladimir Popov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Attachment.h"

@interface Response : Attachment

@property (nonatomic, strong) Attachment * attachment;
@property (nonatomic, copy) NSString * text;


@end
