/*
     File: LaunchMeAppDelegate.m
 Abstract: The application's delegate class.  Handles incoming 
 URL requests.
  Version: 1.7
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2013 Apple Inc. All Rights Reserved.
 
 */

#import "LaunchMeAppDelegate.h"
#import "RootViewController.h"

@implementation LaunchMeAppDelegate

// -------------------------------------------------------------------------------
//	application:openURL:sourceApplication:annotation:
// -------------------------------------------------------------------------------
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{    
    // You should be extremely careful when handling URL requests.
    // Take steps to validate the URL before handling it.
    
    // Check if the incoming URL is nil.
    if (!url)
        return NO;
    
    // Invoke our helper method to parse the incoming URL and extact the color
    // to display.
    UIColor *launchColor = [self extractColorFromLaunchURL:url];
    // Stop if the url could not be parsed.
    if (!launchColor)
        return NO;
    
    // Assign the created color object a the selected color for display in
    // RootViewController.
    [(RootViewController*)self.window.rootViewController setSelectedColor:launchColor];
    
    // Update the UI of RootViewController to notify the user that the app was launched
    // from an incoming URL request.
    [[(RootViewController*)self.window.rootViewController urlFieldHeader] setText:@"The app was launched with the following URL"];
    
    return YES;
}

// -------------------------------------------------------------------------------
//	extractColorFromLaunchURL:
//  Helper method that parses a URL and returns a UIColor object representing
//  the first HTML color code it finds or nil if a valid color code is not found.
//  This logic is specific to this sample.  Your URL handling code will differ.
// -------------------------------------------------------------------------------
- (UIColor*)extractColorFromLaunchURL:(NSURL*)url
{
    // Hexadecimal color codes begin with a number sign (#) followed by six
    // hexadecimal digits.  Thus, a color in this format is represented by
    // three bytes (the number sign is ignored).  The value of each byte
    // corresponds to the intensity of either the red, blue or green color
    // components, in that order from left to right.
    // Additionally, there is a shorthand notation with the number sign (#)
    // followed by three hexadecimal digits.  This notation is expanded to
    // the six digit notation by doubling each digit: #123 becomes #112233.
    
    
    // Convert the incoming URL into a string.  The '#' character will be percent
    // escaped.  That must be undone.
    NSString *urlString = [[url absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    // Stop if the conversion failed.
    if (!urlString)
        return nil;
    
    // Create a regular expression to locate hexadecimal color codes in the
    // incoming URL.
    // Incoming URLs can be malicious.  It is best to use vetted technology,
    // such as NSRegularExpression, to handle the parsing instead of writing
    // your own parser.
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"#[0-9a-f]{3}([0-9a-f]{3})?"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    // Check for any error returned.  This can be a result of incorrect regex
    // syntax.
    if (error)
    {
        NSLog(@"%@", error);
        return nil;
    }
    
    // Extract all the matches from the incoming URL string.  There must be at least
    // one for the URL to be valid (though matches beyond the first are ignored.)
    NSArray *regexMatches = [regex matchesInString:urlString options:0 range:NSMakeRange(0, urlString.length)];
    if (regexMatches.count < 1)
        return nil;
    
    // Extract the first matched string
    NSString *matchedString = [urlString substringWithRange:[regexMatches[0] range]];
    
    // At this point matchedString will look similar to either #FFF or #FFFFFF.
    // The regular expression has guaranteed that matchedString will be no longer
    // than seven characters.
    
    // Extract an ASCII c string from matchedString.  The '#' character should not be
    // included.
    const char *matchedCString = [[matchedString substringFromIndex:1] cStringUsingEncoding:NSASCIIStringEncoding];
    
    // Convert matchedCString into an integer.
    unsigned long hexColorCode = strtoul(matchedCString, NULL, 16);
    
    CGFloat red, green, blue;
    
    if (matchedString.length-1 > 3)
    // If the color code is in six digit notation...
    {
        // Extract each color component from the integer representation of the
        // color code.  Each component has a value of [0-255] which must be
        // converted into a normalized float for consumption by UIColor.
        red = ((hexColorCode & 0x00FF0000) >> 16) / 255.0f;
        green = ((hexColorCode & 0x0000FF00) >> 8) / 255.0f;
        blue = (hexColorCode & 0x000000FF) / 255.0f;
    }
    else
    // The color code is in shorthand notation...
    {
        // Extract each color component from the integer representation of the
        // color code.  Each component has a value of [0-255] which must be
        // converted into a normalized float for consumption by UIColor.
        red = (((hexColorCode & 0x00000F00) >> 8) | ((hexColorCode & 0x00000F00) >> 4)) / 255.0f;
        green = (((hexColorCode & 0x000000F0) >> 4) | (hexColorCode & 0x000000F0)) / 255.0f;
        blue = ((hexColorCode & 0x0000000F) | ((hexColorCode & 0x0000000F) << 4)) / 255.0f;
    }
    
    // Create and return a UIColor object with the extracted components.
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

@end
