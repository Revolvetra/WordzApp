import UIKit

class UserProfileView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        backgroundColor = .lightGray
        layer.cornerRadius = 10
        clipsToBounds = true
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
