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

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate, MBXRasterTileOverlayDelegate, UIGestureRecognizerDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) MBXRasterTileOverlay *rasterOverlay;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSArray * array_SearchResults;
@property (strong, nonatomic) NSArray * array_Additional;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *view_TableView;

@property (weak, nonatomic) IBOutlet UIView *view_MapView;


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

    self.array_Additional = [PlanCoordinates arrayPlanCoordinates];
    self.array_SearchResults = self.array_Additional;
    [self annotation_Plan];
   

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//--------------------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------------

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
    
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 700, 700);
    [self.mapView setRegion:region animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    //устанавливаем маркер (из определенной картинки) на карту
    if (![annotation isKindOfClass:MKUserLocation.class]) {
        
        MKAnnotationView*annView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Annotation"];
        annView.canShowCallout = NO;
        annView.image = [UIImage imageNamed:@"MapPoint.png"];
        
        return annView;
        
    }
    
    
    return nil;
}



//--------------------------------------------------------------------------------------------------------------------------

- (void) annotation_Plan {
   //по координатам из массива устанавливаем аннотации
    //позже в этот метод по ключам добавить картинки соответвтующих объектов
    for (int i = 0; i < self.array_SearchResults.count; i++) {
        NSDictionary * dict = [self.array_SearchResults objectAtIndex:i];
        CLLocation * newLocation = [[CLLocation alloc] init];
        newLocation = [dict objectForKey:@"coord"];
        
        CLGeocoder * geocoder = [[CLGeocoder alloc]init];
        [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {

            MKPointAnnotation * annotation = [[MKPointAnnotation alloc]init];
            annotation.coordinate = newLocation.coordinate;
            
            [self.mapView addAnnotation:annotation]; //добавляем на карту аннотацию
        }];
    }

}

//--------------------------------------------------------------------------------------------------------------------------
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
//--------------------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------------

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.array_SearchResults.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * simpleTaibleIndefir = @"CellMap";
    CustomTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:simpleTaibleIndefir];
    
    cell.label_Value.text = [[self.array_SearchResults objectAtIndex:indexPath.row]objectForKey:@"value"];
    cell.label_Descript.text = [[self.array_SearchResults objectAtIndex:indexPath.row]objectForKey:@"descript"];
    
    
    //высчитываем координаты между пользователем и объектом и выводим их в label_Distance:
    NSDictionary * dict = [self.array_SearchResults objectAtIndex:indexPath.row];
    CLLocation * newLocation = [[CLLocation alloc] init];
    newLocation = [dict objectForKey:@"coord"];
    CLLocation * locationManager = self.locationManager.location;
    float betweenDistance=[newLocation distanceFromLocation:locationManager];
    NSString * stringBetweenDistance = [NSString stringWithFormat:@"%f", betweenDistance];
    NSString * newStringDistance = [stringBetweenDistance substringToIndex:5];
    cell.label_Distance.text = [NSString stringWithFormat:@"%@ м", newStringDistance];

    return cell;
    
}

//--------------------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------------

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self removeAllAnnotations];
    [self annotation_Plan];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //по индексу ячейки находим координаты в массиве self.arrayPlan и устанавливаем данные координаты по центру карты
    NSDictionary * dict = [self.array_SearchResults objectAtIndex:indexPath.row];
    CLLocation * newLocation = [[CLLocation alloc] init];
    newLocation = [dict objectForKey:@"coord"];
    [self setupMapView:newLocation.coordinate];
    
    //по полученным координатам устанавливаем аннотацию:
    CLGeocoder * geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        MKPointAnnotation * annotation = [[MKPointAnnotation alloc]init];
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

//--------------------------------------------------------------------------------------------------------------------------
//метод, который перезагружает таблицу:
- (void) reload_TableView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];});
}

//--------------------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------------

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"value contains[cd] %@",
                                    searchText];
    
    self.array_SearchResults = [self.array_Additional filteredArrayUsingPredicate:resultPredicate];

    
    [self reload_TableView];
    
}

//- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
//    //код когда начинаем поиск (выезд вью таблицы и карты)
//}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //действие при нажатии на Поиск:
    [searchBar resignFirstResponder]; 
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    //действие при нажатии на Cancel:
    [searchBar resignFirstResponder];
    self.array_SearchResults = self.array_Additional;
    [self reload_TableView];
    
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
