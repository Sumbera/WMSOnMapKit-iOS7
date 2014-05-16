//
//  WMSOverlay.h
//  MapView
//
//  Created by Stanislav Sumbera on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface WMSOverlay : NSObject <MKOverlay>{
    NSMutableDictionary *_urlParameters;
}

@property (nonatomic, strong) NSString * url;
@property (nonatomic, assign) float      opacity;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) BOOL      useMercator; // -- if use 900913 mercator projection or WGS84

@property (nonatomic, strong) NSURL     *baseUrl; // base url without the fragment


//------------------------------------------------------------
- (id)initWithName:(NSString*)nameArg
               Url:(NSString*)urlArg
           Opacity: (CGFloat) opacityArg
       UseMercator: (BOOL) useMercatorArg;

- (NSString*) getUrl: (MKMapRect) mapRect zoomScale: (MKZoomScale) zoomScale;

@end
