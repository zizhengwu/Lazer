import UIKit
import Alamofire
import SwiftyJSON
import Popover
import MJRefresh

let cellId = "feedCell"


class RootViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var posts = [RssItem]()
    var settingsView = PreferenceViewController()
    var timerButton: UIButton!
    private var popover: Popover!
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
        
        posts.append(RssItem(title: "Introducing Lazer", creator: "Team Super Monkey Bomb", pubDate: NSDate(), link: "https://zizhengwu.com/about", description: "description", content: "Introducing Lazer", imageHeading: "http://oyster.ignimgs.com/wordpress/stg.ign.com/2016/04/nkC6MH3.jpg", creatorAvatar: "http://www.clipartlord.com/wp-content/uploads/2016/01/gorilla6.png"))
        
        self.header.setRefreshingTarget(self, refreshingAction: #selector(RootViewController.refresh(_:)))
        collectionView?.mj_header = self.header
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        navigationItem.title = "Lazer"
        
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        collectionView?.registerClass(FeedCell.self, forCellWithReuseIdentifier: cellId)
        
        let settingsButton: UIButton = {
            let button = UIButton()
            button.frame = CGRectMake(0, 0, 25, 25)
            button.setImage(UIImage(named: "Settings"), forState: .Normal)
            button.addTarget(self, action: #selector(RootViewController.settingsClicked(_:)), forControlEvents: .TouchUpInside)
            return button
        }()
        
        timerButton = {
            let button = UIButton()
            button.frame = CGRectMake(0, 0, 25, 25)
            button.setImage(UIImage(named: "Timer"), forState: .Normal)
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
    }
    
    func refresh(sender:AnyObject)
    {
        self.posts = [RssItem]()
        collectionView?.reloadData()
        retrieveArticles()
        self.header.endRefreshing()
    }
    
    func retrieveArticles() {
        var urlsToBeRetrieved = [String]()
        for tag in UserProfileController.sharedInstance.tags {
            if tag.selected == true {
                urlsToBeRetrieved.append(tag.url!)
            }
        }
        print(urlsToBeRetrieved)
        
        for url in urlsToBeRetrieved {
            Alamofire.request(.POST, "http://chi01.xuleijr.com/api/subscriptions/7c96422964215320482", parameters: ["channels": url])
                .responseString { response in
                    if let value = response.result.value {
                        let json = JSON.parse(value as String)["items"]
                        for (_, item):(String, JSON) in json {
                            let post = RssItem(title: item["title"].string!, creator: "creator", pubDate: NSDate(), link: item["link"].string!, description: item["summary"].string!, content: item["content"].string!, imageHeading: item["cover"].string!, creatorAvatar: item["icon"].string!)
                            self.posts.append(post)
                            self.collectionView?.insertItemsAtIndexPaths([NSIndexPath(forItem: self.posts.count - 1, inSection: 0)])
                        }
                    }
            }
        }
    }
    
    func timerClicked(sender: UIButton!) {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width / 3, height: 135))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.scrollEnabled = false
        tableView.separatorStyle = .None
        let popoverOptions: [PopoverOption] = [
            .Type(.Down),
            .BlackOverlayColor(UIColor(white: 0.0, alpha: 0.6)),
            .ArrowSize(CGSizeZero),
        ]
        self.popover = Popover(options: popoverOptions, showHandler: nil, dismissHandler: nil)
        self.popover.show(tableView, fromView: self.timerButton)
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


// setup timer popover

extension RootViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        _ = NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: #selector(addTimeoutOverlay), userInfo: nil, repeats: false)
        self.popover.dismiss()
    }
}

extension RootViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
        cell.textLabel?.text = String(Constant.TIMER_OPTIONS[indexPath.row]) + " mins"
        return cell
    }
}

