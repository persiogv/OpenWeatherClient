# OpenWeatherClient

A very simple **Swift Package** to consume Open Weather Map (https://openweathermap.org) free APIs (named Current weather data, and Hourly forecast).

## Getting started

1. Get OpenWeatherMap API key (https://openweathermap.org/appid)
2. Add package to your project (Xcode > File > Swift Packages > Add Package Dependency...). Point to branch `master`.
3. Update project target to reference OpenWeatherMap library (Targets > Frameworks, Libraries, and Embedded Content > touch "+" button)
4. Add `import OpenWeatherClient` to your Swift file

## Usage

Pass your app id to the OpenWeatherClient in your `AppDelegate.swift` file, on launch:

```swift
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        OpenWeatherClient.with(appId: "YOUR-APP-ID-HERE")
        return true
    }
```

#### Fetching current weather conditions:

```swift
  func fetchWeather(latitude: Double,
                    longitude: Double,
                    units: Units,
                    language: Language,
                    cacheTime: TimeInterval,
                    completion: @escaping WeatherCompletion)
```

#### Fetching 5 days forecast:

```swift
    func fetchForecast(latitude: Double,
                       longitude: Double,
                       units: Units,
                       language: Language,
                       cacheTime: TimeInterval,
                       completion: @escaping ForecastCompletion)
```

## License
The MIT License (MIT)

Copyright (c) 2020 Persio Vieira

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
