import Foundation
import UIKit
import KVOController

extension RootViewController {
    func timerClicked(sender: UIButton!) {
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        if UserProfileController.sharedInstance.zenMode {
            alert.title = "You are in zen mode"
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        }
        else {
            alert.title = "Just don't have too much fun"
            alert.addAction(UIAlertAction(title: "5 mins", style: .Default, handler: { action in
                self.changePreferredRelaxationTime(5.0)
            }))
            
            alert.addAction(UIAlertAction(title: "10 mins", style: .Default, handler: { action in
                self.changePreferredRelaxationTime(10.0)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        }
        
        alert.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func changePreferredRelaxationTime(time: Double) {
        UserProfileController.sharedInstance.preferredRelaxationTime = time
    }
    
    func zenMode() {
        UserProfileController.sharedInstance.zenMode = true
        _ = NSTimer.scheduledTimerWithTimeInterval(Double(UserProfileController.sharedInstance.preferredRelaxationTime), target: self, selector: #selector(addTimeoutOverlay), userInfo: nil, repeats: false)
        _ = NSTimer.scheduledTimerWithTimeInterval(Double(UserProfileController.sharedInstance.preferredRelaxationTime) * 2, target: self, selector: #selector(addTimeoutOverlay), userInfo: nil, repeats: false)
        
        let notification = UILocalNotification()
        notification.fireDate = NSDate(timeIntervalSinceNow: 6)
        notification.alertBody = "Hope this message finds you enjoying your last 30 minutes."
        notification.alertAction = "Read More"
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func addTimeoutOverlay() {
        if let _ = overlay {
            UserProfileController.sharedInstance.zenMode = false
            overlay?.removeFromSuperview()
            overlay = nil
        }
        else {
            overlay = UIView(frame: view.frame)
            overlay!.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            overlay!.backgroundColor = UIColor.blackColor()
            overlay!.alpha = 0.8
            
            let quoteTextView: UITextView = {
                let textView = UITextView()
                let randomIndex = Int(arc4random_uniform(UInt32(Constant.QUOTES.count)))
                
                textView.text = Constant.QUOTES[randomIndex].keys.first! + "\n\n—" + Constant.QUOTES[randomIndex].values.first!
                textView.backgroundColor = UIColor.clearColor()
                textView.textColor = UIColor.whiteColor()
                textView.font = UIFont.systemFontOfSize(20)
                textView.scrollEnabled = false
                textView.userInteractionEnabled = false
                
                return textView
            }()
            
            overlay?.addSubview(quoteTextView)
            view.addSubview(overlay!)
            
            overlay!.snp_makeConstraints{ (make) -> Void in
                make.top.equalTo(view)
                make.bottom.equalTo(view)
                make.left.equalTo(view)
                make.right.equalTo(view)
            }
            
            quoteTextView.snp_makeConstraints{ (make) -> Void in
                make.centerY.equalTo(overlay!)
                make.centerX.equalTo(overlay!)
                make.left.equalTo(overlay!)
                make.right.equalTo(overlay!)
            }
        }
    }
    
    func settingsClicked(sender: UIButton!) {
        navigationController?.pushViewController(settingsView, animated: true)
    }
    
    func setupViews() {
        self.header.setRefreshingTarget(self, refreshingAction: #selector(RootViewController.refresh(_:)))
        collectionView?.mj_header = self.header
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        navigationItem.title = "Lazer"
        
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        collectionView?.registerClass(FeedCell.self, forCellWithReuseIdentifier: cellId)
        
        settingsButton = {
            let button = UIButton()
            button.frame = CGRectMake(0, 0, 25, 25)
            button.setImage(UIImage(named: "Settings")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
            button.addTarget(self, action: #selector(RootViewController.settingsClicked(_:)), forControlEvents: .TouchUpInside)
            return button
        }()
        
        timerButton = {
            let button = UIButton()
            button.frame = CGRectMake(0, 0, 25, 25)
            button.setImage(UIImage(named: "Timer")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
            button.addTarget(self, action: #selector(RootViewController.timerClicked(_:)), forControlEvents: .TouchUpInside)
            return button
        }()
        
        //.... Set Right/Left Bar Button item
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = settingsButton
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = timerButton
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        self.KVOController.observe(UserProfileController.sharedInstance, keyPath: "zenMode", options: [.Initial, .New]) { [weak self] _ in
            if UserProfileController.sharedInstance.zenMode {
                self?.timerButton.tintColor = UIColor.clearColor()
            }
            else {
                self?.timerButton.tintColor = UIColor.blackColor()
            }
        }
    }
}