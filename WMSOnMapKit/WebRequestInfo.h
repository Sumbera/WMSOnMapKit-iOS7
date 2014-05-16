//
//  WebRequestInfo.h
//  MapView
//
//  Created by Stanislav Sumbera on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface WebRequestInfo : NSObject

@property (nonatomic, strong) NSString*   url;
@property (nonatomic, strong) NSString*   filePath;
@property (nonatomic, assign)int          requestId;
@property (nonatomic, strong) id          userInfo;
@property (nonatomic, strong) NSError    *error;
@property(nonatomic, assign) MKMapRect  mapRect;
@property(nonatomic, assign) MKZoomScale zoomScale;



@end
