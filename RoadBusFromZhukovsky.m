//
//  RoadBusFromZhukovsky.m
//  MAKS
//
//  Created by Admin on 25.05.15.
//  Copyright (c) 2015 Vladimir Popov. All rights reserved.
//

#import "RoadBusFromZhukovsky.h"

@implementation RoadBusFromZhukovsky

+ (NSMutableArray *) array_Bus_25_27Avg {
    
    NSMutableArray * array_Bus = [[NSMutableArray alloc]init];
    
    NSString * string_Vacation = @"Платформа Отдых. Внимание! На всех указанных маршрутах начало движения автобусов в 08:15 часов утра.";
    NSString * string_KPP1 = @"Проходная №1 аэродрома Раменское.";
    NSArray * arrayAnnotation = [[NSArray alloc]initWithObjects:string_Vacation, string_KPP1, nil];

    
    //Платформа Отдых:
    CLLocation * coordPlatformVacation = [[CLLocation alloc]initWithLatitude:55.60141439370969 longitude:38.13576579093933];
    
    //Проходная №1 аэродрома Раменское
    CLLocation * coordKPP1 = [[CLLocation alloc]initWithLatitude:55.573959588650304 longitude:38.12157154083252];
    
    
    
    NSArray * arrayCoord = [[NSArray alloc] initWithObjects: coordPlatformVacation, coordKPP1, nil];
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    
    for (int i = 0; i < arrayCoord.count; i++) {
        
        [dict setObject:[arrayCoord objectAtIndex:i] forKey:@"coord"];
        [dict setObject:[arrayAnnotation objectAtIndex:i] forKey:@"annotation"];
        
        [array_Bus addObject:dict];
    }
    
    
    return array_Bus;
    
}

//---------------------------------------------------------------------------------------------------------------------------------------

+ (NSMutableArray *) array_Bus_28_30Avg{
    
    NSMutableArray * array_Bus = [[NSMutableArray alloc]init];
    
    NSString * string_Vacation = @"Платформа «Отдых. Внимание! На всех указанных маршрутах начало движения автобусов в 08:15 часов утра.»";
    NSString * string_KPP1 = @"Проходная №1 аэродрома Раменское";
    NSString * string_Platforma42km = @"Платформа «42-й километр»";
    NSString * string_BykovoAirport = @"Беплатная парковка у аэропорта Быково";
    NSString * string_StreetLackova = @"ул. Лацкова, с остановкой у ТЦ «Океан»";
    NSString * string_TCOcean = @"У ТЦ «Океан» ";
    
     NSArray * arrayAnnotation = [[NSArray alloc]initWithObjects:string_Vacation, string_KPP1, string_Platforma42km, string_BykovoAirport, string_StreetLackova, string_TCOcean, nil];

    
    //Платформа Отдых:
    CLLocation * coordPlatformVacation = [[CLLocation alloc]initWithLatitude:55.60141439370969 longitude:38.13576579093933];
    
    //Проходная №1 аэродрома Раменское
    CLLocation * coordKPP1 = [[CLLocation alloc]initWithLatitude:55.573959588650304 longitude:38.12157154083252];
    
    //Платформа 42 км:
    CLLocation * coordPlatform42km = [[CLLocation alloc]initWithLatitude:55.58339024806601 longitude:38.184356689453125];
    
    //Парковка у аэродрома Быково
    CLLocation * coordBykovoAirport = [[CLLocation alloc]initWithLatitude:55.622156463193136 longitude:38.065781593322754];
    
    //Остановка ул. Лацкова
    CLLocation * coordStreetLackova = [[CLLocation alloc]initWithLatitude:55.60602671082709 longitude:38.0745792388916];
    
    //Остановка у ТЦ Океан
    CLLocation * coordTCOcean = [[CLLocation alloc]initWithLatitude:55.60700850069994 longitude:38.09073686599731];
    
  
    NSArray * arrayCoord = [[NSArray alloc] initWithObjects: coordPlatformVacation, coordKPP1, coordPlatform42km, coordBykovoAirport, coordStreetLackova, coordTCOcean, nil];
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    
    for (int i = 0; i < arrayCoord.count; i++) {
        
        [dict setObject:[arrayCoord objectAtIndex:i] forKey:@"coord"];
        [dict setObject:[arrayAnnotation objectAtIndex:i] forKey:@"annotation"];
        
        [array_Bus addObject:dict];
    }

  
    
    return array_Bus;
    
}


@end
