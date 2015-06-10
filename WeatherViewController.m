//
//  WeatherViewController.m
//  MAKS
//
//  Created by Lowtrack on 08.06.15.
//  Copyright (c) 2015 Vladimir Popov. All rights reserved.
//

#import "WeatherViewController.h"
#import "SCYahooWeatherParser.h"
#import <CoreLocation/CoreLocation.h>

@interface WeatherViewController ()<SCYahooWeatherParserDelegate, CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation WeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isCurrentLocation = NO;
    parseChars = NO;
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    [self.locationManager startUpdatingLocation];
    [self.locationManager requestAlwaysAuthorization];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - WOEID
//
//+ (YWWOEID *) getWOEID:(float)latitude longitude:(float)longitude yahooAPIKey:(NSString *)yahooAPIKey
//{
//    NSString *urlString = [NSString stringWithFormat:@"http://where.yahooapis.com/geocode?q=%f,%f&gflags=R&appid=%@", latitude, longitude, yahooAPIKey];
//    NSURL *url = [NSURL URLWithString:urlString];
//    
//    
//    YWWOEID *woeid = [[YWWOEID alloc] init];
//    
//    
//    
//    //
//    //    TBXMLElement *woeidElement = [TBXML childElementNamed:@"woeid" parentElement:resultElement];
//    //    woeid.woeid = [[TBXML textForElement:woeidElement] intValue];
//    //
//    //    TBXMLElement *cityElement = [TBXML childElementNamed:@"city" parentElement:resultElement];
//    //    woeid.city = [TBXML textForElement:cityElement];
//    
//    return woeid;
//}


- (void) getWOEID:(float)latitude longitude:(float)longitude   {
    
    
    dispatch_queue_t woeidqueue = dispatch_queue_create("woeidqueue", NULL);
    dispatch_async(woeidqueue, ^(void) {
        NSString *request = [NSString stringWithFormat:@"http://query.yahooapis.com/v1/public/yql?q=select * from geo.places where text=\"%@\"&format=xml", @"Moscow"];
        NSString *encRequest = [request stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *URL = [NSURL URLWithString:encRequest];
        parserXML = [[NSXMLParser alloc] initWithContentsOfURL:URL];
        [parserXML setDelegate:self];
        [parserXML parse];

        
    });
    
    
//    NSString *urlString = [NSString stringWithFormat:@"http://where.yahooapis.com/geocode?q=%f,%f&gflags=R&appid=%@", latitude, longitude, YAHOO_KEY];
//    NSURL * url = [NSURL URLWithString:urlString];
//    
//    parserXML = [[NSXMLParser alloc] initWithContentsOfURL:url];
//    
//    [parserXML setDelegate:self];
//    [parserXML setShouldResolveExternalEntities:YES];
//    [parserXML parse];
    
//    
//    feedParser = [[MWFeedParser alloc] initWithFeedURL:url];
//    feedParser.delegate = self;
//    feedParser.feedParseType = ParseTypeFull; // Parse feed info and all items
//    feedParser.connectionType = ConnectionTypeAsynchronously;
//    [feedParser parse];
}


- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (parseChars && !self.woeid) {
        self.woeid = string;
        parseChars = NO;
        NSLog(@"Woeid: %@", self.woeid);
        
        [self getWeather:[self.woeid integerValue]];

    }
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    if ([elementName isEqual:@"woeid"])
    {
        parseChars = YES;
    }
    
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    
    NSLog(@"parserDidStartDocument %@", parser);

}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"parseError %@", parseError);

}
// ...and this reports a fatal error to the delegate. The parser will stop parsing.

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError{
    NSLog(@"validationError %@", validationError);

}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    NSLog(@"parser %@", parser);
}


- (void)getWeather : (NSInteger) weatherID{

    SCYahooWeatherParser *parser1 = [[SCYahooWeatherParser alloc] initWithWOEID:weatherID weatherUnit:SCWeatherUnitCelcius delegate:self];
    [parser1 parse];
}



//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//


#pragma mark -
#pragma mark MWFeedParserDelegate

- (void)feedParserDidStart:(MWFeedParser *)parser {
    NSLog(@"Started Parsing: %@", parser.url);
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
    NSLog(@"Parsed Feed Info: “%@”", parser);
    self.title = info.summary;
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
    NSLog(@"Parsed Feed Item: “%@”", item.summary);
    if (item) [parsedItems addObject:item];
}

- (void)feedParserDidFinish:(MWFeedParser *)parser {
    NSLog(@"Finished Parsing%@", (parser.stopped ? @" (Stopped)" : @""));
//    [self updateTableWithParsedItems];
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
    NSLog(@"Finished Parsing With Error: %@", error);
    if (parsedItems.count == 0) {
        self.title = @"Failed"; // Show failed message in title
    } else {
        // Failed but some items parsed, so show and inform of error
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Parsing Incomplete"
                                                        message:@"There was an error during the parsing of this feed. Not all of the feed items could parsed."
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
    }
}




#pragma mark - SCYahooWeatherParserDelegate
- (void)yahooWeatherParser:(SCYahooWeatherParser *)parser recievedWeatherInformation:(SCWeather *)weather {
    NSLog(@"weather %@  %i  %@  %u", weather, weather.temperature, weather.weatherString, weather.condition);
}


//--------------------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------------


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
    
    
    if (!isCurrentLocation) {
        isCurrentLocation = YES;

        [self getWOEID:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
        
    }
    
}

@end
