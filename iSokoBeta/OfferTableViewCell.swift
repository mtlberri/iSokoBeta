import UIKit

class OfferTableViewCell: UITableViewCell {

    // MARK: properties
    
    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var providerImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
