import Foundation
import AWSCore
import AWSCognito
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit

class LoginManager {
    static let sharedInstance = LoginManager()
    
    init() {
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: Constant.COGNITO_REGIONTYPE, identityPoolId: Constant.COGNITO_IDENTITY_POOL_ID)
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            print("Facebook already logged in")
        }
        else {
            print("Facebook not logged in")
        }
    }
}