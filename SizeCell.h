//
//  SizeCell.h
//  MAKS
//
//  Created by Lowtrack on 14.05.15.
//  Copyright (c) 2015 Vladimir Popov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SizeCell : NSObject

+ (CGFloat) getSize: (UIView *) view Width:(CGFloat)width Height:(CGFloat) height;
+ (UIImage *) resizing_Image: (UIImage *) image height: (CGFloat) height width: (CGFloat) width;
+ (CGFloat) heightForText:(UIView *) view Text: (NSString*) text;
@end
