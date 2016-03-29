import UIKit
import Alamofire
import SwiftyJSON

let cellId = "cellId"


class RootViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var posts = [RssItem]()
    var settingsView = PreferenceViewController()
    var refreshControl: UIRefreshControl!
    
    var overlay : UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(RootViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        navigationItem.title = "Reader"
        
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        collectionView?.registerClass(FeedCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView?.addSubview(refreshControl)
        
        let settingsButton = UIButton()
        settingsButton.frame = CGRectMake(0, 0, 25, 25)
        settingsButton.setImage(UIImage(named: "Settings"), forState: .Normal)
        settingsButton.addTarget(self, action: #selector(RootViewController.settingsClicked(_:)), forControlEvents: .TouchUpInside)
        
        let timerButton = UIButton()
        timerButton.frame = CGRectMake(0, 0, 25, 25)
        timerButton.setImage(UIImage(named: "Timer"), forState: .Normal)
        timerButton.addTarget(self, action: #selector(RootViewController.timerClicked(_:)), forControlEvents: .TouchUpInside)
        
        //.... Set Right/Left Bar Button item
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = settingsButton
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = timerButton
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func refresh(sender:AnyObject)
    {
        LoginManager.sharedInstance.reloadTags()
        retrieveArticles()
        refreshControl.endRefreshing()
    }
    
    func retrieveArticles() {
        var urlsToBeRetrieved = [String]()
        for tag in LoginManager.sharedInstance.tags {
            if tag.selected == true {
                urlsToBeRetrieved.append(tag.url!)
            }
        }
        print(urlsToBeRetrieved)
        
        for url in urlsToBeRetrieved {
            Alamofire.request(.POST, "http://chi01.xuleijr.com/api/subscriptions/7c96422964215320482", parameters: ["channels": url])
                .responseString { response in
                    let json = JSON.parse(response.result.value! as String)["items"]
                    for (_, item):(String, JSON) in json {
                        let post = RssItem(title: item["title"].string!, creator: "creator", pubDate: NSDate(), link: item["link"].string!, description: item["content"].string!, content: item["content"].string!, imageHeading: item["cover"].string!, creatorAvatar: item["icon"].string!)
                        self.posts.append(post)
                        self.collectionView?.insertItemsAtIndexPaths([NSIndexPath(forItem: self.posts.count - 1, inSection: 0)])
                    }
            }
        }

    }
    
    func timerClicked(sender: UIButton!) {
        _ = NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: #selector(addTimeoutOverlay), userInfo: nil, repeats: false)
    }
    
    func addTimeoutOverlay() {
        if let _ = overlay {
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
            quoteTextView.snp_makeConstraints{ (make) -> Void in
                make.centerY.equalTo(overlay!)
                make.centerX.equalTo(overlay!)
                make.left.equalTo(overlay!)
                make.right.equalTo(overlay!)
            }
            view.addSubview(overlay!)
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
        let rssItem = RssItem(title: posts[indexPath.row].title, creator: posts[indexPath.row].creator, pubDate: NSDate(), link: posts[indexPath.row].link, description: "", content: posts[indexPath.row].content, imageHeading: posts[indexPath.row].imageHeading, creatorAvatar: posts[indexPath.row].creatorAvatar)
        let articleContentViewController = ArticleContentViewController(rssItem: rssItem)
        navigationController?.pushViewController(articleContentViewController, animated: true)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let statusText = posts[indexPath.item].content
            
        let rect = NSString(string: statusText).boundingRectWithSize(CGSizeMake(view.frame.width, 1000), options: NSStringDrawingOptions.UsesFontLeading.union(NSStringDrawingOptions.UsesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFontOfSize(14)], context: nil)
            
        let knownHeight: CGFloat = 8 + 44 + 4 + 4 + 200
            
        return CGSizeMake(view.frame.width, rect.height + knownHeight + 24)

    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
}

