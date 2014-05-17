WMSOnMapKit-iOS7
================
sample code of using WMS in MapKit on iOS7

More info on http://blog.sumbera.com/2014/05/17/wms-on-mapkit-with-ios7/
Example of using WMS source  

    NSString * url = @"http://services.cuzk.cz/wms/wms.asp?&LAYERS=KN&REQUEST=GetMap&SERVICE=WMS&VERSION=1.3.0&FORMAT=image/png&TRANSPARENT=TRUE&STYLES=&CRS=EPSG:900913&WIDTH=256&HEIGHT=256";
    [ mapViewController.mkMapView addOverlay:[[WMSTileOverlay alloc] initWithUrl:url UseMercator:YES]];
