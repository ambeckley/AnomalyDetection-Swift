# AnomalyDetection-Swift

Time series [AnomalyDetection](https://github.com/twitter/AnomalyDetection) for Swift

Learn [how it works](https://blog.twitter.com/engineering/en_us/a/2015/introducing-practical-and-robust-anomaly-detection-in-a-time-series)

[Ported from Rust](https://github.com/ankane/AnomalyDetection.rs)


## Getting Started

Detect anomalies in a time series

```swift
import AnomalyDetection

let series = [5.0, 9.0, 2.0, 9.0, 0.0, 6.0, 3.0, 8.0, 5.0, 18.0,
                      7.0, 8.0, 8.0, 0.0, 2.0, -5.0, 0.0, 5.0, 6.0, 7.0,
                      3.0, 6.0, 1.0, 4.0, 4.0, 4.0, 30.0, 7.0, 5.0, 8.0]
        
        let period = 7
        do {
let res = try AnomalyDetector().fit(series: series, period: user_size_t(period))
        } catch {
        print("Could not resolve")
        }
```

Get anomalies

```swift
print(res)
```

## Parameters

Set parameters

```swift
AnomalyDetector(
alpha: 0.05,  // level of statistical significance
max_anoms: 0.1, // maximum number of anomalies as percent of data
direction: "Both", // Positive, Negative, or Both
verbose: true // show progress
)

```

## Credits

This library was ported from the [AnomalyDetection](https://github.com/ankane/AnomalyDetection.rs) Rust package and is available under the same license.

## References

- [Automatic Anomaly Detection in the Cloud Via Statistical Learning](https://arxiv.org/abs/1704.07706)


## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/ambeckley/AnomalyDetection-Swift/issues)
- Fix bugs and [submit pull requests](https://github.com/ambeckley/AnomalyDetection-Swift/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features





