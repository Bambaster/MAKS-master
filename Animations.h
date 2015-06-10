//
//  Animations.h
//  MAKS
//
//  Created by Lowtrack on 20.05.15.
//  Copyright (c) 2015 Vladimir Popov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Animations : NSObject
//Показываем пин с палочкой 
- (void) animate_Show_Pin: (UIView *) pin;
+ (void) animate_Show_Stick: (UIView *) stick;


- (void) showView : (UIView *) view;
- (void) hideView : (UIView *) view;

@end
