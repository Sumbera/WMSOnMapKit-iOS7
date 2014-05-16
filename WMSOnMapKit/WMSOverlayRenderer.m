//
//  WMSOverlayView.m
//  MapView
//
//  Created by Stanislav Sumbera on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WMSOverlayRenderer.h"
#import "MapViewUtils.h"
#import "MKNetworkOperation.h"
#import "Downloader.h"
#import "WebRequestInfo.h"

@implementation WMSOverlayRenderer

@synthesize mapView;


//------------------------------------------------------------
- (id)initWithWMSLayer:(WMSOverlay*)wmsOverlay 
            MapView: (MKMapView *) view
{
    // -- stores overlay in self.overlay 
    self = [super initWithOverlay:(id <MKOverlay>)wmsOverlay];
    if (self){
        self.mapView = view;
    }
    
    return self;
}

//--set needs display om Main thread
//-----------------------------------------------------------------------------------------
-(void) setNeedsDisplayOnMainThread:(WebRequestInfo*) requestInfo{
    [self setNeedsDisplayInMapRect:requestInfo.mapRect  zoomScale:requestInfo.zoomScale];
    
}
//-------------------------------------------------------------------------------------
-(void) downloadTile:(WebRequestInfo* )requestInfo{
    
    Downloader *downloader = [Downloader defaultDownloader];
    
    MKNetworkOperation *operation = [downloader operationWithURLString:requestInfo.url
                                                                params:nil
                                                            httpMethod:@"GET"];
    
    [operation addDownloadStream:[NSOutputStream outputStreamToFileAtPath:requestInfo.filePath
                                                                   append:YES]];
    
    [downloader enqueueOperation:operation];
    
    
    [operation onDownloadProgressChanged:^(double progress) {
        
        
    }];
    
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        DLog(@"%@", completedOperation);
        [self performSelectorOnMainThread:@selector(setNeedsDisplayOnMainThread:) withObject:requestInfo waitUntilDone:NO];
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        // -- do nothing for now...
        NSLog (@"Error downloading tile %@", requestInfo.url);
        
    }];
}


//-------------------------------------------------------------------------------------
- (BOOL)canDrawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale {
    
    
    WMSOverlay  * wmsOverlay = (WMSOverlay*) self.overlay;
    
    NSString    *urlStr      =  [wmsOverlay getUrl:mapRect zoomScale:zoomScale];
    
    if (!urlStr){
        NSLog(@"Evaluation error !!! \n");
        return NO;
    }
    NSString *filePath = getFilePathForURL(urlStr,TILE_CACHE);
    // -- check if tile is cached
    if ([[NSFileManager defaultManager] fileExistsAtPath: filePath]){
        return YES; // if any file in overlay array is cached we have to draw it.
    }
    
    
    
   // -- download
    else{
        // -- Standard iOS way - doesn't work well - lot of errors in downloading in high trafic requests
        /*
        NSURL *URL = [NSURL URLWithString:urlStr];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   if (error) {
                                       NSLog(@"Error downloading tile ! \n");
                                       
                                   }
                                   else {
                                       [data  writeToFile: filePath  atomically:YES];
                                       [self setNeedsDisplayInMapRect:mapRect zoomScale:zoomScale];
                                   }
                                   
                               }];
        
         */
        
        // -- using MKNetwork Kit
        WebRequestInfo * requestInfo = [[WebRequestInfo alloc] init];
        
        requestInfo.url = urlStr;
        requestInfo.userInfo  = nil;
        requestInfo.filePath = filePath;
        requestInfo.mapRect = mapRect;
        requestInfo.zoomScale= zoomScale;
        
        [self downloadTile:requestInfo];
        
        return NO;

     
    }
    
    
}

//-------------------------------------------------------------------------------------
- (void)drawMapRect:(MKMapRect)mapRect
          zoomScale:(MKZoomScale)zoomScale
          inContext:(CGContextRef)context {
    
    WMSOverlay *wmsOverlay   = (WMSOverlay*) self.overlay;
    NSString     *url      = [wmsOverlay getUrl:mapRect zoomScale:zoomScale];
    UIImage       *image   = TileLoad(url,NO);
    if (image){
        TileDraw(image,mapRect,(double) 1/zoomScale,wmsOverlay.opacity,context);
    }
    
    
}


@end
