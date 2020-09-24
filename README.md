# UICore - Great UI Elements

UICore is a library that contains multiples UI elements such as alerts, banners ... Written in Swift 5.


## Installation

Use the [Swift Package Manager](https://swift.org/package-manager/) to install UICore.

```
https://github.com/baptiste-faure1811/UICore.git
```

## Usage
Do not forget to import UICore
```
import UICore
```
# UIBanner

The UIBanner, can show a title, an optional image and can be of different types.
Based on the chosen type the color and haptic feedback will change. 

 - ***Message*** (.message) (default type) : Color : default - Haptic : medium
 - ***Alert*** (.alert) : Color : red - Haptic : strong and double
 - ***Warning*** (.warning) : Color : orange - Haptic : strong
 - ***Info*** (.info) : Color : blue - Haptic : medium

#### Basic banner with no image
```
let banner = UIBanner(message: "Hello, World !")
banner.showBanner()

// OR -- You don't have to create an object
UIBanner(message: "Hello, World !").showBanner()
```

#### With an image 
```
let banner = UIBanner(message: "Hello, World !", image: UIImage(systemName: "hand.wave.fill"))
banner.showBanner()
```

#### Change the banner type
```
let banner = UIBanner(message: "Hello, World !", image: UIImage(systemName: "hand.wave.fill"), type: .alert)
banner.showBanner()
```

### Edit how the banner is shown
#### All the parameters are optional
```
banner.showBanner(duration: 1.2, delay: 0.4, hapticFeedback: false)
// OR
banner.showBanner(duration: 1.2, delay: 0.4, hapticFeedback: true) {
   print("Banner has been shown")
}
```

### Edit default color
#### Default color applies to all '.message' banners
```
UIBanner.defaultTintColor = UIColor(named: "someColor")
```

# UIAlert

The UIAlert has a title, a body and can display up to 4 actions.

***Buttons actions always dismiss the alert.***

#### Basic alert 
```
let alert = UIAlert(title: "Hello, World !", message: "Un message à afficher.", dismissButtonTitle: "OK")
alert.showAlert()

// OR -- You don't have to create an object
UIAlert(title: "Hello, World !", message: "Un message à afficher.", dismissButtonTitle: "OK").showAlert()
```

#### Edit dismiss button title and action
```
// Dismiss button title and tint color
let alert = UIAlert(title: "Hello, World !", message: "Un message à afficher.", dismissButtonTitle: "OK", dismissButtonTintColor: .red)

// Dismiss button action
alert.setDismissButtonAction(action: UIAction(handler: { action in
    print("Dismiss button pressed")
}))
alert.showAlert()
```

#### Add a button
```swift
alert.addButton(title: "Hello", buttonTintColor: .blue, action: UIAction(handler: { action in
print("Hello button pressed")
}))
alert.showAlert()
```

#### Completion handler
```
alert.showAlert {
    print("Alert is shown")
}
alert.showAlert()
```
## Contributing
Do not hesitate to report any bugs or ideas ! For major changes, please open an issue first to discuss what you would like to change.

## See UICore in actions
I use UICore in my apps, try [MedicApp](https://apps.apple.com/fr/app/medicapp/id1483077182) on the AppStore (only available in French).
