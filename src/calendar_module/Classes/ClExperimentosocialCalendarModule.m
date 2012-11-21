/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "ClExperimentosocialCalendarModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@implementation ClExperimentosocialCalendarModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"d6b5a8b4-abfb-46cc-ac6d-fcba14f60e17";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"cl.experimentosocial.calendar";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
	
	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup 

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added 
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}

#pragma Public APIs



-(id)createEvent:(id)args {

    
    
    NSDictionary *argDict = [args objectAtIndex:0];
    NSString *title = [argDict objectForKey:@"title"];
	NSDate *startDate = [argDict objectForKey:@"start"];
	NSDate *endDate = [argDict objectForKey:@"end"];
    
    EKEventStore *store = [[EKEventStore alloc] init];
    
    NSLog(@"Title: %@", title);
    
    __block NSString *result = @"OK";

    
    void (^addEventBlock)();
    
    addEventBlock = ^
    {
     
        EKEvent *event = [EKEvent eventWithEventStore: store];
        event.title = title;
        event.startDate = startDate;
        event.endDate = endDate;
        [event setCalendar:[store defaultCalendarForNewEvents]];
        NSError *err;
        [store saveEvent:event span:EKSpanThisEvent error:&err];

        if([err code] == noErr) {
            NSLog(@"OK");
        } else {
            result = @"NO OK";
        }

    };
    
    // We need to verify if we have access to the store ´requestAccessToEntityType´ iOS >= 6
    if ([store respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
    
        // Request for access
        [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            
            if (granted) {
                // We have access then we create the event
                addEventBlock();
            } else {
                result = @"NO OK";
            }
        
        }];
    } else {
        // iOS <= 5, we don't need request access
        addEventBlock();
    }

    return result;
}



@end
