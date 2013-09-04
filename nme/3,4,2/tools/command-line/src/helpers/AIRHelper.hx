package helpers;


import sys.FileSystem;


class AIRHelper {
	
	
	private static var defines:Hash <String>;
	private static var target:String;
	private static var targetFlags:Hash <String>;
	
	
	public static function initialize (defines:Hash <String>, targetFlags:Hash <String>, target:String, NME:String):Void {
		
		AIRHelper.defines = defines;
		AIRHelper.targetFlags = targetFlags;
		AIRHelper.target = target;
		
		switch (target) {
			
			case "ios":
				
				IOSHelper.initialize (defines, targetFlags, NME);
			
			case "android":
				
				AndroidHelper.initialize (defines);
			
		}
		
	}
	
	
	public static function build (workingDirectory:String, targetPath:String, applicationXML:String, files:Array <String>, debug:Bool):Void {
		
		var airTarget = "air";
		var extension = ".air";
		
		if (target == "ios") {
			
			if (targetFlags.exists ("simulator")) {
				
				if (debug) {
					
					airTarget = "ipa-debug-interpreter-simulator";
					
				} else {
					
					airTarget = "ipa-test-interpreter-simulator";
					
				}
				
			} else {
				
				if (debug) {
					
					airTarget = "ipa-debug";
					
				} else {
					
					airTarget = "ipa-test";
					
				}
				
			}
			
			extension = ".ipa";
			
		} else if (target == "android") {
			
			if (debug) {
				
				airTarget = "apk-debug";
				
			} else {
				
				airTarget = "apk";
				
			}
			
			extension = ".apk";
			
		}
		
		var signingOptions = [ "-storetype", defines.get ("KEY_STORE_TYPE"), "-keystore", defines.get ("KEY_STORE") ];
		
		if (defines.exists ("KEY_STORE_PASSWORD")) {
			
			signingOptions.push ("-storepass");
			signingOptions.push (defines.get ("KEY_STORE_PASSWORD"));
			
		}
		
		var args = [ "-package" ];
		
		if (airTarget == "air") {
			
			args = args.concat (signingOptions);
			args.push ("-target");
			args.push ("air");
			
		} else {
			
			args.push ("-target");
			args.push (airTarget);
			args = args.concat (signingOptions);
			
		}
		
		if (target == "ios") {
			
			args.push ("-provisioning-profile");
			args.push (defines.get ("PROVISION_PROFILE"));
			
		}
		
		args = args.concat ([ targetPath + ".ipa", applicationXML ]);
			
		/*if (target == "ios") {
			
			args.push ("-platformsdk");
			args.push (IOSHelper.getSDKDirectory ());
			
		}*/
		
		args = args.concat (files);
		//args = args.concat ([ sourcePath /*, "icon_16.png", "icon_32.png", "icon_48.png", "icon_128.png"*/ ]);
		
		//if either field is invalid, take it out
		
		if(defines.get("WIN_SUPPORTS_PHONE") == "")
		{
			defines.remove("WIN_SUPPORTS_PHONE");
		}
		
		if(defines.get("WIN_SUPPORTS_TABLET") == "")
		{
			defines.remove("WIN_SUPPORTS_TABLET");
		}
		
		trace("STENCYL START THE HARD WORK");
		
		if(InstallTool.isWindows)
		{
			if(StringTools.endsWith(defines.get("AIR_SDK"), "/"))
			{
				defines.set("AIR_SDK", defines.get("AIR_SDK").substr(0, defines.get("AIR_SDK").length-1));
			}

			Sys.putEnv("PATH", Sys.getEnv("PATH") + ";" + defines.get("AIR_SDK") + "bin\\" + ";");
			ProcessHelper.runCommand (workingDirectory, "adt.bat", args);
		}
		
		else
		{
			ProcessHelper.runCommand (workingDirectory, defines.get ("AIR_SDK") + "bin/adt", args);
		}
	}
	
	
	public static function run (workingDirectory:String, debug:Bool):Void {
		
		if (target == "android") {
				
			AndroidHelper.install (FileSystem.fullPath (workingDirectory) + "/" + defines.get ("APP_FILE") + ".apk");
			
		} else if (target == "ios") {
			
			var args = [ "-platform", "ios" ];
			
			if (targetFlags.exists ("simulator")) {
				
				args.push ("-device");
				args.push ("ios-simulator");
				args.push ("-platformsdk");
				args.push (IOSHelper.getSDKDirectory ());
				
				ProcessHelper.runCommand ("", "killall", [ "iPhone Simulator" ], true, true);
				
			}
			
			trace("STENCYL ABOUT TO RUN");
			
			if(InstallTool.isWindows)
			{
				if(StringTools.endsWith(defines.get("AIR_SDK"), "/"))
				{
					defines.set("AIR_SDK", defines.get("AIR_SDK").substr(0, defines.get("AIR_SDK").length-1));
				}
	
				Sys.putEnv("PATH", Sys.getEnv("PATH") + ";" + defines.get("AIR_SDK") + "bin\\" + ";");
				ProcessHelper.runCommand (workingDirectory, "adt.bat", [ "-installApp" ].concat (args).concat ([ "-package", FileSystem.fullPath (workingDirectory) + "/" + defines.get ("APP_FILE") + ".ipa" ]));
			}
			
			else
			{
				ProcessHelper.runCommand (workingDirectory, defines.get ("AIR_SDK") + "/bin/adt", [ "-installApp" ].concat (args).concat ([ "-package", FileSystem.fullPath (workingDirectory) + "/" + defines.get ("APP_FILE") + ".ipa" ]));
			}
			
			trace("STENCYL DONE");
			
			if (targetFlags.exists ("simulator")) {
				
				ProcessHelper.runCommand ("", "open", [ "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Applications/iPhone Simulator.app/" ]);
				
			}
				
		} else {
			
			var args = [ "-profile", "desktop" ];
			
			if (!debug) {
				
				args.push ("-nodebug");
				
			}
			
			args.push ("application.xml");
			
			ProcessHelper.runCommand (workingDirectory, defines.get ("AIR_SDK") + "/bin/adl", args);
			
		}
		
	}
		

}