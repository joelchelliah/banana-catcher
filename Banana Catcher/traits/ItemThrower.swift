import Foundation
import SpriteKit

protocol ItemThrower {
    func currentLevel() -> Int
}

extension ItemThrower where Self: EvilMonkey {
    
    func getTrowable() -> Throwable {
        let throwables = [
            Purplemush(), Heart(), Greenmush(),
            Heartnut(), Supernut(), BananaCluster(), Banananut(), Coconut()]
        
        for throwable in throwables {
            if Int(random(100)) < dropRateFor(throwable) {
                return throwable
            }
        }
        
        return Banana()
    }
    
    private func dropRateFor(item: Throwable) -> Int {
        switch item {
            
        case is Purplemush: return lookUp(DropRates.purpleMush)
            
        case is Heart: return lookUp(DropRates.heart)
        
        case is Greenmush: return lookUp(DropRates.greenMush)
            
        case is Heartnut: return lookUp(DropRates.heartnut)
        
        case is Supernut: return lookUp(DropRates.supernut)
        
        case is BananaCluster: return lookUp(DropRates.bananacluster)
            
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
    static let purpleMush: [Int] = DropRates.zeros(17)   + [2, 1, 1, 3, 1, 1, 1, 5]
    static let heart: [Int] = DropRates.zeros(14)        + [2, 1, 1, 1, 1, 1, 1, 2]
    static let greenMush: [Int] = DropRates.zeros(11)    + [2, 1, 1, 3, 1, 1, 1, 5]
    static let heartnut: [Int] = DropRates.zeros(8)      + [3, 1, 1, 1, 1, 1, 1, 2]
    static let supernut: [Int] = DropRates.zeros(5)      + 28.stride(to: 18, by: -2)
    static let bananacluster: [Int] = DropRates.zeros(4) + 24.stride(to: 16, by: -2)
    static let banananut: [Int] = DropRates.zeros(2)     + 20.stride(to: 14, by: -2)
    static let coconut: [Int] =                     [20] + 30.stride(to: 12, by: -2)
    
    private static func zeros(num: Int) -> [Int] {
        return [Int](count: num, repeatedValue: 0)
    }
}
