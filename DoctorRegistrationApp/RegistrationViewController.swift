import UIKit

class RegistrationViewController: UIViewController {
    
    // MARK: - IBOutlets (CONNECT ALL IN STORYBOARD)
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var whatsappTF: UITextField!
    @IBOutlet weak var countryCodeTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var genderSegment: UISegmentedControl!
    
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var ageUnitTF: UITextField!
    
    @IBOutlet weak var practiseFromMonthTF: UITextField!
    @IBOutlet weak var practiseFromYearTF: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Setup
    
    func setupUI() {
        title = "Doctor Registration"
        
        countryCodeTF.text = "IN"
        ageUnitTF.text = "Y"
        
        registerButton.layer.cornerRadius = 8
    }
    
    // MARK: - Register Button Action
    
    @IBAction func registerTapped(_ sender: UIButton) {
        registerDoctor()
    }
    
    // MARK: - API CALL (POST)
    
    func registerDoctor() {
        
        let urlString =
        "http://199.192.26.248:8000/sap/opu/odata/sap/ZCDS_C_TEST_REGISTER_NEW_CDS/ZCDS_C_TEST_REGISTER_NEW"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let gender = genderSegment.selectedSegmentIndex == 0 ? "M" : "F"
        
        let payload: [String: Any] = [
            
            "Name": nameTF.text ?? "",
            "NameUpper": nameTF.text?.uppercased() ?? "",
            
            "PhoneNo": phoneTF.text ?? "",
            "WhatsappNo": whatsappTF.text ?? "",
            "CountryCode": countryCodeTF.text ?? "IN",
            
            "Email": emailTF.text ?? "",
            
            "Gender": gender,
            
            "Age": ageTF.text ?? "",
            "AgeUnit": ageUnitTF.text ?? "Y",
            
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("X", forHTTPHeaderField: "X-Requested-With")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload)
        } catch {
            print("JSON Error:", error.localizedDescription)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("API Error:", error.localizedDescription)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code:", httpResponse.statusCode)
            }
            
            if let data = data {
                let responseString = String(data: data, encoding: .utf8) ?? ""
                print("Response:", responseString)
            }
            
            DispatchQueue.main.async {
                self.showSuccessAlert()
            }
            
        }.resume()
    }
    
    // MARK: - Success Alert
    
    func showSuccessAlert() {
        let alert = UIAlertController(
            title: "Success",
            message: "Doctor registered successfully",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.openDoctorList()
        })
        
        present(alert, animated: true)
    }
    // MARK: - Success Alert
    
    func openDoctorList() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(
            withIdentifier: "DoctorListViewController"
        ) as! DoctorListViewController
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
