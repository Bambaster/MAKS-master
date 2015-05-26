//
//  RoadByTrain.m
//  MAKS
//
//  Created by Admin on 25.05.15.
//  Copyright (c) 2015 Vladimir Popov. All rights reserved.
//

#import "RoadByTrain.h"

@implementation RoadByTrain


+ (NSMutableArray *) array_RoadTrainVacation {
    //на электричке до платформы Отдых
    
    NSMutableArray * array_RoadTrain = [[NSMutableArray alloc]init];
    
    NSString * string_MoscowKazanVacation = @"От Казанского вокзала (Москва Казанская) садитесь в электричку до платформы Отдых. Стоимость билета: 95 рублей. Время в пути: 54-57 мин. Расписание электричек: http://www.tutu.ru/rasp.php?st1=7402&st2=9302&date=25.08.2015";
    NSString * string_Vacation = @"От платформы «Отдых» до выставочного комплекса ежедневно курсируют бесплатные автобусы «МАКС-2015» с 25 августа по 30 августа. Внимание! На всех указанных маршрутах начало движения автобусов в 08:15 утра.";
    NSString * string_Gate3 = @"Вход на территорию выставки через: КПП3";
    
    NSArray * arrayAnnotation = [[NSArray alloc]initWithObjects:string_MoscowKazanVacation, string_Vacation, string_Gate3, nil];
    
    //Москва Казанская:
    CLLocation * coordMoscowKazan = [[CLLocation alloc]initWithLatitude:55.77426791355413 longitude:37.65812873840332];
    
    //Платформа Отдых:
    CLLocation * coordPlatformVacation = [[CLLocation alloc]initWithLatitude:55.60141439370969 longitude:38.13576579093933];
    
    //КПП3:
    CLLocation * coordGate3 = [[CLLocation alloc]initWithLatitude:55.56800892048633 longitude:38.15126895904541];

    
    NSArray * arrayCoord = [[NSArray alloc] initWithObjects: coordMoscowKazan, coordPlatformVacation, coordGate3, nil];
    
    
    
    for (int i = 0; i < arrayCoord.count; i++) {
        
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        
        [dict setObject:[arrayCoord objectAtIndex:i] forKey:@"coord"];
        [dict setObject:[arrayAnnotation objectAtIndex:i] forKey:@"annotation"];
        
        [array_RoadTrain addObject:dict];
    }
    

    
    
    return array_RoadTrain;

}


//--------------------------------------------------------------------------------------------------------------------------------------------

+ (NSMutableArray *) array_RoadTrain42km {
    //на электричке до платформы 42 км
    
    NSMutableArray * array_RoadTrain = [[NSMutableArray alloc]init];
    
    NSString * string_MoscowKazanPlatform42km = @"От Казанского вокзала (Москва Казанская) садитесь в электричку до платформы Отдых. Стоимость билета: 95 рублей. Время в пути: 59-62 мин. Расписание электричек: http://www.tutu.ru/rasp.php?st1=7402&st2=9502&date=28.08.2015";
    NSString * string_Platform42km = @"От платформы «42-й километр» до выставочного комплекса ежедневно курсируют бесплатные автобусы «МАКС-2015» с 28 августа по 30 август. Внимание! На всех указанных маршрутах начало движения автобусов в 08:15 часов утра.";
    NSString * string_Gate3 = @"Вход на территорию выставки через: КПП3";
    
    NSArray * arrayAnnotation = [[NSArray alloc]initWithObjects:string_MoscowKazanPlatform42km, string_Platform42km, string_Gate3, nil];
    
    //Москва Казанская: 
    CLLocation * coordMoscowKazan = [[CLLocation alloc]initWithLatitude:55.77426791355413 longitude:37.65812873840332];
    
    //Платформа 42 км:
    CLLocation * coordPlatform42km = [[CLLocation alloc]initWithLatitude:55.58339024806601 longitude:38.184356689453125];
    
    //КПП3:
    CLLocation * coordGate3 = [[CLLocation alloc]initWithLatitude:55.56800892048633 longitude:38.15126895904541];
    
    
    
    NSArray * arrayCoord = [[NSArray alloc] initWithObjects: coordMoscowKazan, coordPlatform42km, coordGate3, nil];
    
    
    for (int i = 0; i < arrayCoord.count; i++) {
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        [dict setObject:[arrayCoord objectAtIndex:i] forKey:@"coord"];
        [dict setObject:[arrayAnnotation objectAtIndex:i] forKey:@"annotation"];
        
        [array_RoadTrain addObject:dict];
    }
    

    
    return array_RoadTrain;
    
}




/*

 до платформы Отдых:
 http://www.tutu.ru/rasp.php?st1=7402&st2=9302&date=25.08.2015 
 до платформы 42км:
 http://www.tutu.ru/rasp.php?st1=7402&st2=9502&date=28.08.2015
 
 */




@end
