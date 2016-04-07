import Foundation
import UIKit

class ArticleContentViewController : UIViewController, UIWebViewDelegate {
    var _rssItem: RssItem
    var _webView: UIWebView
    
    init(rssItem: RssItem) {
        self._rssItem = rssItem
        self._webView = UIWebView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
        self._webView.backgroundColor = UIColor.whiteColor()
        self._webView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _webView.loadHTMLString((Css.head + Css.lightBody + ArticleContentViewController.titleHtml(_rssItem.link, time: _rssItem.pubDate, title: _rssItem.title, author: _rssItem.creator, feed: "") + _rssItem.content + Css.tail), baseURL: nil)
        self.view.addSubview(_webView)
        _webView.delegate = self
    }
    
    static func titleHtml(link: String, time: NSDate, title: String, author: String, feed: String) -> String {
        return String(format: "<div class=\"feature\"> <a href=\"%@\"></a> <titleCaption>%@</titleCaption> <articleTitle>%@</articleTitle> <titleCaption>%@</titleCaption> <titleCaption>%@</titleCaption></div>", link, time, title, author, feed)
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        switch navigationType {
        case .LinkClicked:
            // Open links in Safari
            UIApplication.sharedApplication().openURL(request.URL!)
            return false
        default:
            // Handle other navigation types...
            return true
        }
    }
}