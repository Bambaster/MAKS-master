//
//  NSDictionary+DictFrom_JSON_File.h
//  ALCOMATH
//
//  Created by Lowtrack on 10.02.15.
//  Copyright (c) 2015 Vladimir Popov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (DictFrom_JSON_File)

+ (NSDictionary*)dictionaryWithContentsOfJSONString:(NSString*)fileLocation;

@end
