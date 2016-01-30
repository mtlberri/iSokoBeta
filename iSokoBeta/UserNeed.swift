import Foundation

// UserNeed is a subclass of NSObject, and conforms to NSCoding to be able to encode and decode itself for storage
class UserNeed: NSObject, NSCoding {
    
    // MARK: static properties
    // maximum figure used for the UISlider for the user to define its need in term of mobile data
    static let maxProposedMobileData = 15
    
    // MARK: instance properties
    var unlimitedNationwideMinutes: Bool
    var monthlyCellularDataAmount: Float
    var newDeviceRequired: String?
    
    // MARK: Archiving paths
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("userneed")
    
    
    // MARK: PropertKey for archiving
    struct PropertyKey {
        static let unlimitedNationwideMinutesKey = "unlimitedNationwideMinutes"
        static let monthlyCellularDataAmountKey = "monthlyCellularDataAmount"
        static let newDeviceRequiredKey = "newDeviceRequired"
    }
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        // Objects encoding
        aCoder.encodeBool(unlimitedNationwideMinutes, forKey: PropertyKey.unlimitedNationwideMinutesKey)
        aCoder.encodeFloat(monthlyCellularDataAmount, forKey: PropertyKey.monthlyCellularDataAmountKey)
        aCoder.encodeObject(newDeviceRequired, forKey: PropertyKey.newDeviceRequiredKey)
    }
    
    // MARK: Designated initializer (failable)
    init?(unlimitedNationwideMinutes: Bool, monthlyCellularDataAmount: Float, newDeviceRequired: String?) {
        // initialization of stored properties
        self.unlimitedNationwideMinutes = unlimitedNationwideMinutes
        self.monthlyCellularDataAmount = monthlyCellularDataAmount
        self.newDeviceRequired = newDeviceRequired
        // designated initializer shoudl then call the superclass init
        super.init()
    }
    
    // MARK: NSCOding Initializer
    required convenience init?(coder aDecoder: NSCoder) {
        let unlimitedNationwideMinutes = aDecoder.decodeBoolForKey(PropertyKey.unlimitedNationwideMinutesKey)
        let monthlyCellularDataAmount = aDecoder.decodeFloatForKey(PropertyKey.monthlyCellularDataAmountKey)
        let newDeviceRequired = aDecoder.decodeObjectForKey(PropertyKey.newDeviceRequiredKey) as? String
        
        self.init(unlimitedNationwideMinutes: unlimitedNationwideMinutes, monthlyCellularDataAmount: monthlyCellularDataAmount, newDeviceRequired: newDeviceRequired)
    }
    
}
