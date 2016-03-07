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
        
        print(Css.head)
        print(Css.tail)
        print(Css.lightBody)
        _webView.loadHTMLString((Css.head + Css.lightBody + ArticleContentViewController.titleHtml(_rssItem.link, time: _rssItem.pubDate, title: _rssItem.title, author: _rssItem.creator, feed: "") + Css.tail), baseURL: nil)
        self.view.addSubview(_webView)
    }
    
    static func titleHtml(link: String, time: NSDate, title: String, author: String, feed: String) -> String {
        return String(format: "<div class=\"feature\"> <a href=\"%@\"></a> <titleCaption>{%@}</titleCaption> <articleTitle>{%@}</articleTitle> <titleCaption>{%@}</titleCaption> <titleCaption>{%@}</titleCaption></div>", link, time, title, author, feed)
    }
}