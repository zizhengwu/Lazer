import Foundation

class Css {
    static let lightBody = try! String(contentsOfFile: NSBundle.mainBundle().pathForResource("Css/light-body", ofType: "css")!, encoding: NSUTF8StringEncoding)
    static let head = "<!DOCTYPE html><html><head>"
    static let tail = "</body></html>"
}