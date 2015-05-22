//
//  CustomTableViewCell.h
//  MAKS
//
//  Created by Admin on 19.05.15.
//  Copyright (c) 2015 Vladimir Popov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *label_Value;
@property (strong, nonatomic) IBOutlet UILabel *label_Descript;
@property (strong, nonatomic) IBOutlet UILabel *label_Distance;

@end
