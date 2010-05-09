//
//  FetchLocation.m
//
//	Copyright 2009 Marcin Maciukiewicz (mm@csquirrel.com)
//
//	Licensed under the Apache License, Version 2.0 (the "License");
//	you may not use this file except in compliance with the License.
//	You may obtain a copy of the License at
//
//	http://www.apache.org/licenses/LICENSE-2.0
//
//	Unless required by applicable law or agreed to in writing, software
//	distributed under the License is distributed on an "AS IS" BASIS,
//	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//	See the License for the specific language governing permissions and
//	limitations under the License.
//

#import "GeoLocationService.h"
#import "GTMObjectSingleton.h"

@implementation GeoLocationService

@synthesize _locationManager;
@synthesize _currentLocation;
@synthesize _lastUpdate;
@synthesize _operationQueue;
@synthesize _pendingDelegates;
@synthesize fakeLocation;

@dynamic	currentLocation;
@dynamic	desiredAccuracy;
@dynamic	distanceFilter;

#pragma mark -
#pragma mark Singleton definition
GTMOBJECT_SINGLETON_BOILERPLATE(GeoLocationService, sharedInstance);

#pragma mark -
#pragma mark Constructor and destructor
- (id) init {
	self = [super init];
	if (self != nil) {
		self._lastUpdate=[[NSDate alloc] init];
		
		self._locationManager = [[[CLLocationManager alloc] init] autorelease];
		self._locationManager.delegate=self;
		_locationManager.desiredAccuracy=kCLLocationAccuracyBest;
		_locationManager.distanceFilter=5;
		_operationQueue=[[NSOperationQueue alloc] init];
		_pendingDelegates=[[NSMutableArray alloc] init];
		
		[_locationManager startUpdatingLocation];
	}
	return self;
}

-(void)dealloc {
	[_locationManager release];
	[_currentLocation release];
	[_lastUpdate release];
	[_operationQueue release];
	[_pendingDelegates release];
	[fakeLocation release];
	
	[super dealloc];
}

#pragma mark -
-(BOOL)serviceEnabled {
	return _locationManager.locationServicesEnabled;
}

-(void)fetch:(id<GeoLocationServiceDelegate>) aDelegate {
	if(_currentLocation!=nil){
		CLLocation *newLoc=[_currentLocation copy];
		[aDelegate performSelector:@selector(locationUpdate:) withObject:newLoc];
	} else {
		BOOL isEnabled=_locationManager.locationServicesEnabled;
		if(isEnabled){
			[_locationManager startUpdatingLocation];
			[_pendingDelegates addObject:aDelegate];			
		}else{
			[aDelegate locationServiceDisabled];
		}
	}
}

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation {
	NSDate* eventDate = newLocation.timestamp;
	NSTimeInterval howRecent = abs([eventDate timeIntervalSinceNow]);
	_attempts++;    
	
	// is the location newer or not?
	if((newLocation.coordinate.latitude != oldLocation.coordinate.latitude) && (newLocation.coordinate.longitude != oldLocation.coordinate.longitude))
		_locationChanged = YES;
	else
		_locationChanged = NO;
	
#ifdef __i386__
	// Don't care about simulator. It always points to the Apple HQ
	if (howRecent < 5.0) {
#else
	// case 1: GPS sends at start 3 fast updates. Only the last one is accurate.
	if((_locationChanged && (howRecent < 5.0) && _attempts==3) || 
	   // case 2: this is position update when user moves. normal work.
	   (_locationChanged && _attempts>=3)){
#endif   
		// use fake location?
		if(fakeLocation){
			self._currentLocation=fakeLocation;
		} else {
			self._currentLocation=newLocation;			
		}

		// flush all the waiting delegates
		for(id<GeoLocationServiceDelegate> delegate in _pendingDelegates) {
			@try {
				[delegate locationUpdate:_currentLocation];
			} @catch (NSException * exception) {
				NSLog(@"GeoLocFetchLocation: Caught exception: %@ %@",exception.name, exception.reason);
			}
		}
		[_locationManager stopUpdatingLocation];
	}
}

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error {
	// flush the pending operations
	NSEnumerator *enumerator=[[NSArray arrayWithArray:_pendingDelegates] objectEnumerator];
	[_pendingDelegates removeAllObjects];
	id<GeoLocationServiceDelegate> delegate;
	while(delegate=[enumerator nextObject]){
		NSOperation *op=[[NSInvocationOperation alloc] initWithTarget:delegate selector:@selector(locationError:) object:error];
		[_operationQueue addOperation:op];
		[op release];
	}	
}

#pragma mark -
#pragma mark Dynamic accessors
-(CLLocation*)currentLocation {
	return _currentLocation;
}
	
-(CLLocationAccuracy)desiredAccuracy {
	return _locationManager.desiredAccuracy;
}

-(void)setDesiredAccuracy:(CLLocationAccuracy)newAccuracy {
	if(newAccuracy==_locationManager.desiredAccuracy) return;
	_locationManager.desiredAccuracy=newAccuracy;
}
	
	
-(CLLocationDistance)distanceFilter {
	return _locationManager.distanceFilter;
}
	
-(void)setDistanceFilter:(CLLocationDistance)newDistanceFilter {
	if(newDistanceFilter==_locationManager.distanceFilter) return;
	_locationManager.distanceFilter=newDistanceFilter;
}
	
@end
