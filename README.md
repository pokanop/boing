![Boing](Images/boing.png)

Boing is a simple and powerful animation API for views written in Swift. Inspired by many other animation libraries out there, it tries to aggregate and simplify many options into a single and seamless integration that can be reused in any project.

## Installation

### Swift Package Manager

### Cocoapods

Update your [`Podfile`](https://cocoapods.org/) with this source:
```ruby
source 'https://github.com/pokanop/cocoapods-pokanop.git'
```

Add the pod to your target and run `pod install`:
```ruby
pod 'Boing'
```

### Carthage

Update your [`Cartfile`](https://github.com/Carthage/Carthage) and run `carthage update`:
```
github "pokanop/boing"
```

## Animations

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
}.commit()
```

The available options include:
```swift
delay(TimeInterval)
duration(TimeInterval)
curve(AnimatingCurve)
damping(CGFloat)
velocity(CGFloat)
repeatCount(Float)
autoreverse(Bool)
removeOnCompletion(Bool)
```

### Animation Types

Boing provides several basic and preset animations including:
```swift
translate(CGFloat, CGFloat)
scale(CGFloat, CGFloat)
rotate(CGFloat)
backgroundColor(UIColor)
cornerRadius(CGFloat)
alpha(CGFloat)
frame(CGRect)
bounds(CGRect)
center(CGPoint)
fadeIn(AnimatingDirection)
fadeOut(AnimatingDirection)
slide(AnimatingDirection)
squeeze(AnimatingDirection)
flip(AnimatingDirection)
zoomIn
zoomOut
fall
shake
pop
morph
flash
wobble
swing
boing
```

### Coalesced Animations

For a single animation context, the library coalesces or combines several animations together. It runs them using the same animation options like `duration` and `delay`.

You can run combined animations using the `animate()` method as follows:
```swift
view.animate(
  animations: [.boing, .backgroundColor(.blue)],
  options: [.duration(0.5), .curve(.easeInOut)]
).commit()
```

### Chainable Animations

In addition to being able to combine or coalesce animations, Boing allows you to also chain in a simple builder style API call.

You can chain several animations to execute sequentially with:
```swift
view
  .boing()
  .scale(x: 0.5, y: 0.5)
  .alpha(0.5)
  .wobble()
  .commit()
```

## Demo

Check out the Demo app to see the various animations available in the library.

Under the `Demo` folder, run:

```sh
pod install
```

And then open the workspace at `Demo/Demo.xcworkpace` to run the application.

## Credits

This project was heavily inspired and lifted learnings by these wonderful projects:
- [Spring](https://github.com/MengTo/Spring)
- [Fluent](https://github.com/matthewcheok/Fluent)
- [Cheetah](https://github.com/suguru/Cheetah)
- [Wobbly](https://github.com/sagaya/wobbly)

## Contibuting
Contributions are what makes the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License
Distributed under the MIT License.
