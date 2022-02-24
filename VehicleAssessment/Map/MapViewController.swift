//
//  ViewController.swift
//  VehicleAssessment
//
//  Created by Tejas Dubal on 22/02/22.
//

import UIKit
import MapKit


protocol MapViewControllerProtocol {
    func recievedVehiclesData(vehicles: [VehicleModel]?)
}

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var vehicleCollection: UICollectionView!
    
    @IBOutlet weak var bottomView: BottomOverlayView!
    
    @IBOutlet weak var vehicleName: UILabel!
    @IBOutlet weak var kcsLabel: UILabel!
    @IBOutlet weak var chargeLabel: UILabel!
    @IBOutlet weak var kmLabel: UILabel!
    
    private var viewModel: MapViewViewModelProtocol?
    
    var vehicles = [VehicleModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        
    }

    
    private func setupUI() {
        // Setting up bottom view background color
        bottomView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.0)

        // Initiating view model
        viewModel = MapViewViewModel(mapViewController: self)
        
        // Call to get vehicles data
        viewModel?.getVehicles()
        
        registerNib()
        
        // Call to confirm delegate and datasource
        confirmDelegateDataSource()
    }
    
    //Register Nibs
    func registerNib() {
        
        //Regestering custom annotation view to map view
        mapView.register(
          VehicleAnnotationView.self,
          forAnnotationViewWithReuseIdentifier:
            MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        // Registering collection view cell to colletion view view
        let nib = UINib(nibName: VechicleCollectionViewCell.nibName, bundle: nil)
        vehicleCollection?.register(nib, forCellWithReuseIdentifier: VechicleCollectionViewCell.reuseIdentifier)
        if let flowLayout = self.vehicleCollection?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        }
    }
    
    func confirmDelegateDataSource() {
        vehicleCollection.delegate = self
        vehicleCollection.dataSource = self
        
        mapView.delegate = self
    }
    
    
    func changeMapLocation(model: VehicleModel?) {
        mapView.centerToLocation(CLLocation(latitude: (model?.lat ?? 0), longitude: (model?.lng ?? 0)))
    }

}


//MARK: UICollectionView Delegate and Datasource
extension MapViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.vehicles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VechicleCollectionViewCell.reuseIdentifier, for: indexPath) as? VechicleCollectionViewCell {
            
            let model = vehicles[indexPath.item]
            cell.model = model
            cell.configureCell()
            return cell
        }
        return UICollectionViewCell()
    }
    

}


//MARK: Collection View Flow Layout
extension MapViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell: VechicleCollectionViewCell = Bundle.main.loadNibNamed(VechicleCollectionViewCell.nibName,
                                                                      owner: self,
                                                                      options: nil)?.first as? VechicleCollectionViewCell else {
            return CGSize.zero
        }
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        let size: CGSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return CGSize(width: 230, height: 180)
    }
    
    
    // Centerning collection view cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellWidth: CGFloat = 230 // Your cell width

        let numberOfCells = floor(view.frame.size.width / cellWidth)
        let edgeInsets = (view.frame.size.width - (numberOfCells * cellWidth)) / (numberOfCells + 1)

        return UIEdgeInsets(top: 0, left: edgeInsets, bottom: 0, right: edgeInsets)
    }
    
    
}



//MARK: Protocol methods

extension MapViewController: MapViewControllerProtocol {
    
    private func setInitialCarData() {
        guard let firstVehicle = vehicles.first else { return }
        
        vehicleName.text = firstVehicle.vehicleMake

        kcsLabel.set(image: UIImage.init(systemName: "squareshape.squareshape.dashed") ?? UIImage(), with: (String(firstVehicle.remainingRangeInMeters )))
        
        chargeLabel.set(image: UIImage.init(named: "bolt-50") ?? UIImage(), with: String(firstVehicle.remainingMileage))
    }
    
    
    func recievedVehiclesData(vehicles: [VehicleModel]?) {
        
        guard let unwrappedVehicles = vehicles else { return }
        self.vehicles = unwrappedVehicles

        self.changeMapLocation(model: unwrappedVehicles.first)
        
        unwrappedVehicles.map { model in
            self.viewModel?.getDecodedLocation(coordinates: model.vAnnotation?.coordinate) {
                address in
                model.vAnnotation?.locationName = address
                DispatchQueue.main.async {
                    self.mapView.addAnnotation(model.vAnnotation!)
                }
            }
        }

        setInitialCarData()
        self.vehicleCollection.reloadData()
    }
}






//MARK: MKMapView Extension
private extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}



extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print(view.debugDescription)
        
        guard let unWrappedAnnotation = view.annotation as? VehicleAnnotation else { return }
        let selectedAnnotationId = unWrappedAnnotation.id
        
        guard let selectedIdIndex = self.vehicles.firstIndex(where: { $0.id == selectedAnnotationId }) else { return }
        
        DispatchQueue.main.async {
            print(IndexPath(row: selectedIdIndex, section: 0))
            self.vehicleCollection.scrollToItem(at: IndexPath(item: selectedIdIndex, section: 0), at: .left, animated: true)
        }
        self.vehicleCollection.setNeedsLayout()
        
        setBottomViewData(indexValue: selectedIdIndex)

    }
    
    private func setBottomViewData(indexValue: Int) {
        let vehicle = vehicles[indexValue]
        
        kcsLabel.set(image: UIImage.init(systemName: "squareshape.squareshape.dashed") ?? UIImage(), with: (String(vehicle.remainingRangeInMeters )))
        
        chargeLabel.set(image: UIImage.init(named: "bolt-50") ?? UIImage(), with: String(vehicle.remainingMileage))
        
        vehicleName.text = vehicle.vehicleMake

    }
}


extension MapViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: vehicleCollection.contentOffset, size: vehicleCollection.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath = vehicleCollection.indexPathForItem(at: visiblePoint)
        
        for _ in vehicleCollection.visibleCells {
            //let indexPath = vehicleCollection.indexPath(for: cell)
            print(visibleIndexPath as Any)
            
            let model = vehicles[(visibleIndexPath?.item ?? 0)]
            changeMapLocation(model: model)
            setBottomViewData(indexValue: (visibleIndexPath?.item ?? 0))
        }
    }

}
