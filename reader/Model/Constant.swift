import AWSCore

class Constant {
    static let COGNITO_REGIONTYPE = AWSRegionType.USEast1 // e.g. AWSRegionType.USEast1
    static let COGNITO_IDENTITY_POOL_ID = "us-east-1:3c46831d-9f76-44fd-a3cd-2dabd63b34ce"
    static let QUOTES: [Dictionary<String, String>] = [["Time isn't the main thing. It's the only thing.":  "Miles Davis "], ["I love deadlines. I like the whooshing sound they make as they fly by.":  "Douglas Adams "], ["None of the world's problems will have a solution until the world's individuals become thoroughly self-educated.":  "Richard Buckminster Fuller"], ["The time you enjoy wasting is not wasted time.":  "Bertrand Russell"], ["You may delay, but time will not.":  "Benjamin Franklin"], ["None of the world's problems will have a solution until the world's individuals become thoroughly self-educated.":  "Richard Buckminster Fuller"], ["It is not enough to be busy... The question is: what are we busy about?":  "Henry David Thoreau "], ["Productivity is never an accident. It is always the result of a commitment to excellence, intelligent planning, and focused effort.":  "Paul J. Meyer"], ["Tomorrow is often the busiest day of the week.":  "Anonymous "], ["The best way to predict the future is to create it.":  "Peter Drucker "], ["Time is the longest distance between two places.":  "Tennessee Williams "], ["Success is the ability to go from one failure to another with no loss of enthusiasm.":  "Winston Churchill "], ["None of the world's problems will have a solution until the world's individuals become thoroughly self-educated.":  "Richard Buckminster Fuller"], ["Nothing is less productive than to make more efficient what should not be done at all.":  "Peter Drucker "]]
    static let TAG_OPTIONS =    [["Technology", "56dba1f14f2b69c417409f68"], ["Economy", "56dc5cf41c9f585b22d26190"], ["Weather", "56dc83dd9a7860e42377e1b4"], ["Entertainment", "56f490edfc828ece157be786"], ["Education", "56f97bfb5e868c196d0f21f8"], ["News", "56f97b845e868c196d0f21f7"], ["Sport", "56f97cf95e868c196d0f21f9"], ["Test", "56f97f215e868c196d0f21fa"], ["Game", "56dc5f27c8fe386b22526dab"], ["Outdoor", "56f9da575e868c196d0f21fb"], ["Life Style", "570401518097de587a27d5f0"], ["Real Estate", "570417d28097de587a27d5f1"], ["Photography", "570417f58097de587a27d5f2"], ["Election", "570418028097de587a27d5f3"], ["Design", "5704181c8097de587a27d5f4"], ["Baseball", "5704184c8097de587a27d5f5"], ["Football", "5704185e8097de587a27d5f6"], ["Politics", "5704501b8097de587a27d5fe"], ["Science", "570452688097de587a27d601"], ["Pop Music", "5704526c8097de587a27d602"]]
    static let TIMER_OPTIONS = [5, 10, 20]
    static let zenModeNavigationBarColor = UIColor.blackColor()
    static let zenModeTintColor = UIColor.whiteColor()
    static var endZenTime: NSDate = NSUserDefaults.standardUserDefaults().objectForKey("endZenTime") as? NSDate ?? NSDate()
    static var startZenTime: NSDate = NSUserDefaults.standardUserDefaults().objectForKey("startZenTime") as? NSDate ?? NSDate()
    static func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}