//
//  WMSTileOverlay.m
//  WMSOnMapKit
//
//  Created by Stanislav Sumbera on 17/05/14.
//  Copyright (c) 2014 sumbera. All rights reserved.
//

#import "WMSTileOverlay.h"
#import "MapViewUtils.h"

@implementation WMSTileOverlay


//------------------------------------------------------------
- (id)initWithUrl:(NSString*)urlArg  UseMercator: (BOOL) useMercatorArg
{
    
    if ((self = [self init])) {
        self.url  = urlArg;
        self.useMercator = useMercatorArg;
    }
    return self;
}
//------------------------------------------------------------
- (NSURL *)URLForTilePath:(MKTileOverlayPath)path{
    // BBOX in WGS84
    double  left   =   xOfColumn(path.x,path.z); //minX
    double right  = xOfColumn(path.x+1,path.z); //maxX
    double bottom = yOfRow(path.y+1,path.z); //minY
    double top    = yOfRow(path.y,path.z); //maxY
    
    // BBOX in mercator
    if (self.useMercator){
        left   = MercatorXofLongitude(left); //minX
        right  = MercatorXofLongitude(right); //maxX
        bottom = MercatorYofLatitude(bottom); //minY
        top    = MercatorYofLatitude(top);      //maxY
    }
    NSString * resolvedUrl = [NSString stringWithFormat:@"%@&BBOX=%f,%f,%f,%f",self.url,left,bottom,right,top];
    
    NSLog(@"Url tile overlay %@", resolvedUrl);
    return [NSURL URLWithString:resolvedUrl];
    
}

//------------------------------------------------------------
- (void)loadTileAtPath:(MKTileOverlayPath)path result:(void (^)(NSData *tileData, NSError *error))  result{
    
    NSURL    *url =  [self URLForTilePath: path];
  
    
    NSString *filePath = getFilePathForURL([url absoluteString],TILE_CACHE);
    // -- check if tile is cached
    if ([[NSFileManager defaultManager] fileExistsAtPath: filePath]){
         NSData *tileData = [NSData dataWithContentsOfFile:filePath];
         result (tileData, nil);
    }
    // -- download
    else{
         NSURLRequest *request = [NSURLRequest requestWithURL:url];
         [NSURLConnection sendAsynchronousRequest:request
         queue:[NSOperationQueue mainQueue]
         completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                             if (error) {
                                 NSLog(@"Error downloading tile ! \n");
                                 result(nil, error);
                                 
                             }
                             else {
                                [data  writeToFile: filePath  atomically:YES];
                                 result (data, nil);
                             }
         
         }];
         
    }

}

@end
