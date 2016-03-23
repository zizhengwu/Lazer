import UIKit
import SnapKit

class TagCell : UICollectionViewCell {
    
    let name: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.contentView.addSubview(name)
        
        name.snp_makeConstraints{ (make) -> Void in
            make.centerY.equalTo(self.contentView)
            make.centerX.equalTo(self.contentView)
        }
    }
}