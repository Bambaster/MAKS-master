//
//  RoadAuto.h
//  MAKS
//
//  Created by Admin on 25.05.15.
//  Copyright (c) 2015 Vladimir Popov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface RoadAuto : NSObject

+ (NSMutableArray *) array_Novoryazan; // по Новорязанскому шоссе (для обладателей зеленых пропусков или до аэродрома Быково с бесплатной парковкой)
+ (NSMutableArray *) array_Egoryevskoe; //по Егорьевскому шоссе (для обладателей желтых пропусков или до аэродрома Быково с бесплатной парковкой)


@end
