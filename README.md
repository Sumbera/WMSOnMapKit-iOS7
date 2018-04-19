
WMSOnMapKit-iOS
=====================
Update 2018 for iOS11 there is also a hack to enable ARKit
<a href="http://www.youtube.com/watch?feature=player_embedded&v=499iX4_ifHw
" target="_blank"><img src="http://img.youtube.com/vi/499iX4_ifHw/0.jpg" 
 /></a>

Update 2017 for iOS9 : check this video that sets in this sample  mkMapView.mapType = MKMapTypeHybridFlyover;
in [MapViewController.m Line 38] ( https://github.com/Sumbera/WMSOnMapKit-iOS7/blob/master/WMSOnMapKit/MapViewController.m#L38 )

<a href="http://www.youtube.com/watch?feature=player_embedded&v=-EfvoIJQkbs
" target="_blank"><img src="http://img.youtube.com/vi/-EfvoIJQkbs/0.jpg" 
 /></a>
 
sample code of using WMS in MapKit on iOS

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
