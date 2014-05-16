//
//  Donwloader.h
//  SpatialReaderCore
//
//  Created by Stanislav Sumbera on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKNetworkEngine.h"
@interface Downloader : MKNetworkEngine

+ (Downloader *)defaultDownloader;
-(MKNetworkOperation*) downloadFileFrom:(NSString*) remoteURL toFile:(NSString*) filePath;
@end
