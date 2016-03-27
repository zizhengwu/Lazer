import UIKit
import Alamofire
import SwiftyJSON

let cellId = "cellId"


class RootViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var posts = [RssItem]()
    var settingsView = PreferenceViewController()
    
    override func viewDidAppear(animated: Bool) {
        retrieveArticles()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        navigationItem.title = "Reader"
        
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        collectionView?.registerClass(FeedCell.self, forCellWithReuseIdentifier: cellId)
        
        let btnName = UIButton()
        btnName.frame = CGRectMake(0, 0, 30, 30)
        btnName.setImage(UIImage(named: "Settings"), forState: .Normal)
        btnName.addTarget(self, action: #selector(RootViewController.settingsClicked(_:)), forControlEvents: .TouchUpInside)
        
        //.... Set Right/Left Bar Button item
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = btnName
        self.navigationItem.leftBarButtonItem = leftBarButton
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
                    for (key, item):(String, JSON) in json {
                        let post = RssItem(title: item["title"].string!, creator: "creator", pubDate: NSDate(), link: item["link"].string!, description: item["content"].string!, content: item["content"].string!, imageHeading: item["cover"].string!, creatorAvatar: item["icon"].string!)
                        self.posts.append(post)
                    }                    
            }
        }

        collectionView?.reloadData()
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
        let rssItem = RssItem(title: "Dark Souls 3 Starting Class Concept Art Revealed", creator: "Chloi Rad", pubDate: NSDate(), link: "http://www.ign.com/articles/2016/03/01/dark-souls-3-starting-classes-concept-art-revealed", description: "", content: posts[indexPath.row].content, imageHeading: "", creatorAvatar: "")
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

