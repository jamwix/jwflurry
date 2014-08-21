#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif


#include <hx/CFFI.h>
#include <stdio.h>
#include "JWFlurry.h"


using namespace jwflurry;

static value jwflurry_initialize(value apiKey, value reportCrashes) 
{
	#ifdef IPHONE
	initJWFlurry(val_string(apiKey), val_bool(reportCrashes));
	#endif
	return alloc_null();
}
DEFINE_PRIM (jwflurry_initialize, 2);

static value jwflurry_log_event(value eventName, value eventParams, value isTimed) 
{
	#ifdef IPHONE
	logJWEvent(val_string(eventName), val_string(eventParams), val_bool(isTimed));
	#endif
	return alloc_null();
}
DEFINE_PRIM (jwflurry_log_event, 3);

static value jwflurry_end_timed_event(value eventName, value eventParams) 
{
	#ifdef IPHONE
	endJWTimedEvent(val_string(eventName), val_string(eventParams));
	#endif
	return alloc_null();
}
DEFINE_PRIM (jwflurry_end_timed_event, 2);

extern "C" void jwflurry_main() 
{
	val_int(0); // Fix Neko init
}
DEFINE_ENTRY_POINT(jwflurry_main);

extern "C" int jwflurry_register_prims() { return 0; }

