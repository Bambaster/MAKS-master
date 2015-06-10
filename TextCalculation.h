//
//  TextCalculation.h
//  Server
//
//  Created by Lowtrack on 29.05.15.
//  Copyright (c) 2015 Vladimir Popov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface TextCalculation : NSObject

+ (CGFloat) heightForText:(NSString*) text View: (UIView *) view Font: (UIFont *) fontType;

@end
