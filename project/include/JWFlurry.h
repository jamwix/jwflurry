#ifndef FLURRY_H
#define FLURRY_H

namespace jwflurry
{	
    extern "C"
    {	
	    void initJWFlurry(const char *sApiKey, bool bReportCrashes);
	    void logJWEvent(const char *sEventName, const char *sEventParams, bool isTimed);
	    void endJWTimedEvent(const char *sEventName, const char *sEventParams);
    }
}

#endif
