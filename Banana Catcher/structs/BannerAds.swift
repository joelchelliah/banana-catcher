import Foundation

struct BannerAds {
    
    static let showAdsID: String = "showadsID"
    static let hideAdsID: String = "hideadsID"
    
    static func show() {
        postNotification(showAdsID)
    }
    
    static func hide() {
        postNotification(hideAdsID)
    }
    
    private static func postNotification(id: String) {
        NSNotificationCenter.defaultCenter().postNotificationName(id, object: nil)
    }
}
