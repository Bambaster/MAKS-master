//
//  NSNotificationCenter+Notifications.h
//  ALCOMATH
//
//  Created by Lowtrack on 02.03.15.
//  Copyright (c) 2015 Vladimir Popov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNotificationCenter (Notifications)

+ (void) post_Notification : (NSString *) notification_Name;
+ (void) post_Notification_WithDict : (NSString *) notification_Name Dictionary: (NSDictionary *) dict;
+ (void) add_Notification : (NSString *) notification_Name Selector: (SEL) method Controller: (UIViewController *) controller;

+ (void) remove_Notifications;

@end
