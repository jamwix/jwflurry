package com.jamwix;

import haxe.Json;
import openfl.Lib;

class JWFlurry {
	
	public static function initialize(apiKey:String, reportCrashes:Bool):Void 
	{
		#if ios
		flurry_initialize(apiKey, reportCrashes);
		#end
	}
	
	public static function logEvent(eventName:String, dParams:Dynamic = null, isTimed:Bool = false):Void
	{
		#if ios
		var sParams = null;
		try 
		{
			if (dParams != null)
			{
				sParams = Json.stringify(dParams);
			}
		}
		catch (err:String)
		{
			trace("Unable to stringify flurry params");
			return;
		}

		flurry_log_event(eventName, sParams, isTimed);
		#end
	}

	public static function endTimedEvent(eventName:String, dParams:Dynamic = null):Void
	{
		#if ios
		var sParams = null;
		try 
		{
			if (dParams != null)
			{
				sParams = Json.stringify(dParams);
			}
		}
		catch (err:String)
		{
			trace("Unable to stringify flurry params");
			return;
		}

		flurry_end_timed_event(eventName, sParams);
		#end
	}

	// Native Methods
	
	
	#if ios
	private static var flurry_initialize = 
		Lib.load ("jwflurry", "jwflurry_initialize", 2);
	private static var flurry_log_event = 
		Lib.load ("jwflurry", "jwflurry_log_event", 3);
	private static var flurry_end_timed_event = 
		Lib.load ("jwflurry", "jwflurry_end_timed_event", 2);
	#end
	
}


