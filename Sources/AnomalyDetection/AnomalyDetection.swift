// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Distrs
import SeasonalTrendsDecomp


public struct AnomalyDetector {
    var alpha: Double
    var max_anoms: Double
    var direction: String
    var verbose: Bool
    
    
    public init(alpha: Double = 0.5, max_anoms: Double = 0.2, direction: String = "Both", verbose: Bool = false) {
        self.alpha = alpha
        self.max_anoms = max_anoms
        self.direction = direction
        self.verbose = verbose
    }
    
    
    enum codeError: Error {
        case errorFromFit
    }
    
    public func fit(series: [Double], period: user_size_t) throws -> [user_size_t] {
        var one_tail = false
        var upper_tail = true
        if self.direction == "Both" {
            one_tail = false
            upper_tail = true
        }
        if self.direction == "Positive" {
            one_tail = true
            upper_tail = true
        }
        if self.direction == "Negative" {
            one_tail = true
            upper_tail = false
        }
        do {
        return try detect_anoms(data: series, num_obs_per_period: period, k: self.max_anoms, alpha: self.alpha, one_tail: one_tail, upper_tail: upper_tail, verbose: self.verbose)
            
        } catch {
                print("Could not resolve")
                throw codeError.errorFromFit
        }
        
        
        
        return [0]
    }
    
//https://stackoverflow.com/questions/44450266/get-median-of-array
    func median(data: [Double]) -> Double {
        var sorted = data.sorted()
    
        if sorted.count % 2 == 0 {
               
                return Double((sorted[(sorted.count / 2)] + sorted[(sorted.count / 2) - 1]) / 2.0)
            } else {
                return Double(sorted[(sorted.count - 1) / 2])
            }
        }
    
    func mad(data: [Double], med: Double) -> Double {
        var res = data
        for i in res.indices {
            res[i] = abs(res[i] - med)
        }
        res.sort(by: < )
        return (1.4826 * median(data: res))
    }
    
    func detect_anoms(data: [Double], num_obs_per_period: user_size_t, k: Double, alpha: Double, one_tail: Bool, upper_tail: Bool, verbose: Bool) throws  -> [user_size_t] {
        let n = data.count
        guard !(n < num_obs_per_period  * 2) else {
        print("series has less than two periods")
        throw codeError.errorFromFit
        }
        guard !data.contains(Double.nan) else {
        print("series contains NANs")
        throw codeError.errorFromFit
        }
        let data_decomp: StlResult
        var decomp = StlParams(ns: user_size_t(data.count * 10) + 1, robust: true)
        do {
        data_decomp = try decomp.fit(series: data, period: num_obs_per_period)
            
        } catch {
                print("Could not resolve")
                throw codeError.errorFromFit
        }
        let seasonal = data_decomp.seasonal
       
        var data = data
        let med = median(data: data)
    
        for i in 0..<n {
            data[i] -= seasonal[i] + med
        }
     
        var num_anoms: user_size_t = 0
        let max_outliers = Double(n) * k
     
        var anomalies = [user_size_t]()
        
        
        var indexes = Array(0..<n)
        indexes = indexes.sorted(by: {data[$0] < data[$1]})

        data.sort(by: <)
     
        for i in 1...user_size_t(max_outliers) {
            if verbose {
                print("\(i) / \(Int(max_outliers)) completed")
            }
            
            
            let ma = median(data: data)
            
            var ares = [Double]()
           
            if one_tail {
                if upper_tail {
                    
                    for i in data.indices {
                        ares.append(data[i] - ma)
                    }
                } else {
                    
                    for i in data.indices {
                        ares.append(ma - data[i])
                    }
                    
                }
            } else {
                
                for i in data.indices {
                    ares.append(abs(data[i] - ma))
                }
                
            }
 
            
            
            let data_sigma = mad(data: data, med: ma)
      
            if data_sigma == 0.0 {
                break;
            }
            
            var r0 = Double()
            var idx = Int()
            if ares[0] > ares[ares.count - 1] {
                r0 = ares[0]
                idx = 0
            } else {
                r0 = ares[ares.count - 1]
                idx = ares.count - 1
            }
            
    
            let r = r0 / data_sigma
            
            anomalies.append(user_size_t(indexes[idx]))
            data.remove(at: idx)
            indexes.remove(at: idx)
            
            let p = if one_tail {
                1.0 - Double(alpha) / (Double(n) - Double(i) + 1.0)
            } else {
                1.0 - Double(alpha) / (2.0 * (Double(n) - Double(i) + 1.0))
            }
     
            
            let t = Double(StudentsT().ppf(p: Double(p), n: Double(Double(n) - Double(i) - 1.0)))

            let lam = Double(Double(t) * (Double(n) - Double(i)))/sqrt( ((Double(n)-Double(i)-1.0) + t * t) * (Double(n) - Double(i) + 1.0))
   
            if r > lam {
                num_anoms = user_size_t(i)
            }
            
            
        }

        
        var anomaliesReal = [user_size_t]()
        for i in 0..<num_anoms {
            anomaliesReal.append(anomalies[Int(i)])
        }
        
        
        anomaliesReal.sort(by: <)
        //Returns an array containing the locations of anoms
        return anomaliesReal
    }
    
    
    
    
}




