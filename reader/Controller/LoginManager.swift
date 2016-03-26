import Foundation
import AWSCore
import AWSCognito
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit

class LoginManager {
    
    static let sharedInstance = LoginManager()
    
    var cognitoId: String?
    var loggedIn: Bool?
    var userImage: UIImage?
    var userName: String?
    var userEmail: String?
    var syncClient: AWSCognito?
    var dataset: AWSCognitoDataset?
    
    init() {
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: Constant.COGNITO_REGIONTYPE, identityPoolId: Constant.COGNITO_IDENTITY_POOL_ID)
        let configuration = AWSServiceConfiguration(region: .USEast1, credentialsProvider:credentialsProvider)
        AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = configuration
        
        if let token = FBSDKAccessToken.currentAccessToken() {
            credentialsProvider.logins = [AWSCognitoLoginProviderKey.Facebook.rawValue: token.tokenString]
            print("Facebook already logged in")
            credentialsProvider.getIdentityId().continueWithBlock { (task: AWSTask!) -> AnyObject! in
                if (task.error != nil) {
                    print("Error: " + task.error!.localizedDescription)
                } else {
                    // the task result will contain the identity id
                    let _ = task.result
                    print(credentialsProvider.getIdentityId())
                    self.loggedIn = true
                    self.sync()
                    self.fetchProfile()
                }
                return nil
            }
        }
        else {
            print("Facebook not logged in")
        }
    }
    
    func sync() {
        self.syncClient = AWSCognito.defaultCognito()
        self.dataset = self.syncClient!.openOrCreateDataset("preference")
        
        self.dataset!.synchronize().continueWithBlock {(task) -> AnyObject! in
            
            if task.error != nil {
                // Error while executing task
                
            } else {
                // Task succeeded. The data was saved in the sync store.
                
            }
            return nil
        }
    }
    
    func fetchProfile() {
        let parameters = ["fields": "email, first_name, last_name, picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler({ (connection, user, requestError) -> Void in
            
            if requestError != nil {
                print(requestError)
                return
            }
            
            var _ = user["email"] as String!
            let firstName = user["first_name"] as String!
            let lastName = user["last_name"] as String!
            
            self.userName = "\(firstName!) \(lastName!)"
            
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