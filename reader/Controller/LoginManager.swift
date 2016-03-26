import Foundation
import AWSCore
import AWSCognito
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit

class LoginManager {
    
    static let sharedInstance = LoginManager()
    
    var cognitoId: String
    var loggedIn: Bool
    var userImage: UIImage?
    var userName: String?
    var userEmail: String?
    
    init() {
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: Constant.COGNITO_REGIONTYPE, identityPoolId: Constant.COGNITO_IDENTITY_POOL_ID)
        let configuration = AWSServiceConfiguration(region: .USEast1, credentialsProvider:credentialsProvider)
        AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = configuration
        
        if let cachedIdentityId = credentialsProvider.identityId {
            print("cognito logged in")
            loggedIn = true
            cognitoId = cachedIdentityId
        }
        else {
            print("cognitoId not logged in")
            loggedIn = false
            cognitoId = ""
        }
        
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
                }
                return nil
            }
        }
        else {
            print("Facebook not logged in")
        }
    }
}