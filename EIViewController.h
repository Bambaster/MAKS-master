//
//  EIViewController.h
//  WaterfallCollectionView
//
//  Created by Miroslaw Stanek on 12.07.2013.
//  Copyright (c) 2013 Event Info Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWFeedParser.h"

@interface EIViewController : UIViewController <MWFeedParserDelegate> {
    
    // Parsing
    MWFeedParser *feedParser;
    NSMutableArray *parsedItems;
    
    // Displaying
    NSDateFormatter *formatter;
    
}

// Properties
@property (nonatomic, strong) NSArray *itemsToDisplay;

@property (weak, nonatomic) IBOutlet UICollectionView *cv;

@end
