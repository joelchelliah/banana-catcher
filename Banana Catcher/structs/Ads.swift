import Foundation

struct Ads {
    
    static let showInterstitialID: String = "showInterstitialID"
    static let showBannerID: String = "showBannerID"
    static let hideBannerID: String = "showBannerID"
    
    static func showInterstitial() {
        if !NoAds.alreadyPurchased() {
            postNotification(showInterstitialID)
        }
    }
    
    static func showBanner() {
        if !NoAds.alreadyPurchased() {
            postNotification(showBannerID)
        }
    }
    
    static func hideBanner() {
        postNotification(hideBannerID)
    }
    
    private static func postNotification(id: String) {
        NSNotificationCenter.defaultCenter().postNotificationName(id, object: nil)
    }
}
