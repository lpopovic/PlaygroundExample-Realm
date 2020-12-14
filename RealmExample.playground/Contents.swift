import Foundation
import RealmSwift
import CoreLocation

// MARK: -  Setup
let realm = try! Realm(configuration:
  Realm.Configuration(inMemoryIdentifier: "TemporaryRealm"))

print("Ready to play...")

// MARK: - Playground
// MARK: Car
class Car: Object {
    
    @objc dynamic var brand = ""
    @objc dynamic var year = 0
    
    convenience init(brand: String, year: Int) {
        self.init()
        self.brand = brand
        self.year = year
    }
    
    override var description: String {
        return "🚗 {\(brand), \(year)}"
    }
}

ExamplePrint.of("Basic Modal") {
    let car1 = Car(brand: "BMW", year: 1980)
    print(car1)

}
// MARK: Person
class Person: Object {
    // String
    @objc dynamic var firstName = ""
    @objc dynamic var lastName: String?
    
    // Date
    @objc dynamic var born = Date.distantPast
    @objc dynamic var deceased: Date?
    
    // Data
    //An important limitation to be aware of is that String and Data properties cannot hold more than 16MB of data
    @objc dynamic var photo: Data?
    
    //Bool
    @objc dynamic var isVip: Bool = false
    
    // Int, Int8, Int16, Int32, Int64
    @objc dynamic var id = 0 // Inferred as Int
    @objc dynamic var hairCount: Int64 = 0
    
    // Float, Double
    @objc dynamic var height: Float = 0.0
    @objc dynamic var weight = 0.0 // Inferred as Double
    
//    // Compound property
//    private let lat = RealmOptional<Double>()
//    private let lng = RealmOptional<Double>()
//
//    var lastLocation: CLLocation? {
//        get {
//            guard let lat = lat.value, let lng = lng.value else {
//                return nil
//            }
//            return CLLocation(latitude: lat, longitude: lng)
//        }
//        set {
//            guard let location = newValue?.coordinate else {
//                lat.value = nil
//                lng.value = nil
//                return
//            }
//            lat.value = location.latitude
//            lng.value = location.longitude
//        }
//    }
    
    // Enumerations
    enum Department: String {
      case technology
      case politics
      case business
      case health
      case science
      case sports
      case travel
    }
    
    @objc dynamic private var _department = Department.technology.rawValue
    
    var department : Department {
        get {
            return Department(rawValue: _department)!
        }
        set {
            _department = newValue.rawValue
        }
    }
    
    // Computed Properties
    var isDeceased: Bool {
        return deceased != nil
    }
    
    var fullName: String {
        guard let last = self.lastName else {
            return self.firstName
            
        }
        
        return "\(firstName) \(last)"
    }
    
    convenience init(firstName: String, born: Date, id: Int) {
        self.init()
        self.firstName = firstName
        self.born = born
        self.id = id
    }
    
    @objc dynamic var key = UUID().uuidString
    
    override static func primaryKey() -> String? {
        return "key"
    }
    // In addition to accessing and modifying records by primary key, you can also choose to create fast-access indexes on other properties of your Realm object.
    override class func indexedProperties() -> [String] {
        return ["firstName", "lastName"]
    }
    // Ignored properties => Properties with inaccessible setters
    let idPropertyName = "id"
    var temporaryId = 0
    
    // Ignored properties => Custom ignored properties
    @objc dynamic var temporaryUploadId = 0
    override class func ignoredProperties() -> [String] {
        return ["temporaryUploadId"]
    }
    
}
ExamplePrint.of("Complex Model") {
    let person1 = Person(firstName: "Marin", born: Date(timeIntervalSince1970: 0), id: 1035)
    person1.hairCount = 12384639265974
    person1.isVip = true

    print(type(of: person1))
    print(type(of: person1).primaryKey() ?? "no primary key")
    print(type(of: person1).className())
    print(person1)
    
}

// @objcMembers

@objcMembers class Article: Object {
    dynamic var id = 0
    dynamic var title: String?
    
}

ExamplePrint.of("Using @objcMembers") {
    let article = Article()
    article.title = "New article about a famous person"
    
    print(article)
}

// MARK: - Challenge
// Add a new Book object that satisfies the following
// 1 Has an ISBN number (as a String), a title, an author name, its bestseller status, and a date of first publishing.
// 2 Could have a date of last publishing.
// 3 Has a convenience initializer to set the ISBN, title, author and first publishing date.
// 4 Has its ISBN number as the book’s unique ID, and has an index on its bestseller status.
// 5 Is assigned one of the following classifications using an enum: Fiction, Non-fiction, Self-help
// 6 Create an instance of your newly crafted Book class and print it to the debug console to make sure everything works as expected

@objcMembers class Book: Object {
    // 1
    dynamic var ISBN = ""
    dynamic var title = ""
    dynamic var authorName = ""
    dynamic var bestsellerStatus = false
    dynamic var dateOfFirstPublishing = Date.distantPast
    
    // 2
    dynamic var dateOfLastPublishing: Date?
    
    // 3
    convenience init(ISBN: String, title: String, authorName: String, dateOfFirstPublishing: Date) {
        self.init()
        self.ISBN = ISBN
        self.title = title
        self.authorName = authorName
        self.dateOfFirstPublishing = dateOfFirstPublishing
    }
    
    // 4
    enum Property: String {
      case ISBN, bestsellerStatus
    }
    
    override class func primaryKey() -> String? {
        return Book.Property.ISBN.rawValue
    }

    override class func indexedProperties() -> [String] {
        return [Book.Property.bestsellerStatus.rawValue]
    }
    
    // 5
    enum Classifications: String {
        case Fiction, Nonfiction, Selfhelp
    }
    
    @objc dynamic private var _type = Classifications.Fiction.rawValue
    var type : Classifications {
        get {
            return Classifications(rawValue: _type)!
        }
        set {
            _type = newValue.rawValue
        }
    }
    
}

// 6
ExamplePrint.of("Challenge: new Book") {
    let book1 = Book(ISBN: "12342352", title: "Stranac", authorName: "Alber Kami", dateOfFirstPublishing: Date(timeIntervalSince1970: 10000))
    book1.type = .Nonfiction
    book1.bestsellerStatus = true
//    book1.dateOfLastPublishing = Date()
    
    print(book1)
    
}

