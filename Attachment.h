//
//  Attachment.h
//  VK_News
//
//  Created by Lowtrack on 29.05.15.
//  Copyright (c) 2015 Vladimir Popov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Photo.h"

@interface Attachment : Photo

@property (nonatomic, strong) Photo * photo;
@property (nonatomic, copy) NSString * type;


@end
