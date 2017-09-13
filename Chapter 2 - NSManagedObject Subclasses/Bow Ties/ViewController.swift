/*
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import CoreData

class ViewController: UIViewController {

  // MARK: - IBOutlets
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var ratingLabel: UILabel!
  @IBOutlet weak var timesWornLabel: UILabel!
  @IBOutlet weak var lastWornLabel: UILabel!
  @IBOutlet weak var favoriteLabel: UILabel!
	
	var managedContext: NSManagedObjectContext!

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
		
		insertSampleData()
		
		
		
  }
	
	// Insert sample data
	func insertSampleData() {
	
		let fetch = NSFetchRequest<Bowtie>(entityName: "Bowtie")
		fetch.predicate = NSPredicate(format: "searchKey != nil")
		
		let count = try! managedContext.count(for: fetch)
		if count > 0 {return}
		
		let path = Bundle.main.path(forResource: "SampleData", ofType: "plist")
		let dataArray = NSArray(contentsOfFile: path!)!
		
		for dict in dataArray {
			
			let entity = NSEntityDescription.entity(forEntityName: "Bowtie", in: managedContext)!
			let bowtie = Bowtie(entity: entity, insertInto: managedContext)
			
			let btDict = dict as! [String: AnyObject]
			
			bowtie.name = btDict["name"] as? String
			bowtie.searchKey = btDict["searchKey"] as? String
			bowtie.rating = btDict["rating"] as? NSDecimalNumber
			bowtie.lastWorn = btDict["lastWorn"] as? NSDate
			bowtie.timesWorn = btDict["timesWorn"] as! Int32
			bowtie.isFavorite = btDict["isFavorite"] as! Bool
			
			let imageName = btDict["imageName"] as? String
			let image = UIImage(named: imageName!)
			let photoData = UIImagePNGRepresentation(image!)!
			bowtie.photoData = NSData(data: photoData)
			
			let colorDict = btDict["tintColor"] as! [String: AnyObject]
			bowtie.tintColor = UIColor.getTintColor(tintColor: colorDict)
		}
	
		try! managedContext.save()
	}

  // MARK: - IBActions
  @IBAction func segmentedControl(_ sender: AnyObject) {

  }

  @IBAction func wear(_ sender: AnyObject) {

  }
  
  @IBAction func rate(_ sender: AnyObject) {

  }
}

private extension UIColor {
	static func getTintColor(tintColor: [String: AnyObject]) -> UIColor? {
		
		guard let red = tintColor["red"] as? NSNumber,
			let green = tintColor["green"] as? NSNumber,
			let blue = tintColor["blue"] as? NSNumber else {return nil}
		
		
		return UIColor(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: 1)
	}
}
