import StoreKit

// See tutorial for how to also add more products: 
// http://www.raywenderlich.com/105365/in-app-purchases-tutorial-getting-started

typealias RequestProductsCompletionHandler = (success: Bool, products: [SKProduct]) -> ()


struct NoAds {
    static let identifier = "com.cookiemagik.Banana.Catcher.no.iads"
    static let purchasedNotification = "NoAdsPurchasedNotification"
    static let restoredNotification = "NoAdsRestoredNotification"
    private static let helper = NoAdsHelper()
    
    static func purchase() {
        helper.purchaseNoAds()
    }
    
    static func restore() {
        helper.restoreNoAds()
    }
    
    static func alreadyPurchased() -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey(identifier)
    }
    
    static func notPermitted() -> Bool {
        return !SKPaymentQueue.canMakePayments()
    }
}

class NoAdsHelper : NSObject  {
    private var allProducts = [SKProduct]()
    
    private var productsRequest: SKProductsRequest?
    private var completionHandler: RequestProductsCompletionHandler?
    
    override init() {
        super.init()
        
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        
        productsRequest = SKProductsRequest(productIdentifiers: Set(arrayLiteral: NoAds.identifier))
        productsRequest?.delegate = self
        productsRequest?.start()
    }
    
    func purchaseNoAds() {
        if let i = self.allProducts.indexOf({$0.productIdentifier == NoAds.identifier}) {
            let product = self.allProducts[i]
            let payment = SKPayment(product: product)
            
            SKPaymentQueue.defaultQueue().addPayment(payment)
        } else {
            print("Could not find product with id: \(NoAds.identifier)")
        }
    }
    
    func restoreNoAds() {
        SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
    }
}

extension NoAdsHelper: SKProductsRequestDelegate {
    
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        allProducts = response.products
        completionHandler?(success: true, products: allProducts)
        clearRequest()
    }
    
    func request(request: SKRequest, didFailWithError error: NSError) {
        print("Failed to load list of products.")
        print("Error: \(error)")
        clearRequest()
    }
    
    private func clearRequest() {
        productsRequest = nil
        completionHandler = nil
    }
}

extension NoAdsHelper: SKPaymentTransactionObserver {

    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch (transaction.transactionState) {
            case .Purchased:
                completeTransaction(transaction)
                break
            case .Failed:
                failedTransaction(transaction)
                break
            case .Restored:
                restoreTransaction(transaction)
                break
            case .Deferred:
                break
            case .Purchasing:
                break
            }
        }
    }
    
    private func completeTransaction(transaction: SKPaymentTransaction) {
        let productIdentifier = transaction.payment.productIdentifier
        
        print("completeTransaction... \(productIdentifier)")
        
        provideContentForProductIdentifier(transaction.payment.productIdentifier)
        
        NSNotificationCenter.defaultCenter().postNotificationName(NoAds.purchasedNotification, object: NoAds.identifier)
        
        SKPaymentQueue.defaultQueue().finishTransaction(transaction)
    }
    
    private func restoreTransaction(transaction: SKPaymentTransaction) {
        let productIdentifier = transaction.originalTransaction!.payment.productIdentifier
        
        print("restoreTransaction... \(productIdentifier)")
        
        provideContentForProductIdentifier(productIdentifier)
        
        NSNotificationCenter.defaultCenter().postNotificationName(NoAds.restoredNotification, object: NoAds.identifier)
        
        SKPaymentQueue.defaultQueue().finishTransaction(transaction)
    }
    
    private func provideContentForProductIdentifier(productIdentifier: String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setBool(true, forKey: productIdentifier)
        defaults.synchronize()
    }
    
    private func failedTransaction(transaction: SKPaymentTransaction) {
        print("failedTransaction...")
        
        if let error = transaction.error where error.code != SKErrorPaymentCancelled {
            print("Transaction error: \(error.localizedDescription)")
        }
        
        SKPaymentQueue.defaultQueue().finishTransaction(transaction)
    }
}
