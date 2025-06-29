# ThreadOn

ThreadOn is a sample peer-to-peer communication app that uses Bluetooth (via Apple's MultipeerConnectivity framework) to exchange text messages and files with nearby devices. It does not require an internet connection.

## Features
- Text messaging over Bluetooth
- File transfer capability (images, GIFs, etc.)
- Experimental audio streaming hooks

## Importing the project into Xcode
1. Install [XcodeGen](https://github.com/yonaskolb/XcodeGen) via Homebrew:
   ```bash
   brew install xcodegen
   ```
2. Clone this repository and navigate to its root directory in Terminal.
3. Run `xcodegen` to generate `ThreadOn.xcodeproj` from `project.yml`.
4. Open the generated `ThreadOn.xcodeproj` in Xcode.
5. Build and run the `ThreadOn` target on two nearby iOS devices to test Bluetooth communication.

## Notes
- Bluetooth communication requires the devices to be relatively close and have Bluetooth enabled.
- The audio streaming code is a minimal example and may require additional work to support real-time voice calls.
