//
//  PlanCoordinates.m
//  MAKS
//
//  Created by Admin on 19.05.15.
//  Copyright (c) 2015 Vladimir Popov. All rights reserved.
//

#import "PlanCoordinates.h"

@implementation PlanCoordinates


+ (NSMutableArray *) arrayPlanCoordinates {
    
    NSMutableArray * arrayPlanCoord = [[NSMutableArray alloc]init];
    
    NSString * snringValue = @"Парковка, Парковка 1, Парковка 2 Восточная, Парковка 2 Западная, Парковка 3, Парковка 4, Парковка 6, Парковка 7, Медпомощь, МЧС, Полиция, Конгресс Центр, Пресс Центр, Дирекция, Туалет, Туалет, Туалет, Туалет, Туалет, КПП 1, КПП 2, КПП 3, Ресторан, Ресторан, Ресторан, Приорити зона";
    NSString * stringDescript = @"VIP, VIP, Для легкового автотранпорта, Для легкового автотранспорта, Для легкового автотранспорта, Для автобусов, Для легкового автотранспорта, Для легкового автотранспорта, Телефон: 103, Телефон: 112, Телефон: 102,  ,  , Телефон Дирекции,  у павильона F1,  у павильона D2,  у павильона D9,  у Стоянки аэростатов №1, у Полиции, Вход/Выход № 1, Вход/Выход № 2, Вход/Выход № 3, Стационарный,  у павильона D2,  у павильона F1,   ";
    NSString * stringKey = @"Parking, Parking1, Parking2East, Parking2West, Parking3, Parking4, Parking6, Parking7, Clinic, Emercom, Police, CongressCenter, PressCenter, ManagmentOffice, WCF1, WCD3, WCD9, WCOCD2, WCPolice, Gate1, Gate2, Gate3, StationaryRestaurant, RestaurantD2, RestaurantF1, PriorityZone";
    
    NSArray * arrayValue = [snringValue componentsSeparatedByString:@", "];
    NSArray * arrayDescript = [stringDescript componentsSeparatedByString:@", "];
    NSArray * arrayKey = [stringKey componentsSeparatedByString:@", "];
    
    
    //координаты парковок:
    CLLocation * coordParking = [[CLLocation alloc]initWithLatitude:55.56217414599677 longitude:38.142254054546356];
    CLLocation * coordParking1 = [[CLLocation alloc]initWithLatitude:55.56647409630745 longitude:38.13307285308838];
    CLLocation * coordParking2East = [[CLLocation alloc]initWithLatitude:55.568934032573395 longitude:38.14137428998947];
    CLLocation * coordParking2West = [[CLLocation alloc] initWithLatitude:55.568934032573395 longitude:38.13571214675903];
    CLLocation * coordParking3 = [[CLLocation alloc]initWithLatitude:55.56762067023417 longitude:38.15358638763428];
    CLLocation * coordParking4 = [[CLLocation alloc]initWithLatitude:55.56762067023417 longitude:38.15847873687744];
    CLLocation * coordParking6 = [[CLLocation alloc]initWithLatitude:55.56519401920977 longitude:38.121700286865234];
    CLLocation * coordParking7 = [[CLLocation alloc]initWithLatitude:55.57052487109443 longitude: 38.13045769929886];
    
    
    // медпомощь:
    CLLocation * coordClinic = [[CLLocation alloc]initWithLatitude:55.564418975953934 longitude:38.14328134059906];
    
    // МЧС:
    CLLocation * coordEmercom = [[CLLocation alloc]initWithLatitude:55.565671777981905 longitude:38.147932291030884];
    
    // Полиция:
    CLLocation * coordPolice = [[CLLocation alloc]initWithLatitude:55.565671777981905 longitude:38.147932291030884];
    
    // Конгресс центр:
    CLLocation * coordCongressCenter = [[CLLocation alloc]initWithLatitude:55.56664396122328 longitude:38.139019310474396];
    
    // Пресс центр:
    CLLocation * coordPressCenter = [[CLLocation alloc]initWithLatitude:55.56664396122328 longitude:38.139019310474396];
    
    // Дирекция:
    CLLocation * coordManagmentOffice = [[CLLocation alloc]initWithLatitude:55.564969546415156 longitude:38.13911586999893];
    
    // Туалеты:
    CLLocation * coordWCPavilionF1 = [[CLLocation alloc]initWithLatitude:55.56459946684512 longitude:38.13812613487244];
    CLLocation * coordWCPavilionD3 = [[CLLocation alloc]initWithLatitude:55.56536237296391 longitude:38.13853919506073];
    CLLocation * coordWCPavilionD9 = [[CLLocation alloc]initWithLatitude:55.56537905662998 longitude:38.14199656248093];
    CLLocation * coordWC_OCD2 = [[CLLocation alloc]initWithLatitude:55.56537298984314 longitude:38.145778477191925];
    CLLocation * coordWC_Police = [[CLLocation alloc]initWithLatitude:55.56540787385469 longitude:38.147127628326416];
    
    //КПП:
    CLLocation * coordGate1 = [[CLLocation alloc]initWithLatitude:55.568324370990446 longitude:38.13230037689209];
    CLLocation * coordGate2 = [[CLLocation alloc]initWithLatitude:55.56822730956671 longitude:38.1395959854126];
    CLLocation * coordGate3 = [[CLLocation alloc]initWithLatitude:55.56800892048633 longitude:38.15126895904541];
    
    //Стационарный ресторан:
    CLLocation * coordStationaryRestaurant = [[CLLocation alloc]initWithLatitude:55.56560656046023 longitude:38.13978910446167];
    
    //Рестораны:
    CLLocation * coordRestaurantD2 = [[CLLocation alloc]initWithLatitude:55.565303221727106 longitude:38.137686252593994];
    CLLocation * coordRestaurantF1 = [[CLLocation alloc]initWithLatitude:55.56423545075206 longitude:38.13830852508545];
    
    //Приорити зона:
    CLLocation * coordPriorityZone = [[CLLocation alloc]initWithLatitude:55.561335335397494 longitude:38.14311504364014];
    
    NSArray * arrayCoord = [[NSArray alloc] initWithObjects:
                            coordParking, coordParking1, coordParking2East, coordParking2West, coordParking3, coordParking4, coordParking6, coordParking7,
                            coordClinic, coordEmercom, coordPolice, coordCongressCenter, coordPressCenter, coordManagmentOffice,
                            coordWCPavilionF1, coordWCPavilionD3, coordWCPavilionD9, coordWC_OCD2, coordWC_Police,
                            coordGate1, coordGate2, coordGate3,
                            coordStationaryRestaurant, coordRestaurantD2, coordRestaurantF1,
                            coordPriorityZone, nil];
    
    for (int i = 0; i < arrayCoord.count; i++) {
        
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        
        [dict setObject:[arrayValue objectAtIndex:i] forKey:@"value"];
        [dict setObject:[arrayDescript objectAtIndex:i] forKey:@"descript"];
        [dict setObject:[arrayKey objectAtIndex:i] forKey:@"key"];
        [dict setObject:[arrayCoord objectAtIndex:i] forKey:@"coord"];
        
        [arrayPlanCoord addObject:dict];
        
    }
    
    
    return arrayPlanCoord;
    
}


@end
