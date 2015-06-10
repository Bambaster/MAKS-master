//
//  WeatherViewController.h
//  MAKS
//
//  Created by Lowtrack on 08.06.15.
//  Copyright (c) 2015 Vladimir Popov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWFeedParser.h"

@interface WeatherViewController : UIViewController <MWFeedParserDelegate, NSXMLParserDelegate> {
    
    // Parsing
    MWFeedParser *feedParser;
    NSMutableArray *parsedItems;
    NSXMLParser *parserXML;
    BOOL parseChars;

    BOOL isCurrentLocation;
    
}
@property (strong, nonatomic) NSString *woeid;

@end
