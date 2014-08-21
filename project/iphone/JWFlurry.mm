#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/UIKit.h>
#include "JWFlurry.h"
#include "Flurry.h"

@interface JWFlurry: NSObject 

- (void)initWithApiKey: (NSString*) apiKey doReportCrashes:(BOOL) reportCrashes;
- (void)logEvent: (NSString*) eventName withParams: (NSDictionary*) params isTimed: (BOOL) isTimed;
- (void)endTimedEvent: (NSString*) eventName withParams: (NSDictionary*) params;

@end

@implementation JWFlurry

- (void)initWithApiKey: (NSString*) apiKey doReportCrashes:(BOOL) reportCrashes
{
    [Flurry setCrashReportingEnabled: reportCrashes];
    [Flurry startSession: apiKey];
}

- (void)logEvent: (NSString*) eventName withParams: (NSDictionary*) params isTimed: (BOOL) isTimed
{
    NSLog(@"Logging event '%@' isTimed: %d with params: %@", eventName, isTimed, params);
    if (params)
    {
        if (isTimed)
            [Flurry logEvent: eventName withParameters: params timed: isTimed];
        else
            [Flurry logEvent: eventName withParameters: params];

        return;
    }

    if (isTimed)
    {
        [Flurry logEvent: eventName timed: isTimed];
        return;
    }

    [Flurry logEvent: eventName];
}

- (void)endTimedEvent: (NSString*) eventName withParams: (NSDictionary*) params
{
    [Flurry endTimedEvent: eventName withParameters: params];
}

@end

extern "C"
{
	static JWFlurry* myFlurry = nil;
    
    NSDictionary* parseParamsJW(const char *sParams)
    {
        if (!sParams || strlen(sParams) <= 0) return nil;

        NSString *params = [ [NSString alloc] initWithUTF8String: sParams ];
        NSData *data = [params dataUsingEncoding:NSUTF8StringEncoding];

        NSError *error;
        NSDictionary *parameters = 
            [NSJSONSerialization JSONObjectWithData: data options: 0 error: &error];
        if (error)
        {
            NSLog(@"Unable to parse params %@", params);
            return nil;
        }

        return parameters;
    }

    void initJWFlurry(const char *sApiKey, bool bReportCrashes)
    {
		NSString *apiKey = [ [NSString alloc] initWithUTF8String: sApiKey ];
        BOOL reportCrashes = NO;
        if (bReportCrashes) reportCrashes = YES;

        myFlurry = [[JWFlurry alloc] init];
        [myFlurry initWithApiKey: apiKey doReportCrashes: reportCrashes];
    }

    void logJWEvent(const char *sEventName, const char *sEventParams, bool isTimed)
    {
		NSString *eventName = [ [NSString alloc] initWithUTF8String: sEventName ];
        NSDictionary *parameters = parseParamsJW(sEventParams);

        [myFlurry logEvent: eventName withParams: parameters isTimed: isTimed];
    }

    void endJWTimedEvent(const char *sEventName, const char *sEventParams)
    {
		NSString *eventName = [ [NSString alloc] initWithUTF8String: sEventName ];
        NSDictionary *parameters = parseParamsJW(sEventParams);
        
        [myFlurry endTimedEvent: eventName withParams: parameters];
    }
}
