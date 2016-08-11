import UIKit
import MJRefresh
import KVOController
import CoreData

let cellId = "feedCell"


class RootViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {
    let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
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
    
    var fetchedResultsController: NSFetchedResultsController!
    
    func initializeFetchedResultsController() {
        let request = NSFetchRequest(entityName: "PostItem")
        
        let moc = delegate!.managedObjectContext
        let dateSort = NSSortDescriptor(key: "pubDate", ascending: true)
        request.sortDescriptors = [dateSort]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadSampleData()
        initializeFetchedResultsController()
        
        UserProfileController.sharedInstance.reloadTags()
        setupViews()
    }
    
    func refresh(sender:AnyObject)
    {
        self.header.beginRefreshing()
        clearData()
        retrieveArticles()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sections = fetchedResultsController.sections! as [NSFetchedResultsSectionInfo]
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
            return fetchedResultsController.sections!.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let feedCell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! FeedCell
        
        feedCell.post = fetchedResultsController.objectAtIndexPath(indexPath) as? PostItem
        
        return feedCell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if !UserProfileController.sharedInstance.zenMode {
            zenMode()
        }
        //let rssItem = RssItem(title: posts[indexPath.row].title, creator: posts[indexPath.row].creator, pubDate: NSDate(), link: posts[indexPath.row].link, description: "", content: posts[indexPath.row].content, imageHeading: posts[indexPath.row].imageHeading, creatorAvatar: posts[indexPath.row].creatorAvatar)
        //let articleContentViewController = ArticleContentViewController(rssItem: rssItem)
        //navigationController?.pushViewController(articleContentViewController, animated: true)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let postItem = fetchedResultsController.objectAtIndexPath(indexPath) as! PostItem
        
        let statusText = postItem.abstract
            
        let rect = NSString(string: statusText!).boundingRectWithSize(CGSizeMake(view.frame.width, 1000), options: NSStringDrawingOptions.UsesFontLeading.union(NSStringDrawingOptions.UsesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFontOfSize(14)], context: nil)
        
        let knownHeight: CGFloat = 8 + 44 + 4 + 4 + 200
            
        return CGSizeMake(view.frame.width, rect.height + knownHeight + 24)
    }
    
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            collectionView!.insertItemsAtIndexPaths([newIndexPath!])
        case .Delete:
            collectionView!.deleteItemsAtIndexPaths([indexPath!])
        default:
            print("not implemented yet")
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        
    }

    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
}
