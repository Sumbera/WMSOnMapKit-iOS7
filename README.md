WMSOnMapKit-iOS7
================
sample code of using WMS in MapKit on iOS7, works on iOS8 too

iOS7 introduced new class MKTileOverlay sample derives from this class WMSTileOverlay

Key method to custom tile loading (and cache control) is loadTileAtPath:result

        – (void)loadTileAtPath:(MKTileOverlayPath)path result:(void (^)(NSData *tileData, NSError *error))  result

this method is called by MapKit (or better by MKTileOverlayRenderer ) when it needs to draw a tile . It asks for NSData (and error) from x,y,z tile coordinates. In this method you can  load NSData either from local cache or from NSURLConnection and pass resulting NSData (when ready)  back to MapKit, for example like this (reading from cache)

        result ([NSData dataWithContentsOfFile:filePath], nil);

if you do not need to use cache and you do not provide loadTileAtPath method , you can use another hook (callback) that is provided by MKTileOverlay, URLForTilePath:path

        – (NSURL *)URLForTilePath:(MKTileOverlayPath)path

this method enables to custom format URL required to load tile, thus you can use WMS HTTP-GET parameters, for example :

        NSString * resolvedUrl = [NSString stringWithFormat:@”%@&BBOX=%f,%f,%f,%f”,self.url,left,bottom,right,top];

if there is neither method in the derived class, then you probably do not need to derive at all from MKTileOverlay and directly use it with initWithUrlTemplate (not case for WMS, but for any other x,y,z  sources)


Example of using WMS source  

                NSString * url = @"http://services.cuzk.cz/wms/wms.asp?&LAYERS=KN&REQUEST=GetMap&SERVICE=WMS&VERSION=1.3.0&FORMAT=image/png&TRANSPARENT=TRUE&STYLES=&CRS=EPSG:900913&WIDTH=256&HEIGHT=256";
             [ mapViewController.mkMapView addOverlay:[[WMSTileOverlay alloc] initWithUrl:url UseMercator:YES]];

info available also here : http://blog.sumbera.com/2014/05/17/wms-on-mapkit-with-ios7/
