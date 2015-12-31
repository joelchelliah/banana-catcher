import Foundation
import SpriteKit

protocol CollissionDetector {}

extension CollissionDetector {
    func handleContact(contact contact: SKPhysicsContact, onHitBasketMan basketHit: (Throwable) -> (), onHitGround groundHit: (Throwable) -> ()) {
        var b1: SKPhysicsBody
        var b2: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            b1 = contact.bodyA
            b2 = contact.bodyB
        } else {
            b1 = contact.bodyB
            b2 = contact.bodyA
        }
        
        if b1.node?.parent == nil || b2.node?.parent == nil {
            return
        }
        
        if isThrowable(b1) {
            let item = b1.node as! Throwable
            
            if b2.categoryBitMask & CollisionCategories.BasketMan != 0 {
                basketHit(item)
            } else if b2.categoryBitMask & CollisionCategories.Ground != 0 {
                groundHit(item)
            } else {
                handleUnexpectedContactTest(b1, b2)
            }
        }
    }
    
    private func isThrowable(body: SKPhysicsBody) -> Bool {
        let isBanana          = body.categoryBitMask & CollisionCategories.Banana != 0
        let isBananaCluster   = body.categoryBitMask & CollisionCategories.BananaCluster != 0
        let isCoconut         = body.categoryBitMask & CollisionCategories.Coconut != 0
        let isBanananut       = body.categoryBitMask & CollisionCategories.Banananut != 0
        let isSupernut        = body.categoryBitMask & CollisionCategories.Supernut != 0
        let isHeartnut        = body.categoryBitMask & CollisionCategories.Heartnut != 0
        let isHeart           = body.categoryBitMask & CollisionCategories.Heart != 0
        
        return isBanana || isBananaCluster || isCoconut || isBanananut || isSupernut || isHeartnut || isHeart
    }
    
    private func handleUnexpectedContactTest(b1: SKPhysicsBody, _
        b2: SKPhysicsBody) {
            print("Unexpected contant test: (\(b1), \(b2))")
    }
}
