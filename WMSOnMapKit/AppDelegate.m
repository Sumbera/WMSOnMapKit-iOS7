//
//  AppDelegate.m
//  WMSOnMapKit
//
//  Created by Stanislav Sumbera on 16/05/14.
//  Copyright (c) 2014 sumbera. All rights reserved.
//
#import <MapKit/MapKit.h>
#import "AppDelegate.h"
#import "MapViewController.h"
#import "WMSTileOverlay.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    MapViewController * mapViewController = [[MapViewController alloc] init];
    
    UINavigationController *mainNavCtrl = [[UINavigationController alloc]initWithRootViewController:mapViewController];
    
    self.window.rootViewController = mainNavCtrl;
    
    [self.window makeKeyAndVisible];
    
    
    NSString * url = @"http://services.cuzk.cz/wms/wms.asp?&LAYERS=KN&REQUEST=GetMap&SERVICE=WMS&VERSION=1.3.0&FORMAT=image/png&TRANSPARENT=TRUE&STYLES=&CRS=EPSG:900913&WIDTH=256&HEIGHT=256";
    [ mapViewController.mkMapView addOverlay:[[WMSTileOverlay alloc] initWithName:@"Katastr" Url:url Opacity:1 UseMercator:YES]];

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
