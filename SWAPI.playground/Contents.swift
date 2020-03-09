import Foundation

// MARK: - Models

struct Person: Decodable {
    
    let name: String
    let height: String
    let mass: String
    let hair_color: String
    let skin_color: String
    let eye_color: String
    let birth_year: String
    let gender: String
    let homeworld: String
    let films: [String]
    let species: [String]
    let vehicles: [String]
    let starships: [String]
    let created: String
    let edited: String
    let url: String
}

struct Film: Decodable {
    let title: String
    let opening_crawl: String
    let release_date: String
}

// MARK: - Controllers

class SwapiService {
    
    static private let baseURL = URL(string: "https://swapi.co/api/")
    static private let personEndpoint = "people"
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        // Assemble URL
        guard let baseURL = baseURL else { return completion(nil) }
        let personURL = baseURL.appendingPathComponent(personEndpoint)
        print(personURL)
        
        let finalURL = personURL.appendingPathComponent(String(id))
        print(finalURL)
        // Data Task
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            
            // Error handling
            if let error = error {
                print(error, error.localizedDescription)
                return completion(nil)
            }
            
            // check for data
            guard let data = data else { return completion(nil) }
    
            // decode data
            do {
                let person = try JSONDecoder().decode(Person.self, from: data)
                return completion(person)
            } catch {
                print(error, error.localizedDescription)
                return completion(nil)
            }
        }.resume()
    }
    
}

SwapiService.fetchPerson(id: 10) { person in
    if let person = person {
        print(person)
    }
}
