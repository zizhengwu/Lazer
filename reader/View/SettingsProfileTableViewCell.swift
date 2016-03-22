import UIKit
import SnapKit
import Foundation

class SettingsProfileTableViewCell : UITableViewCell {
    
    var avatarImageView: UIImageView?
    var userNameLabel: UILabel?
    var introduceLabel: UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.setupViews();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupViews()->Void{
        self.backgroundColor = UIColor.clearColor()
        self.selectionStyle = .None
        
        self.avatarImageView = UIImageView()
        self.avatarImageView!.backgroundColor = UIColor(white: 0.9, alpha: 0.3)
        self.avatarImageView!.layer.borderWidth = 1.5
        self.avatarImageView!.layer.borderColor = UIColor(white: 1, alpha: 0.6).CGColor
        self.avatarImageView!.layer.masksToBounds = true
        self.avatarImageView!.layer.cornerRadius = 38
        self.contentView.addSubview(self.avatarImageView!)
        self.avatarImageView!.snp_makeConstraints{ (make) -> Void in
            make.centerX.equalTo(self.contentView)
            make.centerY.equalTo(self.contentView).offset(-40)
            make.width.height.equalTo(self.avatarImageView!.layer.cornerRadius * 2)
        }
        
        self.userNameLabel = UILabel()
        self.userNameLabel!.textColor = UIColor(white: 0.85, alpha: 1)
        self.userNameLabel!.font = UIFont.systemFontOfSize(20)
        self.contentView.addSubview(self.userNameLabel!)
        self.userNameLabel!.snp_makeConstraints{ (make) -> Void in
            make.top.equalTo(self.avatarImageView!.snp_bottom).offset(10)
            make.centerX.equalTo(self.avatarImageView!)
        }
        
        self.introduceLabel = UILabel()
        self.introduceLabel!.textColor = UIColor(white: 0.75, alpha: 1)
        self.introduceLabel!.font = UIFont.systemFontOfSize(14)
        self.introduceLabel!.numberOfLines = 2
        self.introduceLabel!.textAlignment = .Center
        self.contentView.addSubview(self.introduceLabel!)
        self.introduceLabel!.snp_makeConstraints{ (make) -> Void in
            make.top.equalTo(self.userNameLabel!.snp_bottom).offset(5)
            make.centerX.equalTo(self.avatarImageView!)
            make.left.equalTo(self.contentView).offset(15)
            make.right.equalTo(self.contentView).offset(-15)
        }
        self.userNameLabel!.text = "Zizheng Wu"
        self.introduceLabel!.text = "me@zizhengwu.com"
    }
    
}