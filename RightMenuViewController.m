//
//  RightMenuViewController.m
//  MAKS
//
//  Created by Lowtrack on 21.05.15.
//  Copyright (c) 2015 Vladimir Popov. All rights reserved.
//

#import "RightMenuViewController.h"
#import "MapViewController.h"

@interface RightMenuViewController ()

- (IBAction)mainScreen_Action:(id)sender;

- (IBAction)mapScreen_Action:(id)sender;

- (IBAction)newsScreen_Action:(id)sender;

- (IBAction)navigation:(id)sender;


@end

@implementation RightMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)mainScreen_Action:(id)sender {
    
    
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"firstViewController"]]
                                                 animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}

- (IBAction)mapScreen_Action:(id)sender {
    
    MapViewController * map = [self.storyboard instantiateViewControllerWithIdentifier:@"mapScreen"];
    map.isNavigationMode = NO;
    
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:map] animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}

- (IBAction)newsScreen_Action:(id)sender {
    
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"newsScreen"]]
                                                 animated:YES];
    [self.sideMenuViewController hideMenuViewController];
    
}

- (IBAction)navigation:(id)sender {
    
    
    MapViewController * map = [self.storyboard instantiateViewControllerWithIdentifier:@"mapScreen"];
    map.isNavigationMode = YES;
    
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:map] animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}
@end
