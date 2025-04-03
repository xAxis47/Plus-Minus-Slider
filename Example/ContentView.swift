import SwiftUI


struct ContentView: View {
    
    @State var flag: Bool = false
    
    @State var value: Double = 0
    
    @State var barWidth: Double = 60
    @State var barHeight: Double = 10
    @State var isHideLimitValue: Bool = false
    @State var isHideThumbValue: Bool = false
    @State var isIntValue: Bool = true
    @State var isUnderValue: Bool = false
    @State var isVertical: Bool = false
    @State var limitValueOffset: CGFloat = 15
    @State var maxSFSymbolsString: String = "figure.2"
    @State var maxValue: Double = 5
    @State var maxValueColor: Color = .black
    @State var maxValueFont: Font = .body
    @State var maxValueFontWeight: Font.Weight = .regular
    @State var minSFSymbolsString: String = "figure.stand"
    @State var minValue: Double = -5
    @State var minValueColor: Color = .black
    @State var minValueFont: Font = .body
    @State var minValueFontWeight: Font.Weight = .regular
    @State var sliderColor: Color = Color(.systemGray5)
    @State var thumbColor: Color = Color(.systemGray)
    @State var thumbDiameter: Double = 30
    @State var thumbValueColor: Color = .black
    @State var thumbValueFont: Font = .body
    @State var thumbValueFontWeight: Font.Weight = .regular
    @State var thumbValueOffset: Double = 30
    @State var valueColor: Color = .blue
    
    var body: some View {
        
        let slider = PlusMinusSlider(thumbValue: $value)
            .barWidth(barWidth)
            .barHeight(barHeight)
            .isHideLimitValue(isHideLimitValue)
            .isHideThumbValue(isHideThumbValue)
            .isIntValue(isIntValue)
            .isUnderValue(isUnderValue)
            .isVertical(isVertical)
            .limitValueOffset(limitValueOffset)
            .maxSFSymbolsString(maxSFSymbolsString)
            .maxValue(maxValue)
            .maxValueColor(maxValueColor)
            .maxValueFont(maxValueFont)
            .maxValueFontWeight(maxValueFontWeight)
            .minSFSymbolsString(minSFSymbolsString)
            .minValue(minValue)
            .minValueColor(minValueColor)
            .minValueFont(minValueFont)
            .minValueFontWeight(minValueFontWeight)
            .sliderColor(sliderColor)
            .thumbColor(thumbColor)
            .thumbDiameter(thumbDiameter)
            .thumbValueColor(thumbValueColor)
            .thumbValueFont(thumbValueFont)
            .thumbValueFontWeight(thumbValueFontWeight)
            .thumbValueOffset(thumbValueOffset)
            .valueColor(valueColor)
         
        let steppers = VStack {
            
            Stepper("\(Int(barWidth)) / barWidth", value: $barWidth, in: 60...300, step: 10) {_ in
                flag.toggle()
            }
            
            Stepper("\(Int(barHeight)) / barHeight", value: $barHeight, in: 5...30, step: 5)
            
            Stepper("\(Int(limitValueOffset)) / limitValueOffset", value: $limitValueOffset, in: 0...20, step: 5)
            
            Stepper("\(Int(maxValue)) / maxValue", value: $maxValue, in: 5...15, step: 1) {_ in
                flag.toggle()
            }
            
            Stepper("\(Int(minValue)) / minValue", value: $minValue, in: (-14)...(-6), step: -1) {_ in
                flag.toggle()
            }
            
            Stepper("\(Int(thumbDiameter)) / thumbDiameter", value: $thumbDiameter, in: 5...30, step: 5)
            
            Stepper("\(Int(thumbValueOffset)) / thumbValueOffset", value: $thumbValueOffset, in: 5...50, step: 5)
            
        }
        
        VStack {
            
            if !isVertical {
                
                if flag {
                    slider
                } else {
                    slider
                }
                
                steppers
                
            } else {
                
                HStack(alignment: .center) {
                    
                    if flag {
                        slider
                    } else {
                        slider
                    }
                    
                    steppers
                    
                }
                
            }
            
            HStack {
                
                Button(action: {isIntValue.toggle()}, label:{Text("isIntValue")})
                    .frame(width: 180, height: 36)
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(24)
                
                Button(action: {isVertical.toggle()}, label:{Text("isVertical")})
                    .frame(width: 180, height: 36)
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(24)
            }
            
            HStack {
                
                Button(action: {isHideLimitValue.toggle()}, label: {Text(("isHideLimitValue"))})
                    .frame(width: 180, height: 36)
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(24)
                
                Button(action: {isHideThumbValue.toggle()}, label:{Text("isHideThumbValue")})
                    .frame(width: 180, height: 36)
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(24)
                
            }
            
            HStack {
                
                Button(action: {maxValueColor = changeColor()}, label: {Text(("maxValueColor"))})
                    .frame(width: 180, height: 36)
                    .foregroundColor(Color(.white))
                    .background(maxValueColor)
                    .cornerRadius(24)
                
                Button(action: {minValueColor = changeColor()}, label:{Text("minValueColor")})
                    .frame(width: 180, height: 36)
                    .foregroundColor(Color(.white))
                    .background(minValueColor)
                    .cornerRadius(24)
                
            }
            
            HStack {
                
                Button(action: {maxValueFont = randomFont()}, label: {Text(("maxValueFont"))})
                    .frame(width: 180, height: 36)
                    .foregroundColor(Color(.white))
                    .background(.blue)
                    .cornerRadius(24)
                
                Button(action: {minValueFont = randomFont()}, label:{Text("minValueFont")})
                    .frame(width: 180, height: 36)
                    .foregroundColor(Color(.white))
                    .background(.blue)
                    .cornerRadius(24)
                
            }
            
            HStack {
                
                Button(action: {maxValueFontWeight = randomFontWeight()}, label: {Text(("maxValueFontWeight"))})
                    .frame(width: 180, height: 36)
                    .foregroundColor(Color(.white))
                    .background(.blue)
                    .cornerRadius(24)
                
                Button(action: {minValueFontWeight = randomFontWeight()}, label:{Text("minValueFontWeight")})
                    .frame(width: 180, height: 36)
                    .foregroundColor(Color(.white))
                    .background(.blue)
                    .cornerRadius(24)
                
            }
            
            HStack {
                
                Button(action: {sliderColor = changeColor()}, label: {Text(("sliderColor"))})
                    .frame(width: 180, height: 36)
                    .foregroundColor(Color(.white))
                    .background(sliderColor)
                    .cornerRadius(24)
                
                Button(action: {thumbColor = changeColor()}, label:{Text("thumbColor")})
                    .frame(width: 180, height: 36)
                    .foregroundColor(Color(.white))
                    .background(thumbColor)
                    .cornerRadius(24)
                
            }
            
            HStack {
                
                Button(action: {thumbValueColor = changeColor()}, label: {Text(("thumbValueColor"))})
                    .frame(width: 180, height: 36)
                    .foregroundColor(Color(.white))
                    .background(thumbValueColor)
                    .cornerRadius(24)
                
                Button(action: {thumbValueFont = randomFont()}, label:{Text("thumbValueFont")})
                    .frame(width: 180, height: 36)
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(24)
                
            }
            
            HStack {
                
                Button(action: {thumbValueFontWeight = randomFontWeight()}, label: {Text(("thumbValueFontWeight"))})
                    .frame(width: 180, height: 36)
                    .foregroundColor(Color(.white))
                    .background(.blue)
                    .cornerRadius(24)
                
                Button(action: {valueColor = changeColor()}, label:{Text("valueColor")})
                    .frame(width: 180, height: 36)
                    .foregroundColor(.white)
                    .background(valueColor)
                    .cornerRadius(24)
                
            }
            
            HStack {
                
                Button(action: {
                    
                    if minSFSymbolsString == "" {
                        minSFSymbolsString = "figure.stand"
                    } else {
                        minSFSymbolsString = ""
                    }
                    
                }, label: {Text(("minSFSymbolsString"))})
                    .frame(width: 180, height: 36)
                    .foregroundColor(Color(.white))
                    .background(.blue)
                    .cornerRadius(24)
                
                Button(action: {
                    
                    if maxSFSymbolsString == "" {
                        maxSFSymbolsString = "figure.2"
                    } else {
                        maxSFSymbolsString = ""
                    }

                }, label:{Text("maxSFSymbolsString")})
                    .frame(width: 180, height: 36)
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(24)
                
            }
            
            HStack {
                
                Button(action: {isUnderValue.toggle()}, label: {Text(("isUnderValue"))})
                    .frame(width: 180, height: 36)
                    .foregroundColor(Color(.white))
                    .background(.blue)
                    .cornerRadius(24)
                
            }
            
            
        }
        .padding()
    }
    
    func changeColor() -> Color {
        return Color(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1))

    }
    
    func randomFont() -> Font {
        
        return [Font.largeTitle, Font.title, Font.title2, Font.title3, Font.headline, Font.subheadline, Font.body, Font.callout, Font.footnote, Font.caption, Font.caption2].randomElement()!
        
    }
    
    func randomFontWeight() -> Font.Weight {
        
        return [Font.Weight.medium, Font.Weight.regular, Font.Weight.semibold, Font.Weight.bold, Font.Weight.black, Font.Weight.heavy, Font.Weight.light, Font.Weight.ultraLight, Font.Weight.thin].randomElement()!
        
    }
            
}

#Preview {
    ContentView()
}
