import UIKit
import SnapKit

class PreferenceViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    var collectionView: UICollectionView!
    let flowLayout = UICollectionViewFlowLayout()
    let tagCellCellId = "tagCellCellId"
    let names =  ["hello" ,"hello world" ,"technology" ,"hello" ,"hello world" ,"technology" ,"hello" ,"hello world" ,"technology" ,"hello" ,"hello world" ,"technology hello world hello world" ,"hello" ,"hello world"]
    var tags = [Tag]()
    var avatarImageView: UIImageView?
    var userNameLabel: UILabel?
    var introduceLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        for name in names {
            let tag = Tag()
            tag.name = name
            self.tags.append(tag)
        }
        setupViews()
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 14
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(tagCellCellId, forIndexPath: indexPath) as! TagCell
        let tag = tags[indexPath.row]
        cell.name.textColor = tag.selected ? UIColor.whiteColor() : UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        cell.backgroundColor = tag.selected ? UIColor(red: 0, green: 1, blue: 0, alpha: 1) : UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        cell.name.text = names[indexPath.item]
        return cell
    }
    
    func setupViews(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 90, height: 120)
        
        self.flowLayout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: flowLayout)
        collectionView.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")
        collectionView?.registerClass(TagCell.self, forCellWithReuseIdentifier: tagCellCellId)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.whiteColor()
        // if you don't do something about header size...
        // ...you won't see any headers
        self.flowLayout.headerReferenceSize = CGSizeMake(self.view.frame.width, 180)
        collectionView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.view.addSubview(collectionView)
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var v : UICollectionReusableView! = nil
        if kind == UICollectionElementKindSectionHeader {
            v = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier:"Header", forIndexPath:indexPath)
            if v.subviews.count == 0 {
                
                self.avatarImageView = UIImageView()
                self.avatarImageView!.backgroundColor = UIColor(white: 0.9, alpha: 0.3)
                self.avatarImageView!.layer.borderWidth = 1.5
                self.avatarImageView!.layer.borderColor = UIColor(white: 1, alpha: 0.6).CGColor
                self.avatarImageView!.layer.masksToBounds = true
                self.avatarImageView!.layer.cornerRadius = 38
                let singleTap = UITapGestureRecognizer(target: self, action: #selector(PreferenceViewController.clickOnAvatar))
                singleTap.numberOfTapsRequired = 1
                self.avatarImageView!.userInteractionEnabled = true
                self.avatarImageView!.addGestureRecognizer(singleTap)
                v.addSubview(self.avatarImageView!)
                
                self.avatarImageView!.snp_makeConstraints{ (make) -> Void in
                    make.centerX.equalTo(v)
                    make.centerY.equalTo(v).offset(-40)
                    make.width.height.equalTo(self.avatarImageView!.layer.cornerRadius * 2)
                }
                
                self.userNameLabel = UILabel()
                self.userNameLabel!.textColor = UIColor(white: 0.05, alpha: 1)
                self.userNameLabel!.font = UIFont.boldSystemFontOfSize(20)
                v.addSubview(self.userNameLabel!)
                
                self.userNameLabel!.snp_makeConstraints{ (make) -> Void in
                    make.top.equalTo(self.avatarImageView!.snp_bottom).offset(10)
                    make.centerX.equalTo(self.avatarImageView!)
                }
                
                self.introduceLabel = UILabel()
                self.introduceLabel!.textColor = UIColor(white: 0.75, alpha: 1)
                self.introduceLabel!.font = UIFont.systemFontOfSize(14)
                self.introduceLabel!.numberOfLines = 2
                self.introduceLabel!.textAlignment = .Center
                v.addSubview(self.introduceLabel!)
                
                self.introduceLabel!.snp_makeConstraints{ (make) -> Void in
                    make.top.equalTo(self.userNameLabel!.snp_bottom).offset(5)
                    make.centerX.equalTo(self.avatarImageView!)
                    make.left.equalTo(v).offset(15)
                    make.right.equalTo(v).offset(-15)
                }
            }
        }
        return v
    }
    
    override func viewDidAppear(animated: Bool) {
        self.drawProfile()
    }
    
    func drawProfile() {
        if let userName = LoginManager.sharedInstance.userName {
            self.userNameLabel!.text = userName
        }
        else {
            self.userNameLabel!.text = "Unregistered"
        }
        
        if let userEmail = LoginManager.sharedInstance.userEmail {
            self.introduceLabel!.text = userEmail
        }
        else {
            self.introduceLabel!.text = "Click the avatar to login"
        }
        
        if let userAvatar = LoginManager.sharedInstance.userImage {
            self.avatarImageView?.image = userAvatar
        }
        else {
            self.avatarImageView?.image = nil
        }
    }
    
    func clickOnAvatar() {
        self.navigationController?.pushViewController(LoginViewController(), animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let rect = NSString(string: names[indexPath.item]).boundingRectWithSize(CGSizeMake(view.frame.width, 1000), options: NSStringDrawingOptions.UsesFontLeading.union(NSStringDrawingOptions.UsesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFontOfSize(14)], context: nil)
        return CGSize(width: rect.width + 20, height: rect.height + 10)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: false)
        tags[indexPath.row].selected = !tags[indexPath.row].selected
        self.collectionView.reloadData()
    }
    
}