//
//  DetailNewsViewController.m
//  MAKS
//
//  Created by Lowtrack on 05.06.15.
//  Copyright (c) 2015 Vladimir Popov. All rights reserved.
//

#import "DetailNewsViewController.h"

@interface DetailNewsViewController ()
- (IBAction)back:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewNews;

@end

@implementation DetailNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    [self.viewNews addSubview:self.viewN];
//    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 70, self.imageNews.size.width, self.imageNews.size.height)];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)back:(id)sender {
    
    
    [self dismissViewControllerAnimated:YES completion:nil];

}
@end
