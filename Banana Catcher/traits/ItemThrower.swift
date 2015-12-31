import Foundation
import SpriteKit

protocol ItemThrower {
    func currentLevel() -> Int
}

extension ItemThrower where Self: EvilMonkey {
    
    func getTrowable() -> Throwable {
        let throwables = [Heart(), Heartnut(), Supernut(), Banananut(), Coconut()]
        
        for throwable in throwables {
            if Int(random(100)) < dropRateFor(throwable) {
                return throwable
            }
        }
        
        return Banana()
    }
    
    private func dropRateFor(item: Throwable) -> Int {
        switch item {
        
        case is Heart: return lookUp(DropRates.heart)
        
        case is Heartnut: return lookUp(DropRates.heartnut)
        
        case is Supernut: return lookUp(DropRates.supernut)
        
        case is Banananut: return lookUp(DropRates.banananut)
            
        case is Coconut: return lookUp(DropRates.coconut)
            
        default: fatalError("Attempted to lookup dropRate of \(item)")
        }
    }
    
    private func lookUp(rates: [Int]) -> Int {
        let lvl = currentLevel()
        
        if lvl < rates.count {
            return rates[lvl]
        } else {
            return rates.last!
        }
    }
}

private struct DropRates {
    static let heart: [Int] = DropRates.zeros(11)        + 5.stride(to: 1, by: -1)
    static let heartnut: [Int] = DropRates.zeros(8)      + 10.stride(to: 1, by: -1)
    static let supernut: [Int] = DropRates.zeros(5)      + 50.stride(to: 10, by: -5)
    static let bananacluster: [Int] = DropRates.zeros(5) + 32.stride(to: 4, by: -4)
    static let banananut: [Int] = DropRates.zeros(2)     + 10.stride(to: 1, by: -1)
    static let coconut: [Int] =                            [20] + 40.stride(to: 20, by: -5)
    
    private static func zeros(num: Int) -> [Int] {
        return [Int](count: num, repeatedValue: 0)
    }
}
