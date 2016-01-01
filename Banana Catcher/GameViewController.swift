import SpriteKit
import GameKit
import UIKit
import iAd

class GameViewController: UIViewController, ADBannerViewDelegate {
    
    private let screenHeight = UIScreen.mainScreen().bounds.height
    private let adBannerView = ADBannerView()
    
    private var gameCenterEnabled = false
    private var gameCenterDefaultLeaderBoard = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.authenticateLocalPlayer()
        
        adBannerView.hidden = true
        adBannerView.alpha = 0
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hideBannerAd", name: Ads.hideBannerID, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showBannerAd", name: Ads.showBannerID, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showInterstitialAd", name: Ads.showInterstitialID, object: nil);
        
        initGameView()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    private func initGameView() {
        let gameScene = initGameScene()
        let transition = SKTransition.fadeWithColor(UIColor.blackColor(), duration: 1.0)
        let gameView = view as! SKView
        
        gameView.showsFPS = false
        gameView.showsNodeCount = false
        gameView.ignoresSiblingOrder = true
        gameView.presentScene(gameScene, transition: transition)
    }
    
    
    private func initGameScene() -> SKScene {
        //let gameScene = MenuScene(size: view.bounds.size)
        let gameScene = GameOverScene(size: view.bounds.size)
        //let gameScene = TutorialScene(size: view.bounds.size)
        //let gameScene = GameScene(size: view.bounds.size)
        
        gameScene.scaleMode = .ResizeFill
        
        return gameScene
    }
    
    
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    // * Banner view
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    override func viewWillAppear(animated: Bool) {
        let bannerHeight = adBannerView.bounds.height
        
        adBannerView.delegate = self
        adBannerView.frame = CGRectMake(0, screenHeight + bannerHeight, 0, 0)
        
        self.view.addSubview(adBannerView)
    }
    
    override func viewWillDisappear(animated: Bool) {
        adBannerView.delegate = nil
        adBannerView.removeFromSuperview()
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        adBannerView.hidden = false
        adBannerView.alpha  = 1
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        adBannerView.hidden = true
        adBannerView.alpha  = 0
    }
    
    func showBannerAd() {
        print("called show banner")
        let bannerHeight = adBannerView.bounds.height
        
        adBannerView.hidden = false
        
        moveBannerViewFrame(by: screenHeight - bannerHeight)
    }
    
    func hideBannerAd() {
        print("called hide banner")
        let bannerHeight = adBannerView.bounds.height
        
        adBannerView.hidden = true
        
        moveBannerViewFrame(by: screenHeight + bannerHeight)
    }
    
    func showInterstitialAd() {
        requestInterstitialAdPresentation()
    }
    
    private func moveBannerViewFrame(by yDiff: CGFloat) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(1.0)
        
        adBannerView.frame = CGRectMake(0, yDiff, 0, 0)
        
        UIView.commitAnimations()
    }
    
    
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    // * Game center
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    private func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            if((viewController) != nil) {
                // 1 Show login if player is not logged in
                self.presentViewController(viewController!, animated: true, completion: nil)
                
            } else if (localPlayer.authenticated) {
                // 2 Player is already euthenticated & logged in, load game center
                self.gameCenterEnabled = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifierWithCompletionHandler({ (leaderboardIdentifer: String?, error: NSError?) -> Void in
                    if error != nil {
                        print(error)
                    } else {
                        self.gameCenterDefaultLeaderBoard = leaderboardIdentifer!
                    }
                })
                
            } else {
                // 3 Game center is not enabled on the users device
                self.gameCenterEnabled = false
                print("Local player could not be authenticated, disabling game center")
                print(error)
            }
        }
    }
}
