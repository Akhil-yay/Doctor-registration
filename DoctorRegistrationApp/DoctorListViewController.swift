import UIKit

class DoctorListViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Data Source
    var doctors: [Doctor] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchDoctors()
    }

    // MARK: - UI Setup
    func setupUI() {
        title = "Doctor List"

        tableView.dataSource = self
        tableView.delegate = self

        // IMPORTANT: identifier must match storyboard cell identifier
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DoctorCell")
    }

    // MARK: - API CALL (GET)
    func fetchDoctors() {

        let urlString =
        "http://199.192.26.248:8000/sap/opu/odata/sap/ZCDS_C_TEST_REGISTER_NEW_CDS/ZCDS_C_TEST_REGISTER_NEW"

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                print("API Error:", error.localizedDescription)
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                let decoded = try JSONDecoder().decode(DoctorResponse.self, from: data)

                DispatchQueue.main.async {
                    self.doctors = decoded.d.results
                    self.tableView.reloadData()
                }

            } catch {
                print("JSON Parsing Error:", error.localizedDescription)
            }

        }.resume()
    }
}

// MARK: - UITableViewDataSource
extension DoctorListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doctors.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "DoctorCell",
            for: indexPath
        )

        let doctor = doctors[indexPath.row]

        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text =
        """
        \(doctor.name)
        \(doctor.phoneNo) | \(doctor.gender)
        """

        cell.accessoryType = .disclosureIndicator

        return cell
    }
}

// MARK: - UITableViewDelegate
extension DoctorListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        let doctor = doctors[indexPath.row]

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(
            withIdentifier: "DoctorDashboardViewController"
        ) as! DoctorDashboardViewController

        vc.doctor = doctor
        navigationController?.pushViewController(vc, animated: true)
    }
}
