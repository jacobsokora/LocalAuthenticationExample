# LocalAuthenticationExample
An example for biometric or passcode authentication on iOS

Local authentication on iOS is very easy to implement thanks to the LocalAuthentication library. This example was done on Xcode 10 with swift 4.2.

First things first, make sure you import LocalAuthentication at the top of your file

From there it's as easy as creating an instance of LAContext, which handles all the user interaction for you as well as interfacing with the secure enclave where biometric and passcode information is stored.

The first function you'll call is ```swift canEvaluatePolicy(_ policy: LAPolicy, error: NSErrorPointer) -> Bool``` which will tell you if authentication is possible in the current context. The first arugment is of type ```LAPolicy``` which is an enumeration with two cases, ```.deviceOwnerAuthentication``` or ```.deviceOwnerAuthenticationWithBiometrics``` the first of which will attempt to authenticate with biometrics if available and fall back to the user's passcode, the second of which will basically do the same thing but if biometric authentication is not available on the device this will fail instead of prompting for a passcode unlike the first.

This function also takes an ```NSErrorPointer``` which will tell you what went wrong if the function returns false. While this seems like a new type you have to worry about it's just an alias for a pointer to an ```NSError``` object.

If ```canEvaluatePolicy(_:error:)``` returns true, you can call ```evaluatePolicy(_ policy: LAPolicy, localizedReason: String, reply: @escaping (Bool, Error?) -> Void)``` which takes the same policy as before, a string describing why you need authentication, and a callback taking a boolean indicating whether or not authentication was successful, and an error if authentication fails. If authentication is successful there's no ecryption key or anything like that, you just have to use that boolean value to set the state of your app to authenticated or not authenticated and go from there.

Here's an example of the full thing implemented, with a more in depth example in [LocalAuthenticationViewController](https://github.com/jacobsokora/LocalAuthenticationExample/blob/master/LocalAuthenticationExample/LocalAuthenticationViewController.swift)

```swift
import LocalAuthentication

let context = LAContext()
var error: NSError?
if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
	context.evaluatePolicy(.devideOwnerAuthentication, "Authenticate") { success, error in
		if success {
			//You're authenticated!
		} else if let error = error {
			print(error.localizedDescription)
		}
	}
}
if let error = error {
	print(error.localizedDescription)
}