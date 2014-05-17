//
//  MapViewController.h
//  MapView
//
//  Created by Stanislav Sumbera on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface MapViewController : UIViewController <MKMapViewDelegate>

@property(nonatomic, readonly, weak) MKMapView *mkMapView;


@end
