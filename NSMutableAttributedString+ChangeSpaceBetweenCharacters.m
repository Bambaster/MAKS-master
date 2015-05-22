//
//  NSMutableAttributedString+ChangeSpaceBetweenCharacters.m
//  ALCOMATH
//
//  Created by Lowtrack on 10.02.15.
//  Copyright (c) 2015 Vladimir Popov. All rights reserved.
//

#import "NSMutableAttributedString+ChangeSpaceBetweenCharacters.h"

@implementation NSMutableAttributedString (ChangeSpaceBetweenCharacters)


+ (NSMutableAttributedString *) set_Spase_Between_Char: (NSString *) string space_Value: (float) value {
    
    NSMutableAttributedString* attrStr = [[NSMutableAttributedString alloc] initWithString: string];
    [attrStr addAttribute:NSKernAttributeName value:@(value) range:NSMakeRange(0, attrStr.length)];
    
    
    return attrStr;
}

@end
