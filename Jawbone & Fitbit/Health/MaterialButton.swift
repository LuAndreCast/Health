

import UIKit

class MaterialButton: UIButton
{

    override func awakeFromNib()
    {
        layer.shadowColor   = UIColor.blueColor().CGColor
        layer.shadowOpacity = 0.9
        layer.shadowRadius  = 15.0
        layer.shadowOffset  = CGSizeMake(0.0, 2.0)
    }//eom
}
