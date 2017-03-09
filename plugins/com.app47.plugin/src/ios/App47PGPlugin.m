//
//  Created by ANDREW GLOVER on 8/30/11.
//  Copyright 2011 App47 All rights reserved.
//

#import "App47PGPlugin.h"
#import <EmbeddedAgent/EmbeddedAgent.h>
#import <Cordova/CDV.h>


@implementation App47PGPlugin


- (void) timedEvent:(CDVInvokedUrlCommand *)command
{
    [self.commandDelegate runInBackground:^{
        CDVPluginResult* pluginResult = nil;
        NSString *eventID = nil;
        @try
        {
            NSString *eventName = [command.arguments objectAtIndex:0];
            eventID = [EmbeddedAgent startTimedEvent:eventName];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:eventID];

            int status = [pluginResult.status intValue];
            BOOL keepCallback = [pluginResult.keepCallback boolValue];
            NSString* argumentsAsJSON = [pluginResult argumentsAsJSON];
            NSString* js = [NSString stringWithFormat:@"cordova.require('cordova/exec').nativeCallback('%@',%d,%@,%d)", command.callbackId, status, argumentsAsJSON, keepCallback];

            [[self.viewController performSelector:@selector(webView) withObject:nil]
                                  stringByEvaluatingJavaScriptFromString:js];
        }
        @catch (NSException *ex)
        {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR  messageAsString:[ex reason]];
        }
        @finally {
            if(nil != eventID)
            {
                [EmbeddedAgent endTimedEvent:eventID];
            }
        }
    }];
}

- (void) configurationAsMap:(CDVInvokedUrlCommand *)command
{
    [self.commandDelegate runInBackground:^{
        CDVPluginResult* pluginResult = nil;
        NSDictionary* options = [command.arguments objectAtIndex:0];
        @try
        {
            NSString* group = [options objectForKey:@"group"];
            NSDictionary* dict = [EmbeddedAgent configurationGroupAsDictionary:group];
        
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                           options:0
                                                             error:&error];
        
            if (!jsonData) {
                NSLog(@"Got an error trying to convert into JSON representation: %@", error);
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR  messageAsString:@"unable to convert result into JSON"];
            } else {
                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:jsonString];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        
        }
        @catch (NSException *ex)
        {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR  messageAsString:[ex reason]];
        }
    }];
}

- (void) configurationKeys:(CDVInvokedUrlCommand *)command
{
    [self.commandDelegate runInBackground:^{
        CDVPluginResult* pluginResult = nil;
        NSDictionary* options = [command.arguments objectAtIndex:0];
        @try
        {
            NSString* group = [options objectForKey:@"group"];
            NSArray* arry = [EmbeddedAgent allKeysForConfigurationGroup:group];
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arry
                                                           options:0 
                                                             error:&error];
        
            if (!jsonData) {
                NSLog(@"Got an error trying to convert into JSON representation: %@", error);
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR  messageAsString:@"unable to convert result into JSON"];
            } else {
                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:jsonString];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        }
        @catch (NSException *ex)
        {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR  messageAsString:[ex reason]];
        }
    }];
}

- (void) configurationGroupNames:(CDVInvokedUrlCommand *)command
{
    [self.commandDelegate runInBackground:^{
        CDVPluginResult* pluginResult = nil;
        @try
        {
            NSArray* arry = [EmbeddedAgent configurationGroupNames];
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arry
                                                           options:0
                                                             error:&error];
        
            if (!jsonData) {
                NSLog(@"Got an error trying to convert into JSON representation: %@", error);
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR  messageAsString:@"unable to convert result into JSON"];
            } else {
                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:jsonString];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        }
        @catch (NSException *ex)
        {
            NSLog(@"NSException in configurationGroupNames ");
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR  messageAsString:[ex reason]];
        }
    }];
}


-(void) configurationValue:(CDVInvokedUrlCommand *)command
{
    [self.commandDelegate runInBackground:^{
        CDVPluginResult* pluginResult = nil;
        NSDictionary* options = [command.arguments objectAtIndex:0];
        @try
        {
            NSString* key = [options objectForKey:@"key"];
            NSString* group = [options objectForKey:@"group"];
            id obj = [EmbeddedAgent configurationObjectForKey:key group:group];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:obj];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

        }
        @catch (NSException *ex)
        {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR  messageAsString:[ex reason]];
        }
    }];
}

- (void) log:(CDVInvokedUrlCommand *)command
{
    [self.commandDelegate runInBackground:^{
        CDVPluginResult* pluginResult = nil;
        NSDictionary* options = [command.arguments objectAtIndex:0];
        @try
        {
        
            NSString* logType = [options objectForKey:@"type"];
            if([logType isEqualToString:@"info"])
            {
                EALogInfo(@"%@",[options objectForKey:@"msg"]);
            }
            else if([logType isEqualToString:@"warn"])
            {
                EALogWarn(@"%@",[options objectForKey:@"msg"]);
            }
            else if([logType isEqualToString:@"error"])
            {
                EALogError(@"%@",[options objectForKey:@"msg"]);
            }
            else //must be debug
            {
                EALogDebug(@"%@",[options objectForKey:@"msg"]);
            }
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        @catch (NSException *ex)
        {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR  messageAsString:[ex reason]];
        }
    }];
}

-(void)sendGenericEvent:(CDVInvokedUrlCommand *)command  
{
    [self.commandDelegate runInBackground:^{
        CDVPluginResult* pluginResult = nil;
        @try
        {
        
            NSString *eventName = [command.arguments objectAtIndex:0];
            [EmbeddedAgent sendGenericEvent:eventName];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        @catch (NSException *ex)
        {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR  messageAsString:[ex reason]];
        }
    }];
}

- (void)startTimedEvent:(CDVInvokedUrlCommand *)command
{
    [self.commandDelegate runInBackground:^{
        CDVPluginResult* pluginResult = nil;
        @try
        {
            NSString *eventName = [command.arguments objectAtIndex:0];
            NSString *eventID = [EmbeddedAgent startTimedEvent:eventName];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:eventID];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        @catch (NSException *ex)
        {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR  messageAsString:[ex reason]];
        }
    }];
    
}

- (void)endTimedEvent:(CDVInvokedUrlCommand *)command
{
    [self.commandDelegate runInBackground:^{
        CDVPluginResult* pluginResult = nil;
        @try
        {
            NSString *eventName = [command.arguments objectAtIndex:0];
            [EmbeddedAgent endTimedEvent:eventName];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        @catch (NSException *ex)
        {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR  messageAsString:[ex reason]];
        }
    }];
}


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

@end

