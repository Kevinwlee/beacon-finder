//
//  CCBViewController.m
//  BeaconFinder
//
//  Created by Kevin Lee on 11/7/13.
//  Copyright (c) 2013 ChaiONE. All rights reserved.
//

#import "CCBViewController.h"

@interface CCBViewController ()
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UILabel *proximity;
@property (weak, nonatomic) IBOutlet UILabel *accuracyLabel;
@property (nonatomic, strong)CLBeaconRegion *beaconRegion;
@property (weak, nonatomic) IBOutlet UILabel *rssiLabel;
@end

@implementation CCBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;

    NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-8876223462A3"];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID identifier:@"SampleBeacon"];
    
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    [self.locationManager requestStateForRegion:self.beaconRegion];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)checkBeacon:(id)sender {
    [self.locationManager requestStateForRegion:self.beaconRegion];
}

- (NSString *)stringForProximity:(CLProximity) proximity {
    switch (proximity) {
        case CLProximityNear:
            return@"Near";
            break;
        case CLProximityFar:
            return @"Far";
            break;
        case CLProximityImmediate:
            return @"Immediate";
            break;
        case CLProximityUnknown:
            return @"Unknown";
            break;
        default:
            return @"";
            break;
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    switch (state) {
        case CLRegionStateInside:
            self.stateLabel.text = @"INSIDE";
            [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
            break;

        case CLRegionStateOutside:
            self.stateLabel.text = @"OUTSIDE";
            break;
        
        case CLRegionStateUnknown:
            self.stateLabel.text = @"UNKNOWN";
            break;
        
        default:
            self.stateLabel.text = @"";
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region {
    
    NSLog(@"Did Range Beacons");
    CLBeacon *beacon  = [beacons lastObject];
    NSLog(@"Beacon Major %@", [beacon.major stringValue]);
    NSLog(@"Beacon Minor %@", [beacon.minor stringValue]);
    NSLog(@"Beacon Accuracy %f", beacon.accuracy);
    self.proximity.text = [self stringForProximity:beacon.proximity];
    self.accuracyLabel.text = [NSString stringWithFormat:@"accuracy %f", beacon.accuracy];
    self.rssiLabel.text = [NSString stringWithFormat:@"RSSI %d", beacon.rssi];
    
}

/*
 *  locationManager:rangingBeaconsDidFailForRegion:withError:
 *
 *  Discussion:
 *    Invoked when an error has occurred ranging beacons in a region. Error types are defined in "CLError.h".
 */
- (void)locationManager:(CLLocationManager *)manager
rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region
              withError:(NSError *)error {
    
}

/*
 *  locationManager:didEnterRegion:
 *
 *  Discussion:
 *    Invoked when the user enters a monitored region.  This callback will be invoked for every allocated
 *    CLLocationManager instance with a non-nil delegate that implements this method.
 */
- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region {
    self.statusLabel.text = @"Did Enter Region";

    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
    }

}

/*
 *  locationManager:didExitRegion:
 *
 *  Discussion:
 *    Invoked when the user exits a monitored region.  This callback will be invoked for every allocated
 *    CLLocationManager instance with a non-nil delegate that implements this method.
 */
- (void)locationManager:(CLLocationManager *)manager
          didExitRegion:(CLRegion *)region {
    
    self.statusLabel.text = @"Did Exit Region";
}

/*
 *  locationManager:didFailWithError:
 *
 *  Discussion:
 *    Invoked when an error has occurred. Error types are defined in "CLError.h".
 */
//- (void)locationManager:(CLLocationManager *)manager
//       didFailWithError:(NSError *)error {
//    
//}

/*
 *  locationManager:monitoringDidFailForRegion:withError:
 *
 *  Discussion:
 *    Invoked when a region monitoring error has occurred. Error types are defined in "CLError.h".
 */
//- (void)locationManager:(CLLocationManager *)manager
//monitoringDidFailForRegion:(CLRegion *)region
//              withError:(NSError *)error {
//    
//}

/*
 *  locationManager:didStartMonitoringForRegion:
 *
 *  Discussion:
 *    Invoked when a monitoring for a region started successfully.
 */
//- (void)locationManager:(CLLocationManager *)manager
//didStartMonitoringForRegion:(CLRegion *)region {
//    
//}

@end
