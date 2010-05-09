//
//  ImageCacheFactory.h
//  Calineczka
//
//  Created by ciukes on 25/10/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageCache.h"
#import "ImageCacheDomain.h"

enum {
	ImageCacheDomainIdGeneral,
	ImageCacheDomainIdBundle,
} typedef ImageCacheDomainId;


@interface ImageCacheFactory : NSObject {
	ImageCache *_generalCache;
//	ImageCache *_avatarCache;
	ImageCache *_bundleCache;
}

@property(nonatomic,retain) ImageCache *_generalCache;
//@property(nonatomic,retain) ImageCache *_avatarCache;
@property(nonatomic,retain) ImageCache *_bundleCache;

+ (ImageCacheFactory*)sharedImageCache;

-(ImageCache*)newCacheWithDomain:(id<ImageCacheDomain>)domain;
-(ImageCache*)getCacheWithDomainId:(ImageCacheDomainId)domainId;
-(void)removeAllImages;
-(void)removeAllImagesInMemory;
-(void)didReceiveMemoryWarning;

+(UIImage*)bundleImageNamed:(NSString*)bundleImageFileName;

@end
