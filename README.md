# Weather-Minder

## How to use this app
- Checkout from the repo https://github.com/momin96/Weather-Minder with branch name `main`
- Open with Xcode 14.1 or later as the project uses `Swift 5.7`
- Either connect Device or use simlator.
- Incase using Physical device, makes sure that you make proper changes in SignIn Capcblities.
- Makes sure that physical device support has minimum 15.0
- Hit run from top left corner.
- Allow for location permission. 
- Incase using Simulator makes sure you Simulate the location from Xcode
- Required API is already included, which I ll revert in some days

## The App Supports
- Both iPhone & iPad
- Dynamic Types
- Landscape & Portrait orientation.
- Dark/Light theme

## App makes uses of
- Swift as Programming language.
- SwiftUI for UI desiging.
- Core Location framwork.
- New Structure Concurrency
- Modified Clean Architecture with ViewModel.
- Dependency Injection.
- Temporary Storage interm of `UserDefaults`

## There is NO
- Cocoapods
- Swift package manager
- No external dependencies

## These are parties involved from top to bottom hierarchy
- View Layer
- ViewModel Layer
- UseCase layer
- Sevice Layer

## Note:
- One layer only know about its adjecent layer, such as `View` layer knows only about `ViewModel` rest of other layer are unknown to `View` & same thing is for other layer too.
- Very limited Unit Tests are covered in due to time constraints.

Demo

https://user-images.githubusercontent.com/9208271/225377995-7b92c1cf-3629-4c23-a319-ecff6c454b82.mp4


