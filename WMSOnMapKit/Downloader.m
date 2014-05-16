//
//  Donwloader.m
//  SpatialReaderCore
//
//  Created by Stanislav Sumbera on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Downloader.h"

@implementation Downloader

static Downloader *sharedDownloader = nil;
#pragma mark - Memory management
//Singleton
//-----------------------------------------------------------------
+ (Downloader *)defaultDownloader
{
    // ensure singleton is thread safe
    @synchronized(self) {
        if(!sharedDownloader){
            sharedDownloader = [[Downloader alloc] initWithHostName:nil customHeaderFields:nil];
        }
        return sharedDownloader;
    }
    
}

// User can still create multiple instances using init
//-----------------------------------------------------------------
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

//-----------------------------------------------------------------
-(MKNetworkOperation*) downloadFileFrom:(NSString*) remoteURL toFile:(NSString*) filePath {
    
    MKNetworkOperation *op = [self operationWithURLString:remoteURL 
                                                   params:nil
                                               httpMethod:@"GET"];
    
    [op addDownloadStream:[NSOutputStream outputStreamToFileAtPath:filePath
                                                            append:YES]];
    
    [self enqueueOperation:op];
    return op;
}

@end
