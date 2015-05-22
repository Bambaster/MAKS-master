//
//  NSNotificationCenter+Notifications.m
//  ALCOMATH
//
//  Created by Lowtrack on 02.03.15.
//  Copyright (c) 2015 Vladimir Popov. All rights reserved.
//

#import "NSNotificationCenter+Notifications.h"

@implementation NSNotificationCenter (Notifications)


+ (void) post_Notification : (NSString *) notification_Name {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:notification_Name object:nil userInfo:nil];

}

+ (void) post_Notification_WithDict : (NSString *) notification_Name Dictionary: (NSDictionary *) dict {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:notification_Name object:nil userInfo:dict];
    
}

+ (void) add_Notification : (NSString *) notification_Name Selector: (SEL) method Controller: (UIViewController *) controller {
    
    [[NSNotificationCenter defaultCenter]addObserver:controller selector:method name:notification_Name object:nil];

}

+ (void) remove_Notifications {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

@end
