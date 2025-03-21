import SwiftUI

struct CountryButtonView: View{
    var buttonCounty:String
    var selectedCountry: String
    @Binding var cityName: String
    var body: some View {
        Button(){
            cityName =  buttonCounty
        
        } label: {
            
            if(buttonCounty == selectedCountry){
                Text("")
                    .frame(width: 32, height: 32)
                    .background(.white)
                    .cornerRadius(30)
            } else {
                Circle()
                    .stroke(Color.white, lineWidth: 4)
                    .frame(width: 30, height: 30)
            }
        }
    }
}
struct BackGroundView: View {
    var isNight: Bool
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [isNight ? Color("NightBlue"): .blue, isNight ? .black : Color("DayBlue")]), startPoint: .top,
            endPoint: .bottom)
        .ignoresSafeArea()
    }
}

struct IconAndDegreeView: View {
    var icon: String
    var degree: Decimal
    var iconSize: CGFloat
    var fontSize: CGFloat
    var title: String? = nil
    var body: some View {
        VStack(spacing: 0) {
            if let title {
                Text(title)
                    .foregroundColor (.white)
                    .font(.system(size: 20,
                    weight: .bold))
                    .padding(0)
            }
            Image(systemName: icon)
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(width: iconSize, height: iconSize)
                .padding(.bottom, 0)
            Text("\(degree)°")
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .font(.system(size: fontSize,
                 weight: .light,
                design: .default))
        }

    }
}

struct ForecastView: View {
    var weatherForecast: [DaysDetails]
    var isNight: Bool
    var body: some View {
        HStack(spacing: 20){
//            IconAndDegreeView(icon: "cloud.sun.fill", degree: 28, iconSize: 50, fontSize: 20, title: "Friday")
            ForEach(weatherForecast, id: \.self.dayId) { singleDay in
                if (singleDay.dayId != 0){

                    
                    IconAndDegreeView(icon: getIcon(description: singleDay.dayWeather.condition.text , isNight: isNight),
                            degree: singleDay.dayWeather.maxtempC,
                                      iconSize: 50, fontSize: 20, title: singleDay.dayName.getDayInString())
                }
            }
            
            

                
            
            
        }
        
    }
}


