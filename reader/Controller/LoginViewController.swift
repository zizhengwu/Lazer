import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate  {
    
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFontOfSize(20)
        label.textAlignment = .Center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.translucent = false
        
        view.backgroundColor = UIColor.whiteColor()
        navigationItem.title = "Facebook Login"
        
        setupSubviews()
        
//        if let _ = FBSDKAccessToken.currentAccessToken() {
//            fetchProfile()
//        }
    }
    
    func setupSubviews() {
        view.addSubview(loginButton)
        view.addSubview(userImageView)
        view.addSubview(nameLabel)
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": userImageView]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-80-[v0]-80-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": loginButton]))
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-8-[v0(100)]-8-[v1(30)]-8-[v2(50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": userImageView, "v1": nameLabel, "v2": loginButton]))
        
        loginButton.delegate = self
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        LoginManager.sharedInstance.facebookLogin()
        LoginManager.sharedInstance.sync()
        LoginManager.sharedInstance.fetchProfile()
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        LoginManager.sharedInstance.clearProfile()
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
}

struct Friend {
    var name, picture: String?
}

