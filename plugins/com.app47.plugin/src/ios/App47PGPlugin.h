//
//
//  Created by ANDREW GLOVER on 8/30/11.
//  Copyright 2011 App47 All rights reserved.
//

#import <Cordova/CDV.h>

@interface App47PGPlugin : CDVPlugin

- (void) sendGenericEvent:(CDVInvokedUrlCommand *)command;
- (void) startTimedEvent:(CDVInvokedUrlCommand *)command;
- (void) endTimedEvent:(CDVInvokedUrlCommand *)command;
- (void) timedEvent:(CDVInvokedUrlCommand *)command;
- (void) log:(CDVInvokedUrlCommand *)command;
- (void) configurationValue:(CDVInvokedUrlCommand *)command;
- (void) configurationAsMap:(CDVInvokedUrlCommand *)command;
- (void) configurationKeys:(CDVInvokedUrlCommand *)command;
- (void) configurationGroupNames:(CDVInvokedUrlCommand *)command;

@end
 
