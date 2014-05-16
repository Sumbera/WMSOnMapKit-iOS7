//
//  MapViewUtils.h
//  MapView
//
//  Created by Stanislav Sumbera on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <CommonCrypto/CommonDigest.h>
#import <Foundation/Foundation.h>
#import <netdb.h>

#define TILE_SIZE 256
#define MINIMUM_ZOOM 0
#define MAXIMUM_ZOOM 25

#define TILE_CACHE   @"TILE_CACHE"


//------------------------------------------------------------
NS_INLINE CGRect cgRectForMapRect(MKMapRect mapRect){
    CGRect rect = CGRectMake(mapRect.origin.x, mapRect.origin.y, mapRect.size.width, mapRect.size.height);
    return rect;
}
//------------------------------------------------------------
NS_INLINE  MKMapRect mapRectForCGRect(CGRect cgRect){
    MKMapRect mapRect = MKMapRectMake(cgRect.origin.x,cgRect.origin.y,cgRect.size.width,cgRect.size.height);
    return mapRect;
}

//------------------------------------------------------------
NS_INLINE NSUInteger TileZ(MKZoomScale zoomScale){
    double numTilesAt1_0 = MKMapSizeWorld.width / TILE_SIZE; // 256 is a tile size
    NSInteger zoomLevelAt1_0 = log2(numTilesAt1_0);  // add 1 because the convention skips a virtual level with 1 tile.
    NSInteger zoomLevel = MAX(0, zoomLevelAt1_0 + floor(log2f(zoomScale) + 0.5));
    return zoomLevel;
}

// -- calculates zoom scale form mapview taking in account scale of the main screen
//------------------------------------------------------------
NS_INLINE float mapViewZoomScale(MKMapView *mapView){
    return (mapView.frame.size.width*[[UIScreen mainScreen] scale]) / mapView.visibleMapRect.size.width;
}


//------------------------------------------------------------
NS_INLINE NSUInteger TileX(MKMapRect mapRect,MKZoomScale zoomScale){
    return  floor((MKMapRectGetMinX(mapRect) * zoomScale) / TILE_SIZE);
}

//------------------------------------------------------------
NS_INLINE NSUInteger TileY(MKMapRect mapRect,MKZoomScale zoomScale){
    return  floor((MKMapRectGetMinY(mapRect) * zoomScale) / TILE_SIZE);
}

//----------------------------------------------------------------------------
NS_INLINE double xOfColumn(NSInteger column,NSInteger zoom){
    
	double x = column;
	double z = zoom;
    
	return x / pow(2.0, z) * 360.0 - 180;
}
//----------------------------------------------------------------------------

NS_INLINE  double yOfRow(NSInteger row,NSInteger zoom){
    
	double y = row;
	double z = zoom;
    
	double n = M_PI - 2.0 * M_PI * y / pow(2.0, z);
	return 180.0 / M_PI * atan(0.5 * (exp(n) - exp(-n)));
}



//-------------------------------------------------------------------------------------
NS_INLINE  double MercatorXofLongitude(double lon){
    return  lon * 20037508.34 / 180;
}

//------------------------------------------------------------
NS_INLINE double MercatorYofLatitude(double lat){
    double y = log(tan((90 + lat) * M_PI / 360)) / (M_PI / 180);
    y = y * 20037508.34 / 180;
    
    return y;
}

//--------------------------------------------------------------------------------------------------
NS_INLINE NSString* md5Hash (NSString* stringData) {
    NSData *data = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5([data bytes], (unsigned int)[data length], result);
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
            ];
}

//--------------------------------------------------------------------------------------------------
NS_INLINE BOOL createPathIfNecessary (NSString* path) {
    BOOL succeeded = YES;
    
    NSFileManager* fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:path]) {
        succeeded = [fm createDirectoryAtPath: path
                  withIntermediateDirectories: YES
                                   attributes: nil
                                        error: nil];
    }
    
    return succeeded;
}

//--------------------------------------------------------------------------------------------------
NS_INLINE  NSString*  cachePathWithName(NSString* name) {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* cachesPath = [paths objectAtIndex:0];
    NSString* cachePath = [cachesPath stringByAppendingPathComponent:name];
    
    createPathIfNecessary(cachesPath);
    createPathIfNecessary(cachePath);
    
    return cachePath;
}


//--------------------------------------------------------------------------------------------------

NS_INLINE  NSString*  getFilePathForURL( NSString* url,NSString* folderName){
    return [cachePathWithName(folderName) stringByAppendingPathComponent:md5Hash(url)];
}


//------------------------------------------------------------
NS_INLINE void cacheUrlToLocalFolder(NSString* url,NSData* data, NSString* folderName){
    NSString *localFilePath =   getFilePathForURL(url,folderName);  
    [data writeToFile: localFilePath atomically:YES];
    
}

//-------------------------------------------------------------------------------------
NS_INLINE UIImage* TileLoad(NSString* url,BOOL online){ 
    UIImage  *image = nil;
    
    NSString * filePath = getFilePathForURL(url,TILE_CACHE);
    // -- file is cached ?
    if ([[NSFileManager defaultManager] fileExistsAtPath: filePath]){
        image = [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath]];
    }
    else if (online){
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString: url]];
        [imgData writeToFile: filePath atomically:YES];
        image =[UIImage imageWithData:imgData];
    }
    return image;
}


//------------------------------------------------------------
NS_INLINE void TileDraw(UIImage* image, 
                        MKMapRect mapRect, 
                        double contextScale, 
                        CGFloat opacity, 
                        CGContextRef context ){
    
    if (image == nil){
        NSLog(@"Image is nil !");
        return;
    }
    CGRect rect = cgRectForMapRect(mapRect);
    CGContextSaveGState(context);
    {
        CGContextSetAlpha(context, opacity);
        CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
        CGContextScaleCTM(context, contextScale, contextScale);
        CGContextTranslateCTM(context, 0, image.size.height);
        CGContextScaleCTM(context, 1, -1);
        CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), [image CGImage]);
    };
    CGContextRestoreGState(context);
    
    // debug
    //CGContextSetRGBStrokeColor(context, 1, 0, 0, 1.0);
    //CGContextSetLineWidth(context, 6.0 / zoomScale);
    //CGContextStrokeRect(context, rect);
    //NSString *countStr = [NSString stringWithFormat:@"+"];
    //CGContextShowTextAtPoint(context, 10.0 , 100.0, [countStr UTF8String] , 2);
    
}

