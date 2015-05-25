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
#import "UIView+MotionBlur.h"
#import "UIScrollView+AH3DPullRefresh.h"

typedef void (^NextPointBlock) (void);

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate, MBXRasterTileOverlayDelegate, UIGestureRecognizerDelegate, UISearchBarDelegate>
@property (strong, nonatomic) NextPointBlock nextPointBlock;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) MBXRasterTileOverlay *rasterOverlay;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSArray * array_SearchResults;
@property (strong, nonatomic) NSArray * array_Additional;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *view_TableView;

@property (weak, nonatomic) IBOutlet UIView *view_MapView;

@property (weak, nonatomic) IBOutlet UIButton *button_Menu_UP_Down;

@property (weak, nonatomic) IBOutlet UIView *view_PointsMenu;



@end

@implementation MapViewController {
    BOOL isCurrentLocation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    isUsersViewHiden = NO;
    isSearchBarActive = NO;
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    [self.locationManager startUpdatingLocation];
    [self.locationManager requestAlwaysAuthorization];

    
    [MBXMapKit setAccessToken:MAPBOX_API_KEY];
    self.rasterOverlay = [[MBXRasterTileOverlay alloc] initWithMapID:MAPBOX_STYLE];
    self.rasterOverlay.delegate = self;
    self.rasterOverlay.canReplaceMapContent = YES;
    [self.mapView addOverlay:self.rasterOverlay];
    
    [self setupView];


    
   

}

- (void) setupView {
    //настраиваем вид если не навигация
    
    if (!self.isNavigationMode) {
        
    self.tableView.tableFooterView = [[UIView alloc] init];
    UITextField *textField = [self.searchBar valueForKey:@"_searchField"];
    textField.clearButtonMode = UITextFieldViewModeNever;
    [self.button_Menu_UP_Down addTarget:self action:@selector(menuActions:) forControlEvents:UIControlEventTouchUpInside];
    self.array_Additional = [PlanCoordinates arrayPlanCoordinates];
    self.array_SearchResults = self.array_Additional;
    [self annotation_Plan];
    [self.tableView setPullToRefreshHandler:^{
        
        [self refreshTableView];
        
    }];
         }
    
    
    else  {
        
        //настраиваем вид если навигация, tableView нам не нужен и фикс геолокации

        CGRect newMapFrame = [self.mapView frame];
        newMapFrame.origin.y = 0;
        self.mapView.frame = newMapFrame;

        self.view_PointsMenu.alpha = 0;
        isCurrentLocation = YES;
        self.array_Additional = [PlanCoordinates arrayPlanCoordinates];
        self.array_SearchResults = self.array_Additional;
        [self setPointForNavigation];
        
        
    }
}





- (void) viewWillAppear:(BOOL)animated {
    CGSize result = [[UIScreen mainScreen] bounds].size;
    
    if (result.height == 736) {
        
        CGRect newMapFrame = [self.mapView frame];
        newMapFrame.origin.y = -220;
        self.mapView.frame = newMapFrame;
    }
    
    
}

- (void)dealloc {
    self.mapView = nil;
    self.mapView.delegate = nil;
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
//    [self removeAllAnnotations];
//    [self annotation_Plan];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (isSearchBarActive) {
    isSearchBarActive = NO;
    [self down_Points_View:YES];

        int64_t delayInSeconds = 250;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_MSEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.searchBar resignFirstResponder];
            [self.searchBar setShowsCancelButton:NO animated:YES];
        });


    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

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

- (void) refreshTableView {
    
    self.array_SearchResults = self.array_Additional;
    [self reload_TableView];
    [self.tableView refreshFinished];
    self.searchBar.text = @"";

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

    if (searchBar.text.length == 0) {
        self.array_SearchResults = self.array_Additional;
        
    }

    [self reload_TableView];
    
}


- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar {
    
    NSLog(@"searchBarBookmarkButtonClicked");
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    //код когда начинаем поиск (выезд вью таблицы и карты)
    
    
    isSearchBarActive = YES;
    [searchBar setShowsCancelButton:YES animated:YES];
    
    [self showing_Points_View:YES];
    
    return YES;
}


-(BOOL)textFieldShouldClear:(UITextField *)textField {
    if (textField.tag == 1000) {

        NSLog(@"textFieldShouldClear");
        
        return YES;
    }
    return NO;
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //действие при нажатии на Поиск:
    [self down_Points_View:YES];
    isSearchBarActive = NO;

    int64_t delayInSeconds = 250;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_MSEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [searchBar resignFirstResponder];
        [searchBar setShowsCancelButton:NO animated:YES];

    });
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    //действие при нажатии на Cancel:
    [self down_Points_View:YES];
    isSearchBarActive = NO;

    int64_t delayInSeconds = 250;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_MSEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [searchBar resignFirstResponder];
        [searchBar setShowsCancelButton:NO animated:YES];


    });
    
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



//Анимация вью поднять/опустить

#pragma mark - View Points Animations


- (void) menuActions:(id)sender {
    
    if (!isUsersViewHiden) {
        [self down_Points_View:NO];
    }
    
    else {
        [self showing_Points_View:NO];

    }
}



- (void) showing_Points_View : (BOOL) isSerchng {
    
    int points;
    int map_points;
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if(result.height == 480)
    {
        if (isSerchng) {
            
            points = -(self.view.frame.size.height/2 - 80);

        }
        else {
        points = -(self.view.frame.size.height/2 - 40);
        map_points = -150;
        }
    }
    else if(result.height == 568)
    {
        
        if (isSerchng) {
            points = -(self.tableView.frame.size.height/2 + 73);

        }
        else {
        points = -(self.view.frame.size.height/2 + 2);
        map_points = -150;
        }
    }
    else if (result.height == 667) {
        
        if (isSerchng) {
            
        }
        else {
        points = -(self.view.frame.size.height/2 + 51);
        map_points = -150;
            
        }
    }
    else if (result.height == 736) {
        
        if (isSerchng) {
            
        }
        else {
        
        points = -(self.view.frame.size.height/2 + 81);
        map_points = -220;
        }
        
    }
    
    CGRect newMapFrame = [self.mapView frame];
    newMapFrame.origin.y = newMapFrame.origin.y + map_points;
    
    CGRect newFrame = [self.view_PointsMenu frame];
    newFrame.origin.y = newFrame.origin.y + points;
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
    [self.view_PointsMenu enableBlurWithAngle:M_PI_2 completion:^{
    
    [UIView animateWithDuration:0.5 delay:0.00 usingSpringWithDamping:0.8 initialSpringVelocity:0.3 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.view_PointsMenu.frame = newFrame;
    } completion:^(BOOL finished) {

    }];
        
    }];
    

   if (!isSerchng) {

       isUsersViewHiden = NO;

    [self.view_PointsMenu enableBlurWithAngle:M_PI_2 completion:^{

        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.mapView.frame = newMapFrame;
        } completion:nil];
    
    }];
    }

    
    });
        
        

}




- (void)down_Points_View: (BOOL) isSerchng {
    
    int points;
    int map_points;
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if(result.height == 480)
    {
        if (isSerchng) {
            
        }
        else {
        points = (self.view.frame.size.height/2 - 40);
        map_points = 150;
        }
    }
    else if(result.height == 568)
    {
        if (isSerchng) {
            points = (self.tableView.frame.size.height/2 + 73);

        }
        else {
        points = (self.view.frame.size.height/2 + 2);
        map_points = 150;
        }
    }
    
    else if (result.height == 667) {
        
        if (isSerchng) {
            
        }
        else {
        points = (self.view.frame.size.height/2 + 51);
        map_points = 150;
        }
    }
    
    else if (result.height == 736) {
        if (isSerchng) {
            
        }
        
        else {
        points = (self.view.frame.size.height/2 + 81);
        map_points = 220;
        }
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
   
    CGRect newMapFrame = [self.mapView frame];
    newMapFrame.origin.y = newMapFrame.origin.y + map_points;
    
    CGRect newFrame = [self.view_PointsMenu frame];
    newFrame.origin.y = newFrame.origin.y + points;
    [self.view_PointsMenu enableBlurWithAngle:M_PI_2 completion:^{

    [UIView animateWithDuration:0.5 delay:0.00 usingSpringWithDamping:0.8 initialSpringVelocity:0.3 options:0 animations:^{
        self.view_PointsMenu.frame = newFrame;
    } completion:^(BOOL finished) {

    }];
    }];

  if (!isSerchng) {
    
    isUsersViewHiden = YES;

    [self.view_PointsMenu enableBlurWithAngle:M_PI_2 completion:^{

        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.mapView.frame = newMapFrame;
        } completion:nil];
    }];
    
         }
    });

}



#pragma mark - Navigation


- (void) showPointNavigation: (CLLocationCoordinate2D) coord Dist:(NSUInteger) latitudinalMeters  Dist2:(NSUInteger) longitudinalMeters{
    
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, latitudinalMeters, longitudinalMeters);
    [self.mapView setRegion:region animated:YES];
    
    
}


- (void) setPointForNavigation {
    
    __block NSUInteger index = 0;
    __block NSUInteger dist1 = 0;
    __block NSUInteger dist2 = 0;

    MapViewController * __weak weakSelf = self;
    
    NSArray * arrayPoints = self.array_SearchResults;
    self.nextPointBlock = ^ (void) {
        
        NSDictionary * dict = [arrayPoints objectAtIndex:index];
        CLLocation * newLocation = [[CLLocation alloc] init];
        newLocation = [dict objectForKey:@"coord"];
        
        if (dist1 != 500) {
            dist1 = 500;
            dist2 = 500;
            [weakSelf showPointNavigation:newLocation.coordinate Dist:dist1 Dist2:dist2];
            [weakSelf performSelector:@selector(addPoint) withObject:nil afterDelay:2.0];

        }
        
        else {
            
            dist1 = 5500;
            dist2 = 5500;
            [weakSelf showPointNavigation:newLocation.coordinate Dist:dist1 Dist2:dist2];
            [weakSelf performSelector:@selector(addPoint) withObject:nil afterDelay:2.0];            index ++;
        }
        
        
    };
    
    
    [self addPoint];

}

- (void) addPoint {
    
    self.nextPointBlock ();

}





@end
