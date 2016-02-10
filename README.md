# CreditsKit

A simple way to list third-party licenses in your iOS apps

In order to be able to do this, you to create a .plist with all the third-party libraries and licenses.


You can use the python script available to create this file with the .plist
This python script recursively searches for 'LICENSE.*' files and put them into a friendly plist. 

Usage:

```
./CreditsKit.py -s inputPath/ -o outputPath/FILENAME.plist
```

Then, you can add the .plist created to your XCode project.

The content, in case you build it manually, is something like:

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<array>
	<dict>
		<key>Text</key>
		<string>Here goes the license text. or any other text to show as the description
		<key>Title</key>
		<string>The library name</string>
	</dict>
	<dict>
		...
	</dict>	
</array>
</plist>
```

And use like this:

```objc
CreditsKit* credit = [[CreditsKit alloc] initWithPListFile:@"FILENAME_without_extension"];
[credit setTitle:@"Just a title for the list"];
    
UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:credit];
nav.navigationBar.barTintColor = kSummaryColor;
nav.navigationBar.translucent = NO;
[self presentViewController:nav animated:YES completion:nil];
```
Some screenshots:
![](screenshot1.png)

![](screenshot2.png)
