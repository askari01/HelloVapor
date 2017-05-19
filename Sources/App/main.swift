import Vapor

let drop = Droplet()

drop.get { req in
    return try drop.view.make("welcome", [
    	"message": drop.localization[req.lang, "welcome", "title"]
    ])
}

drop.get("hello") { request in
    return "Hello, world!"
}

drop.get("/name",":name") { request in
    if let name = request.parameters["name"]?.string {
        return "Hello \(name)!"
    }
    return "Error retrieving parameters."
}

drop.get("customers", Int.self) { request, id in
    return "the passed id is \(id)"
}

drop.get("return") { request in
    return try JSON(node: ["message":"hello vapor request"])
}

class Customers: NodeRepresentable {
    let firstName: String!
    let secondName: String!
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: ["firstName":self.firstName,"secondName":self.secondName])
    }
    
    init(firstName: String, secondName: String) {
        self.firstName = firstName
        self.secondName = secondName
    }
}

drop.get("customer") {request in
    let customer = Customers(firstName: "Jan e Nabi", secondName: "Ali")
    return try JSON(node: [customer])
}

drop.post("customers") { request in
    guard let firstName = request.json?["firstName"]?.string! else {
        fatalError("firstName is missing")
    }
    guard let secondName = request.json?["secondName"]?.string! else {
        fatalError("secondName is missing")
    }
    return firstName+" "+secondName
}


let weather = WeatherController()
weather.addRoutes(drop: drop)

//drop.get("sunny") { request in
//    return "It's sunny today"
//}

//drop.get("weather", "cloudy") { request in
//    return "It's cloudy today"
//}

//drop.get("weather", String.self) { request, weather
//    in
//    return "It's \(weather) today"
//}

drop.get("weatherJSON", String.self) { request, weather
    in
    return try JSON(node:["message":"It's \(weather) today"])
}

//drop.post("post") { request in
//    guard let city = request.data["city"]?.string!
//    else {
//        throw Abort.badRequest
//    }
//    return try JSON(node: ["message":"It's sunny in \(city)"])
//}

drop.group("cities") { city in
    city.get("seattle") { request in
        return "Hello, Seattle!"
    }
    city.get("sacramento") { request in
        return "Hello, Sacramento"
    }
    return
}

drop.resource("posts", PostController())

drop.run()
