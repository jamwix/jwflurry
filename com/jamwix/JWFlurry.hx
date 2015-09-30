package com.jamwix;

import haxe.Json;
import openfl.Lib;

#if cpp
import cpp.Lib;
#elseif neko
import neko.Lib;
#end

#if (android && openfl)
import openfl.utils.JNI;
#end

class JWFlurry {
	
	#if ios
	private static var flurry_initialize = 
		Lib.load ("jwflurry", "jwflurry_initialize", 2);
	private static var flurry_log_event = 
		Lib.load ("jwflurry", "jwflurry_log_event", 3);
	private static var flurry_end_timed_event = 
		Lib.load ("jwflurry", "jwflurry_end_timed_event", 2);
	#elseif android
	private static var flurry_initialize = 
		JNI.createStaticMethod("com.jamwix.JWFlurry", "initFlurry", "(Ljava/lang/String;)V");
	private static var flurry_log_event = 
		JNI.createStaticMethod("com.jamwix.JWFlurry", "logEvent", "(Ljava/lang/String;Ljava/lang/String;)V");
	private static var flurry_end_timed_event = 
		JNI.createStaticMethod("com.jamwix.JWFlurry", "logEvent", "(Ljava/lang/String;Ljava/lang/String;)V");
	#end

	public static function initialize(apiKey:String, reportCrashes:Bool):Void 
	{
		#if ios
		flurry_initialize(apiKey, reportCrashes);
		#elseif android
		flurry_initialize(apiKey);
		#end
	}
	
	public static function logEvent(eventName:String, dParams:Dynamic = null, isTimed:Bool = false):Void
	{
		#if (ios || android)
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

		#if ios
		flurry_log_event(eventName, sParams, isTimed);
		#elseif 
		flurry_log_event(eventName, sParams);
		#end
		#end
	}

	public static function endTimedEvent(eventName:String, dParams:Dynamic = null):Void
	{
		#if (ios || android)
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
}


