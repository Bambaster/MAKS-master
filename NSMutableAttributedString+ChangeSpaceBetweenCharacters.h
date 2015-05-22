//
//  NSMutableAttributedString+ChangeSpaceBetweenCharacters.h
//  ALCOMATH
//
//  Created by Lowtrack on 10.02.15.
//  Copyright (c) 2015 Vladimir Popov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSMutableAttributedString (ChangeSpaceBetweenCharacters)
+ (NSMutableAttributedString *) set_Spase_Between_Char: (NSString *) string space_Value: (float) value;
@end
