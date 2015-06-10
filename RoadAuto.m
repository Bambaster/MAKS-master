//
//  RoadAuto.m
//  MAKS
//
//  Created by Admin on 25.05.15.
//  Copyright (c) 2015 Vladimir Popov. All rights reserved.
//

#import "RoadAuto.h"

@implementation RoadAuto

+ (NSMutableArray *) array_Novoryazan {
    // по Новорязанскому шоссе (для обладателей зеленых пропусков или до аэродрома Быково с бесплатной парковкой)
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    
    NSString * string_Novoryazan  = @"Новорязанское шоссе: (для обладателей зеленых пропусков на парковки P2, P6, P7 (только для легковых автомобилей). Пропуск необходимо приобрести заранее)";
    
    NSString * stringBykovo = @"В дни массового посещения – 28-30 августа будет действовать бесплатная перехватывающая парковка на аэродроме «Быково». Далее от нее посетителей будет забирать бесплатный автобус «МАКС-2015», который проследует до КПП3 выставочного комплекса.Координаты аэродрома Быково для GPS-Навигации: Широта: 55.62145978532177   Долгота: 38.041287660598755 . Не забудьте сохранить координаты парковки своего автомобиля!";
    
    NSString * stringCommunicating1 = @"Проезд на территорию Аэродрома Раменское осуществляется через Проходную №1. Координаты для GPS-Навигации: Широта: 55.57468137188983   Долгота: 38.12234401702881";
    NSString * stringCommunicating2 = @"Так же проезд на территорию Аэродрома Раменское осуществляется через Проходную №2 Координаты для GPS-Навигации: Широта: 55.57395352318871   Долгота: 38.12058448791504";
    NSString * stringParking2 = @"Далее на парковку P2";
    NSString * stringParking6 = @"Или на парковку P6";
    NSString * stringParking7 = @"Или на парковку P7";
    
   
    NSArray * arrayAnnotation = [[NSArray alloc]initWithObjects:string_Novoryazan, stringBykovo, stringCommunicating1, stringCommunicating2, stringParking2, stringParking6, stringParking7, nil];
  
    CLLocation * coordNovoryazan = [[CLLocation alloc]initWithLatitude:55.681412 longitude:37.844747];
    CLLocation * coordParkingBykovo = [[CLLocation alloc]initWithLatitude:55.62145978532177 longitude:38.041287660598755];
    
    CLLocation * coordCommunicating1 = [[CLLocation alloc]initWithLatitude:55.57468137188983 longitude:38.12234401702881];
    CLLocation * coordCommunicating2 = [[CLLocation alloc]initWithLatitude:55.57395352318871 longitude:38.12058448791504];
    
    
    CLLocation * coordParking2East = [[CLLocation alloc]initWithLatitude:55.568934032573395 longitude:38.14137428998947];
    CLLocation * coordParking6 = [[CLLocation alloc]initWithLatitude:55.56334966416863 longitude:38.12152862548828];
    CLLocation * coordParking7 = [[CLLocation alloc]initWithLatitude:55.57130889268606 longitude: 38.1251335144043];
    
    
    NSArray * arrayCoord = [[NSArray alloc] initWithObjects: coordNovoryazan, coordParkingBykovo, coordCommunicating1, coordCommunicating2, coordParking2East, coordParking6, coordParking7, nil];
    
    
    
    for (int i = 0; i < arrayCoord.count; i++) {
        
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        
        [dict setObject:[arrayCoord objectAtIndex:i] forKey:@"coord"];
        [dict setObject:[arrayAnnotation objectAtIndex:i] forKey:@"annotation"];
        
        [array addObject:dict];
    }

    
    
    return array;
    
}

+ (NSMutableArray *) array_Egoryevskoe {
    //по Егорьевскому шоссе (для обладателей желтых пропусков или до аэродрома Быково с бесплатной парковкой)
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    
    NSString * string_Egoryevskoe  = @"Егорьевское шоссе: (для обладателей желтых пропусков на парковки P3 (только для легкового автотранспорта) и Р4( только для автобусов). Пропуск необходимо приобрести заранее)";
    
    NSString * stringBykovo = @"В дни массового посещения – 28-30 августа будет действовать бесплатная перехватывающая парковка на аэродроме «Быково». Далее от нее посетителей будет забирать бесплатный автобус «МАКС-2015», который проследует до КПП3 выставочного комплекса.Координаты аэродрома Быково для GPS-Навигации: Широта: 55.62145978532177   Долгота: 38.041287660598755 . Не забудьте сохранить координаты парковки своего автомобиля!";
    
    NSString * stringCommunicating = @"Проезд на территорию Аэродрома Раменское осуществляется через ОАО «ИЛ». Координаты для GPS-Навигации: Широта: 55.5736623799309   Долгота: 38.16830635070801";
    

    NSString * stringParking4 = @"Далее на парковку P4 (автобусы)";
    NSString * stringParking3 = @"Или на парковку P3 (легковой автотранспорт)";
    
    NSArray * arrayAnnotation = [[NSArray alloc]initWithObjects:string_Egoryevskoe, stringBykovo, stringCommunicating, stringParking4, stringParking3, nil];
    

    CLLocation * coordEgoryevskoe = [[CLLocation alloc]initWithLatitude:55.659607 longitude:37.929054];
    CLLocation * coordParkingBykovo = [[CLLocation alloc]initWithLatitude:55.62145978532177 longitude:38.041287660598755];
    
    CLLocation * coordCommunicating = [[CLLocation alloc]initWithLatitude:55.5736623799309 longitude:38.16830635070801];

    CLLocation * coordParking4 = [[CLLocation alloc]initWithLatitude:55.56796038941467 longitude:38.16332817077637];
    CLLocation * coordParking3 = [[CLLocation alloc]initWithLatitude:55.56796038941467 longitude:38.15328598022461];

    
    NSArray * arrayCoord = [[NSArray alloc] initWithObjects: coordEgoryevskoe, coordParkingBykovo, coordCommunicating, coordParking4, coordParking3, nil];
    
    
    
    for (int i = 0; i < arrayCoord.count; i++) {
        
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        
        [dict setObject:[arrayCoord objectAtIndex:i] forKey:@"coord"];
        [dict setObject:[arrayAnnotation objectAtIndex:i] forKey:@"annotation"];
        
        [array addObject:dict];
    }

    
    
    return array;
    
}



@end









