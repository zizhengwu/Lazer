import Foundation
import UIKit

class ArticleContentViewController : UIViewController {
    var _rssItem: RssItem
    var _webView: UIWebView
    
    init(rssItem: RssItem) {
        self._rssItem = rssItem
        self._webView = UIWebView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _webView.loadHTMLString((_rssItem.content!), baseURL: nil)
        self.view.addSubview(_webView)
    }
}