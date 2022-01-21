import UIKit
import GooglePlaces

protocol searchControllerDelegate {
    func didBackButtonPressed()
}
class searchController: UIViewController {
    var delegate:ViewController!
    var lat = 0.0
    var long = 0.0
    var location = ""
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var viewcontroller:ViewController?
  override func viewDidLoad() {
    super.viewDidLoad()
    searchController?.becomeFirstResponder()
    resultsViewController = GMSAutocompleteResultsViewController()
    resultsViewController?.delegate = self
    searchController = UISearchController(searchResultsController: resultsViewController)
    searchController?.searchResultsUpdater = resultsViewController
    resultsViewController?.tableCellBackgroundColor = .systemBackground
    let subView = UIView(frame: CGRect(x: 0, y: 0.0, width: 350.0, height: 45.0))
    let filter = GMSAutocompleteFilter()
    filter.type = .city
    resultsViewController!.autocompleteFilter = filter
    
    subView.addSubview((searchController?.searchBar)!)
    view.addSubview(subView)
    searchController?.searchBar.placeholder = "Enter a City"
    searchController?.searchBar.sizeToFit()
    searchController?.hidesNavigationBarDuringPresentation = false

    // When UISearchController presents the results view, present it in
    // this view controller, not one further up the chain.
    definesPresentationContext = true
  }
}

// Handle the user's selection.
extension searchController: GMSAutocompleteResultsViewControllerDelegate {
  func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                         didAutocompleteWith place: GMSPlace) {
    searchController?.isActive = false
    // Do something with the selected place.
    print("Place name: \(String(describing: place.name))")
    long = place.coordinate.longitude
    lat = place.coordinate.latitude
    location = place.name!
    delegate.long = long
    delegate.lat = lat
    delegate.searchLocation = location
    delegate.didBackButtonPressed()
    dismiss(animated: true, completion: nil)
  }

  func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                         didFailAutocompleteWithError error: Error){
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  // Turn the network activity indicator on and off again.
  func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }

  func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }
}
