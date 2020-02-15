![Boing](Images/boing.png)

# Boing
Boing is a simple and powerful animation API for views written in Swift. Inspired by many other animation libraries out there, it tries to aggregate and simplify many options into a single and seamless integration that can be reused in any project.

## Installation

### Swift Package Manager

### Cocoapods

To add the pod to your project, update your `Podfile` with this source:
```ruby
source 'https://github.com/pokanop/cocoapods-pokanop.git'
```

And add the pod to your target as well to include:
```ruby
pod 'Boing'
```

### Carthage

## Animations

## API

The basic API pattern adds extensions to any `UIView` allowing you to execute simple commands to animate your views.

For example, using a preset animation you can do:

```swift
view.boing().commit()
```

> A final `commit()` call must be added to start the animation allowing for chaining multiple animations.

### Animation Options

You can customize any of the animations and provide a completion handler simply by:

```swift
view.boing(options: [.duration(0.3)]) {
  // add your completion code
}
```

The full set of options include:


### Preset Animations

### Coalesced Animations

### Chainable Animations

## Demo

Check out the Demo app to see the various animations available in the library.

Under the `Demo` folder, run:

```sh
pod install
```

And then open the workspace at `Demo/Demo.xcworkpace` to run the application.

## Credits

## Contibuting
Contributions are what makes the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License
Distributed under the MIT License.
