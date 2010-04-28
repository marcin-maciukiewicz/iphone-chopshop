//
//  ImageCacheFactory.m
//  Calineczka
//
//  Created by ciukes on 25/10/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ImageCacheFactory.h"
#import "GTMObjectSingleton.h"
#import "GeneralImageCacheDomain.h"
#import "AvatarImageCacheDomain.h"
#import "BundleImageCacheDomain.h"

@implementation ImageCacheFactory

@synthesize _generalCache;
//@synthesize _avatarCache;
@synthesize _bundleCache;

GTMOBJECT_SINGLETON_BOILERPLATE(ImageCacheFactory, sharedImageCache)

-(ImageCache*)newCacheWithDomain:(id<ImageCacheDomain>)domain {
	return [[ImageCache alloc] initWithDomain:domain];
}

-(ImageCache*)getCacheWithDomainId:(ImageCacheDomainId)domainId {
	switch(domainId){
		case ImageCacheDomainIdGeneral:{
			if(!_generalCache){
				id<ImageCacheDomain> generalDomain=[[GeneralImageCacheDomain alloc] init];
				self._generalCache=[[ImageCache alloc] initWithDomain:generalDomain];
				[generalDomain release];
			}
			return _generalCache;
			break;
		}
		/*case ImageCacheDomainIdAvatar:{
			if(!_avatarCache){
				id<ImageCacheDomain> avatarDomain=[[AvatarImageCacheDomain alloc] init];
				self._avatarCache=[[ImageCache alloc] initWithDomain:avatarDomain];
				[avatarDomain release];
			}
			return _avatarCache;
			break;
		}*/
		case ImageCacheDomainIdBundle: {
			if(!_bundleCache){
				id<ImageCacheDomain> tableDomain=[[BundleImageCacheDomain alloc] init];
				self._bundleCache=[[ImageCache alloc] initWithDomain:tableDomain];
				[tableDomain release];
			}
			return _bundleCache;
			break;
		}
	}
	
	return nil;
}

-(void)dealloc {
	[_generalCache release];
//	[_avatarCache release];
	[_bundleCache release];
	
	[super dealloc];
}

+(UIImage*)bundleImageWithFileName:(NSString*)bundleImageFileName {
	ImageCache *bundleImagesCache=[[ImageCacheFactory sharedImageCache] getCacheWithDomainId:ImageCacheDomainIdBundle];
	UIImage *result=[bundleImagesCache imageForKey:bundleImageFileName];
	return result;
}

-(void)removeAllImagesInMemory {
	[_generalCache removeAllImagesInMemory];
//	[_avatarCache removeAllImagesInMemory];
	[_bundleCache removeAllImagesInMemory];		
}

-(void)removeAllImages {
	[_generalCache removeAllImages];
//	[_avatarCache removeAllImages];
	[_bundleCache removeAllImages];	
}

-(void)didReceiveMemoryWarning {
	[self removeAllImagesInMemory];
}

@end
