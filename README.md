# Warmshowers iOS

This project aims to provide a feature rich iOS client for warmshowers.org

![Warmshowers iOS MapView](docs/map-mockup.png "Warmshowers iOS	")

## Getting started

For those who want to build and run this project:

Add a file `APISecrets.swift` to the `API` folder with the following contents:

```
public struct APISecrets
{
    public static let Username = “ENTER YOUR USERNAME”
    public static let Password = “ENTER YOUR PASSWORD”
}
```

(you obviously have to fill in your credentials) and then you should be good to go.

Make sure to open the XCode workspace file and not the project file, because of the Cocoapod dependencies.
