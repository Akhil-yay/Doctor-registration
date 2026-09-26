import UIKit

class DoctorDashboardViewController: UIViewController {

    // MARK: - IBOutlets (CONNECT ALL THESE)
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var whatsappLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var practiceFromLabel: UILabel!

    // MARK: - Data
    var doctor: Doctor!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Doctor Details"
        populateData()
    }

    // MARK: - Populate UI
    func populateData() {

        nameLabel.text = doctor.name
        phoneLabel.text = doctor.phoneNo
        whatsappLabel.text = doctor.whatsappNo
        emailLabel.text = doctor.email
        countryCodeLabel.text = doctor.countryCode

        genderLabel.text = doctor.gender == "M" ? "Male" : "Female"

        ageLabel.text = "\(doctor.age) \(doctor.ageUnit)"

        // Practice From (Month/Year)
        if let practiceFrom = doctor.practiceFrom {
            practiceFromLabel.text = practiceFrom
        } else {
            practiceFromLabel.text = "N/A"
        }
    }
}
