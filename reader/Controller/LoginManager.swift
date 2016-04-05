import Foundation
import AWSCore
import AWSCognito
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import SwiftyJSON

class LoginManager {
    
    static let sharedInstance = LoginManager()
    
    var cognitoId: String?
    var loggedIn: Bool?
    var userImage: UIImage?
    var userName: String?
    var userEmail: String?
    var syncClient: AWSCognito?
    var dataset: AWSCognitoDataset?
    var credentialsProvider: AWSCognitoCredentialsProvider?
    var tags = [Tag]()

    init() {
        self.credentialsProvider = AWSCognitoCredentialsProvider(regionType: Constant.COGNITO_REGIONTYPE, identityPoolId: Constant.COGNITO_IDENTITY_POOL_ID)
        let configuration = AWSServiceConfiguration(region: .USEast1, credentialsProvider:credentialsProvider)
        AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = configuration
        self.facebookLogin()
        self.initializeTags()
        self.syncClient = AWSCognito.defaultCognito()
        self.dataset = self.syncClient!.openOrCreateDataset("preference")
    }
    
    func facebookLogin() {
        if let token = FBSDKAccessToken.currentAccessToken() {
            self.credentialsProvider!.logins = [AWSCognitoLoginProviderKey.Facebook.rawValue: token.tokenString]
            print("Facebook already logged in")
            self.credentialsProvider!.getIdentityId().continueWithBlock { (task: AWSTask!) -> AnyObject! in
                if (task.error != nil) {
                    print("Error: " + task.error!.localizedDescription)
                } else {
                    // the task result will contain the identity id
                    let _ = task.result
                    print(self.credentialsProvider!.getIdentityId())
                    self.loggedIn = true
                    self.syncClient = AWSCognito.defaultCognito()
                    self.dataset = self.syncClient!.openOrCreateDataset("preference")
                    self.sync()
                    self.fetchProfile()
                }
                return nil
            }
        }
        else {
            self.clearProfile()
            print("Facebook not logged in")
        }
    }
    
    func clearProfile() {
        self.loggedIn = false
        self.userImage = nil
        self.userEmail = nil
        self.userName = nil
    }
    
    func initializeTags() {
        for tagOption in Constant.TAGOPTIONS {
            let tag = Tag()
            tag.name = tagOption[0]
            tag.url = tagOption[1]
            self.tags.append(tag)
        }
    }
    
    func reloadTags() {
        var tagsSelectedJson: JSON
        if self.dataset != nil {
            if let tagsSelectedString = self.dataset!.stringForKey("tags") {
                tagsSelectedJson = JSON.parse(tagsSelectedString)
            }
            else {
                tagsSelectedJson = JSON.parse("")
            }
        }
        else {
            tagsSelectedJson = JSON.parse("")
        }
        
        var selectedTags = [String]()
        
        for (key, _):(String, JSON) in tagsSelectedJson {
            selectedTags.append(key)
        }
        
        for tag in self.tags {
            if selectedTags.contains(tag.name!) {
                tag.selected = true
            }
            else {
                tag.selected = false
            }
        }
    }
    
    func sync() {
        if self.dataset != nil {
            self.dataset!.synchronize().continueWithBlock {(task) -> AnyObject! in
                
                if task.error != nil {
                    // Error while executing task
                    
                } else {
                    // Task succeeded. The data was saved in the sync store.
                    
                }
                return nil
            }
        }
        else {
            print("trying to sync but nil dataset")
        }
    }
    
    func fetchProfile() {
        let parameters = ["fields": "email, first_name, last_name, picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler({ (connection, user, requestError) -> Void in
            
            if requestError != nil {
                print(requestError)
                return
            }
            
            let firstName = user["first_name"] as String!
            let lastName = user["last_name"] as String!
            
            self.userName = "\(firstName!) \(lastName!)"
            self.userEmail = user["email"] as String!
            
            let userDict = user as? NSDictionary?
            let pictureUrl = userDict!!["picture"]!["data"]!["url"]! as String!
            
            let url = NSURL(string: pictureUrl)
            NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                if error != nil {
                    print(error)
                    return
                }
                
                let image = UIImage(data: data!)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.userImage = image
                })
                
            }).resume()
            
        })
    }
}