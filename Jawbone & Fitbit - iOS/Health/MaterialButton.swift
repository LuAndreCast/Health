

import UIKit

class MaterialButton: UIButton
{

    override func awakeFromNib()
    {
        layer.shadowColor   = UIColor.blue.cgColor
        layer.shadowOpacity = 0.9
        layer.shadowRadius  = 15.0
        layer.shadowOffset  = CGSize(width: 0.0, height: 2.0)
    }//eom
}
