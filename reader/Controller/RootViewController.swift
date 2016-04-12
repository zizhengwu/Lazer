import UIKit
import Alamofire
import SwiftyJSON
import MJRefresh
import KVOController

let cellId = "feedCell"


class RootViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var posts = [RssItem]()
    var settingsView = PreferenceViewController()
    var timerButton: UIButton!
    var settingsButton: UIButton!
    let header: MJRefreshNormalHeader = {
        let header = MJRefreshNormalHeader()
        header.lastUpdatedTimeLabel.hidden = true
        header.stateLabel.hidden = true
        return header
    }()
    
    var overlay : UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserProfileController.sharedInstance.reloadTags()
        
        posts.append(RssItem(title: "Introducing Lazer", creator: "Team Super Monkey Bomb", pubDate: NSDate(), link: "https://zizhengwu.com/about", description: "Welcome to Lazer! Lazer works as an information hub that aims to provide meaningful relax to the users. By choosing from different topic categories, users will build their own personal information hub with up to date articles.", content: "Welcome to Lazer! Lazer works as an information hub that aims to provide meaningful relax to the users. By choosing from different topic categories, users will build their own personal information hub with up to date articles. Now Lazer is available on both iOS and Android platform.<br><br>Lazer is certainly not another app to overwhelm you with endless information that you are not interested in. Lazer allows you to change topic preference at any time. After setting up each relax time period, Lazer articles will only be active within that period. When time is up, users will only see a quote after reading their current article. Only after the preset cool down time, which must be more than 30 minutes, will our inspiring quote be updated by new article set. <br><br>Categorizing and aggregating information is not easy. One of our goals is to make the life easier for our users, who only need to care about topics. What happens behind the curtain is more delicate. We modelled topics as top layer nodes. They point to source nodes in the intermediate hidden layer. Each source node generates new articles and hence needs checking periodically. <br><br>Harvesting articles from various sources is an automated process, while the association between topics and sources are maintained by content strategists. By simply connecting or disconnecting sources with topics, they could vastly alter what the users get. To help this role efficiently tailor content, an application is crucial to reduce the overhead that every tiny modification has go through the backend engineers. <br><br>This interface is available on both desktops and handheld devices. Source could be easily filtered by name and locate the ones to modify. Changes to the sources are automatically saved and accompanied by a very handy preview feature when applicable. We believe that content strategists are empowered by this responsive design to discover, re-organize and optimize, so that the articles delivered to the end devices are pertinent, abundant and engaging. <br><br>", imageHeading: "http://i.imgur.com/JoTiTtg.png", creatorAvatar: "http://i.imgur.com/hmyoWhi.png"))
        
        setupViews()
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
//                UIApplication.sharedApplication().statusBarStyle = .LightContent
//                self?.navigationController?.navigationBar.barTintColor = Constant.zenModeNavigationBarColor
//                self?.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : Constant.zenModeTintColor]
//                self?.navigationController?.navigationBar.tintColor = Constant.zenModeTintColor
//                self?.settingsButton.tintColor = Constant.zenModeTintColor
                self?.timerButton.tintColor = UIColor.clearColor()
            }
            else {
//                UIApplication.sharedApplication().statusBarStyle = .Default
//                self?.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
//                self?.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.blackColor()]
//                self?.navigationController?.navigationBar.tintColor = UIColor.blackColor()
//                self?.settingsButton.tintColor = UIColor.blackColor()
                self?.timerButton.tintColor = UIColor.blackColor()
            }
        }
    }
    
    func refresh(sender:AnyObject)
    {
        self.header.beginRefreshing()
        self.posts = [RssItem]()
        collectionView?.reloadData()
        retrieveArticles()
    }
    
    func retrieveArticles() {
        var urlsToBeRetrieved = [String]()
        for tag in UserProfileController.sharedInstance.tags {
            if tag.selected == true {
                urlsToBeRetrieved.append(tag.url!)
            }
        }
        print(urlsToBeRetrieved)
        
        let group = dispatch_group_create()
        
        for url in urlsToBeRetrieved {
            dispatch_group_enter(group)
            Alamofire.request(.POST, "http://chi01.xuleijr.com/api/subscriptions/7c96422964215320482", parameters: ["channels": url])
                .responseString { response in
                    dispatch_group_leave(group)
                    if let value = response.result.value {
                        let json = JSON.parse(value as String)["items"]
                        for (_, item):(String, JSON) in json {
                            // a bug in the backend, should be deleted!
                            let description: String
                            if let _ = item["summary"].string {
                                description = item["summary"].string!
                            }
                            else {
                                description = ""
                            }
                            let post = RssItem(title: item["title"].string!, creator: item["author"].string!, pubDate: NSDate(), link: item["link"].string!, description: description, content: item["original"].string!, imageHeading: item["cover"].string!, creatorAvatar: item["icon"].string!)
                            // deleted until here
                            
//                            let post = RssItem(title: item["title"].string!, creator: "creator", pubDate: NSDate(), link: item["link"].string!, description: item["summary"].string!, content: item["original"].string!, imageHeading: item["cover"].string!, creatorAvatar: item["icon"].string!)
                            self.posts.append(post)
                            self.collectionView?.insertItemsAtIndexPaths([NSIndexPath(forItem: self.posts.count - 1, inSection: 0)])
                        }
                    }
            }
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue()) {
            self.header.endRefreshing()
        }
    }
    
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
        _ = NSTimer.scheduledTimerWithTimeInterval(Double(20), target: self, selector: #selector(addTimeoutOverlay), userInfo: nil, repeats: false)
        
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
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let feedCell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! FeedCell
        
        feedCell.post = posts[indexPath.item]
        
        return feedCell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if !UserProfileController.sharedInstance.zenMode {
            zenMode()
        }
        let rssItem = RssItem(title: posts[indexPath.row].title, creator: posts[indexPath.row].creator, pubDate: NSDate(), link: posts[indexPath.row].link, description: "", content: posts[indexPath.row].content, imageHeading: posts[indexPath.row].imageHeading, creatorAvatar: posts[indexPath.row].creatorAvatar)
        let articleContentViewController = ArticleContentViewController(rssItem: rssItem)
        navigationController?.pushViewController(articleContentViewController, animated: true)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let statusText = posts[indexPath.item].description
            
        let rect = NSString(string: statusText).boundingRectWithSize(CGSizeMake(view.frame.width, 1000), options: NSStringDrawingOptions.UsesFontLeading.union(NSStringDrawingOptions.UsesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFontOfSize(14)], context: nil)
            
        let knownHeight: CGFloat = 8 + 44 + 4 + 4 + 200
            
        return CGSizeMake(view.frame.width, rect.height + knownHeight + 24)

    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
}
