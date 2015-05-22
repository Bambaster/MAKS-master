//
//  NSDictionary+DictFrom_JSON_File.m
//  ALCOMATH
//
//  Created by Lowtrack on 10.02.15.
//  Copyright (c) 2015 Vladimir Popov. All rights reserved.
//

#import "NSDictionary+DictFrom_JSON_File.h"

@implementation NSDictionary (DictFrom_JSON_File)

+ (NSDictionary*)dictionaryWithContentsOfJSONString:(NSString*)fileLocation{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[fileLocation stringByDeletingPathExtension] ofType:[fileLocation pathExtension]];
    NSData* data = [NSData dataWithContentsOfFile:filePath];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data
                                                options:kNilOptions error:&error];
    
    if (error != nil) return nil;
    return result;
}

@end
