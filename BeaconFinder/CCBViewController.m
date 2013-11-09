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
@property (weak, nonatomic) IBOutlet UILabel *proximityUUIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *majorLabel;
@property (weak, nonatomic) IBOutlet UILabel *minorLabel;

@end

@implementation CCBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;

//    NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-8876223462A3"];
    //A52E0A46-E60C-40F9-99FC-F2B69DA7076C
    NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:@"A52E0A46-E60C-40F9-99FC-F2B69DA7076C"];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID identifier:@"SampleBeacon"];
    self.beaconRegion.notifyOnEntry = YES;
    self.beaconRegion.notifyOnExit = YES;
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
    
    NSLog(@"Beacon Count %ld", beacons.count);
    
    CLBeacon *lastBeacon  = [beacons lastObject];
    self.proximityUUIDLabel.text = [lastBeacon.proximityUUID UUIDString];
    self.majorLabel.text = [NSString stringWithFormat:@"Major %@", [lastBeacon.major stringValue]];
    self.minorLabel.text = [NSString stringWithFormat:@"Minor %@", [lastBeacon.minor stringValue]];
    self.proximity.text = [self stringForProximity:lastBeacon.proximity];
    self.accuracyLabel.text = [NSString stringWithFormat:@"accuracy %f", lastBeacon.accuracy];
    self.rssiLabel.text = [NSString stringWithFormat:@"RSSI %ld", (long)lastBeacon.rssi];
    
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error {
    NSLog(@"rangingBeaconsDidFailForRegion");
}

- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region {

    self.statusLabel.text = @"Did Enter Region";

    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
    }

}

- (void)locationManager:(CLLocationManager *)manager
          didExitRegion:(CLRegion *)region {
    
    self.statusLabel.text = @"Did Exit Region";
}

@end
