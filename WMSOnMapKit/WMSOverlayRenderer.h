//
//  WMSOverlayView.h
//  MapView
//
//  Created by Stanislav Sumbera on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMSOverlay.h"
#import <MapKit/MapKit.h>

@interface WMSOverlayRenderer :  MKOverlayRenderer 

@property (nonatomic, weak) MKMapView        *mapView;

- (id)initWithWMSLayer:(WMSOverlay*)wmsOverlay 
               MapView: (MKMapView *) view;

@end
