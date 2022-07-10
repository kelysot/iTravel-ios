
import Foundation
import UIKit

extension UITextField{

    func setLeftImage(imageName:String) {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        imageView.image = UIImage(named: imageName)
        self.leftView = imageView;
        self.leftViewMode = .always
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
