import SwiftUI

func getIcon(description: String, isNight: Bool) -> String{
    print(description.lowercased().trimmingCharacters(in: [" "]))
    switch description.lowercased().trimmingCharacters(in: [" "]){
    case "sunny" where !isNight, "clear" where !isNight:
        return "sun.max.fill"
    case "clear" where isNight:
        return "moon.stars.fill"
    case "partly cloudy" where !isNight:
        return "cloud.sun.fill"
    case "partly cloudy" where isNight:
        return "cloud.moon.fill"
    case "cloudy":
        return "cloud.fill"
    case "patchy rain possible", 
        "patchy rain nearby" where !isNight:
        return "cloud.sun.rain.fill"
    case "patchy rain possible" where isNight, "patchy rain nearby" where isNight:
        return "cloud.moon.rain.fill"
    case "Patchy snow possible" where isNight:
        return "cloud.snow.fill"
    case "Patchy snow possible" where !isNight:
        return "sun.snow.fill"
    default:
        return "wind"
    }
}
