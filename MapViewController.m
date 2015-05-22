//
//  MapViewController.m
//  MAKS
//
//  Created by Lowtrack on 18.05.15.
//  Copyright (c) 2015 Vladimir Popov. All rights reserved.
//

#import "MapViewController.h"
#import "PlanCoordinates.h"
#import "CustomTableViewCell.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate, MBXRasterTileOverlayDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) MBXRasterTileOverlay *rasterOverlay;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray * arrayPlan;



@end

@implementation MapViewController {
    BOOL isCurrentLocation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    [self.locationManager startUpdatingLocation];
    [self.locationManager requestAlwaysAuthorization];
    

    [MBXMapKit setAccessToken:MAPBOX_API_KEY];
    self.rasterOverlay = [[MBXRasterTileOverlay alloc] initWithMapID:MAPBOX_STYLE];
    self.rasterOverlay.delegate = self;
    self.rasterOverlay.canReplaceMapContent = YES;
    [self.mapView addOverlay:self.rasterOverlay];

    self.arrayPlan = [[NSMutableArray alloc]init];
    self.arrayPlan = [PlanCoordinates arrayPlanCoordinates];
  //  [self annotation_Plan];
   

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MKMapViewDelegate protocol implementation

- (void)tileOverlayDidFinishLoadingMetadataAndMarkers:(MBXRasterTileOverlay *)overlay{

    
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    // This is boilerplate code to connect tile overlay layers with suitable renderers
    //
    if ([overlay isKindOfClass:[MBXRasterTileOverlay class]])
    {
        MBXRasterTileRenderer *renderer = [[MBXRasterTileRenderer alloc] initWithTileOverlay:overlay];
        return renderer;
    }
    return nil;
}

- (void) setupMapView: (CLLocationCoordinate2D) coord {
    
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 900, 900);
    [self.mapView setRegion:region animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    //устанавливаем маркер (из определенной картинки) на карту
    if (![annotation isKindOfClass:MKUserLocation.class]) {
        
        MKAnnotationView*annView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Annotation"];
        annView.canShowCallout = NO;
        annView.image = [UIImage imageNamed:@"MapPoint.png"];
        
        [annView addSubview:[self getCalloutView:annotation.title]]; //вызываем метод, который подписывает адрес над маркером
        
        return annView;
        
    }
    
    
    return nil;
}

//--------------------------------------------------------------------------------------------------------------------------

- (UIView*) getCalloutView: (NSString*) title { // метод, который подписывает данные над маркером
    
    //создаем вью для вывода адреса:
    UIView * callView = [[UIView alloc]initWithFrame:CGRectMake(-60, -50, 150, 50)];
    callView.backgroundColor = [UIColor whiteColor];
    callView.layer.borderWidth = 1.0;
    callView.layer.cornerRadius = 7.0;
    
    
    callView.tag = 1000;
    callView.alpha = 0; //делаем прозрачной вью с адресом, чтобы не высвечивалось на карте при установке маркеров
    
    //создаем лейбл для вывода адреса
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(1, 1, 150, 50)];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping; // перенос по словам
    label.textAlignment = NSTextAlignmentCenter; //выравнивание по центру
    label.textColor = [UIColor blackColor];
    label.text = title;
    label.font = [UIFont fontWithName: @"Arial" size: 10.0];
    
    [callView addSubview:label];
    
    return callView;
    
    
}

//--------------------------------------------------------------------------------------------------------------------------

- (void) annotation_Plan {
   //по координатам из массива устанавливаем аннотации
    //позже в этот метод по ключам добавить картинки соответвтующих объектов
    for (int i = 0; i < self.arrayPlan.count; i++) {
        NSDictionary * dict = [self.arrayPlan objectAtIndex:i];
        CLLocation * newLocation = [[CLLocation alloc] init];
        newLocation = [dict objectForKey:@"coord"];
        
        CLGeocoder * geocoder = [[CLGeocoder alloc]init];
        [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            //CLPlacemark * place = [placemarks objectAtIndex:0];
            
            NSString * stringAnnotation = [[NSString alloc] initWithFormat:@"%@\n%@", [dict valueForKey:@"value"], [dict valueForKey:@"descript"]];
            
            MKPointAnnotation * annotation = [[MKPointAnnotation alloc]init];
            annotation.title = stringAnnotation;
            annotation.coordinate = newLocation.coordinate;
            
            
            [self.mapView addAnnotation:annotation]; //добавляем на карту аннотацию
        }];
    }

}

//--------------------------------------------------------------------------------------------------------------------------

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    //данный метод делает видимой вью с адресом при нажатии на маркер
    if (![view.annotation isKindOfClass:MKUserLocation.class]) {
        for (UIView * subView in view.subviews) {
            if (subView.tag == 1000) {
                subView.alpha = 1;
            }
        }
    }
    
}


- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    //данный метод делает невидимой вью с адресом при нажатии на другой элемент
    for (UIView * subView in view.subviews) {
        if (subView.tag == 1000) {
            subView.alpha = 0;
        }
    }
    
}

//--------------------------------------------------------------------------------------------------------------------------


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {

    
    
    if (!isCurrentLocation) {
        isCurrentLocation = YES;
        newLocation = [[CLLocation alloc] initWithLatitude:55.564969546415156 longitude:38.13911586999893];
        [self setupMapView:newLocation.coordinate];
        
    }
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.arrayPlan.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * simpleTaibleIndefir = @"CellMap";
    CustomTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:simpleTaibleIndefir];
    
    cell.label_Value.text = [[self.arrayPlan objectAtIndex:indexPath.row]objectForKey:@"value"];
    cell.label_Descript.text = [[self.arrayPlan objectAtIndex:indexPath.row]objectForKey:@"descript"];
    
    
    //высчитываем координаты между пользователем и объектом и выводим их в label_Distance:
    NSDictionary * dict = [self.arrayPlan objectAtIndex:indexPath.row];
    CLLocation * newLocation = [[CLLocation alloc] init];
    newLocation = [dict objectForKey:@"coord"];
    CLLocation * locationManager = self.locationManager.location;
    float betweenDistance=[newLocation distanceFromLocation:locationManager];
    NSString * stringBetweenDistance = [NSString stringWithFormat:@"%f", betweenDistance];
    NSString * newStringDistance = [stringBetweenDistance substringToIndex:5];
    cell.label_Distance.text = [NSString stringWithFormat:@"%@ м", newStringDistance];

    return cell;
    
}


#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self removeAllAnnotations];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //по индексу ячейки находим координаты в массиве self.arrayPlan и устанавливаем данные координаты по центру карты
    NSDictionary * dict = [self.arrayPlan objectAtIndex:indexPath.row];
    CLLocation * newLocation = [[CLLocation alloc] init];
    newLocation = [dict objectForKey:@"coord"];
    [self setupMapView:newLocation.coordinate];
    
    //по полученным координатам устанавливаем аннотацию:
    CLGeocoder * geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark * place = [placemarks objectAtIndex:0];
        //записываем адрес с индексом в NSString
        NSString * stringAnnotation = [[NSString alloc] initWithFormat:@"%@\n%@", [place.addressDictionary valueForKey:@"value"], [place.addressDictionary valueForKey:@"descript"]];
        
        MKPointAnnotation * annotation = [[MKPointAnnotation alloc]init];
        annotation.title = stringAnnotation;
        annotation.coordinate = newLocation.coordinate;
        
        
        [self.mapView addAnnotation:annotation]; //добавляем на карту аннотацию
        
    }];
    
}

//--------------------------------------------------------------------------------------------------------------------------


//метод, который убирает аннотации с карты:
- (void) removeAllAnnotations {
    id userAnnotation = self.mapView.userLocation;
    NSMutableArray*annotations = [NSMutableArray arrayWithArray:self.mapView.annotations];
    [annotations removeObject:userAnnotation];
    [self.mapView removeAnnotations:annotations];
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
