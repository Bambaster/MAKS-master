//
//  MapViewController.h
//  MAKS
//
//  Created by Lowtrack on 18.05.15.
//  Copyright (c) 2015 Vladimir Popov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <MBXMapKit/MBXMapKit.h>



@interface MapViewController : UIViewController <UITextFieldDelegate> {
    
    BOOL isUsersViewHiden;
    BOOL isSearchBarActive;

}



@end
