//
//  FetchLocation.h
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

#import <CoreLocation/CoreLocation.h>

#pragma mark -
@protocol GeoLocationServiceDelegate <NSObject>
	@required
	-(void)locationUpdate:(CLLocation *)newLocation;
@optional
	-(void)locationError:(NSError*)error;
	-(void)locationServiceDisabled;
@end


#pragma mark -
@interface GeoLocationService : NSObject <CLLocationManagerDelegate> {
	CLLocationManager			*_locationManager;
	CLLocation					*_currentLocation;
	NSOperationQueue			*_operationQueue;
	NSMutableArray				*_pendingDelegates;
	NSDate						*_lastUpdate;
	NSUInteger					_attempts;
	BOOL						_locationChanged;
	
	@public
	CLLocation					*fakeLocation;	
	CLLocation					*currentLocation;
	CLLocationAccuracy			desiredAccuracy;
	CLLocationDistance			distanceFilter;
}

	@property (nonatomic, retain)		CLLocationManager	*_locationManager;
	@property (nonatomic, retain)		CLLocation			*_currentLocation;
	@property (nonatomic, retain)		NSDate				*_lastUpdate;
	@property (nonatomic, retain)		NSOperationQueue	*_operationQueue;
	@property (nonatomic, retain)		NSMutableArray		*_pendingDelegates;
	//
	@property (nonatomic, retain)		CLLocation			*fakeLocation;
	@property (nonatomic, readonly)		CLLocation			*currentLocation;
	@property							CLLocationAccuracy	desiredAccuracy;
	@property							CLLocationDistance	distanceFilter;


	+(GeoLocationService *) sharedInstance;
	-(void)fetch:(id<GeoLocationServiceDelegate>) callback;
	-(BOOL)serviceEnabled;

@end
