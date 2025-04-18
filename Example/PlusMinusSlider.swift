import SwiftUI

public struct PlusMinusSlider: View {
    
    @State var isTouchThumb: Bool = false
    
    @State var thumbPosition: Double = 0
    @State var leftBarPosition: Double = 0
    @State var zeroPosition: Double = 0
    
    @State var valueWidth: Double = 0
    
    @Binding var thumbValue: Double
    
    private let barWidth: Double
    private let barHeight: Double
    private let isHideLimitValue: Bool
    private let isHideThumbValue: Bool
    private let isIntValue: Bool
    private let isSmoothDrag: Bool
    private let isUnderValue: Bool
    private let isVertical: Bool
    private let limitValueOffset: Double
    private let maxSFSymbolsString: String
    private let maxValue: Double
    private let maxValueColor: Color
    private let maxValueFont: Font
    private let maxValueFontWeight: Font.Weight
    private let minSFSymbolsString: String
    private let minValue: Double
    private let minValueColor: Color
    private let minValueFont: Font
    private let minValueFontWeight: Font.Weight
    private let sliderColor: Color
    private let thumbColor: Color
    private let thumbDiameter: Double
    private let thumbValueColor: Color
    private let thumbValueFont: Font
    private let thumbValueFontWeight: Font.Weight
    private let thumbValueOffset: Double
    private let valueColor: Color
    
    private let animation: Animation = .linear(duration: 0.15)
    
    public init(barWidth: Double = UIScreen.main.bounds.width * 0.65, maxValue: Double = 5, minValue: Double = -5, thumbValue: Binding<Double>) {
        
        self.barWidth = barWidth
        self.barHeight = 10
        self.isHideLimitValue = false
        self.isHideThumbValue = false
        self.isIntValue = false
        self.isSmoothDrag = true
        self.isUnderValue = false
        self.isVertical = false
        self.limitValueOffset = 10
        self.maxSFSymbolsString = ""
        self.maxValue = maxValue
        self.maxValueColor = .primary
        self.maxValueFont = .body
        self.maxValueFontWeight = .regular
        self.minSFSymbolsString = ""
        self.minValue = minValue
        self.minValueColor = .primary
        self.minValueFont = .body
        self.minValueFontWeight = .regular
        self.sliderColor = Color(.systemGray5)
        self.thumbColor = Color(.systemGray)
        self.thumbDiameter = 30
        self.thumbValueColor = .black
        self.thumbValueFont = .body
        self.thumbValueFontWeight = .regular
        self.thumbValueOffset = 30
        self.valueColor = Color.blue
        
        self._thumbValue = thumbValue
        let initialized = initialOperation(max: maxValue, min: minValue, thumbValue: thumbValue)
        
        self._thumbPosition = initialized.thumbPosition
        self._zeroPosition = initialized.zeroPosition
        self._leftBarPosition = initialized.leftBarPosition
        self._valueWidth = initialized.valueWidth
        
    }
    
    public var body: some View {
        
        let range: ClosedRange = minValue...maxValue
        
        if !range.contains($thumbValue.wrappedValue) {
            fatalError("thumbValue is not in range \(range)")
        }
       
        HStack(alignment: .center) {
            
            //set image to the left of the minimum value
            Image(systemName: minSFSymbolsString)
                .rotationEffect(isVertical ? .degrees(270) : .degrees(0))
                .offset(x: isVertical ? -limitValueOffset : -limitValueOffset)
            
            if !isHideLimitValue {
                
                //left limit value
                Text("\(Int(minValue))")                    .font(minValueFont)
                    .fontWeight(minValueFontWeight)
                    .foregroundColor(minValueColor)
                    .offset(x: isVertical ? 0 : -limitValueOffset, y: isVertical ? -limitValueOffset : 0)
                    .rotationEffect(isVertical ? .degrees(270) : .degrees(0))

                
            }
            
            ZStack(alignment: .leading) {
                
                //background bar. default color is gray.
                Capsule()
                    .frame(width: barWidth, height: barHeight)
                    .foregroundColor(sliderColor)
                    .onTapGesture { value in
                        
                        if value.x >= 0 && value.x <= barWidth {
                            
                            calculatePosition(x: value.x)
                                                
                        }
                    }
                    .animation(animation, value: thumbValue)
                
                //value bar. default color is blue.
                Capsule()
                    .frame(width: valueWidth, height: barHeight)
                    .foregroundColor(valueColor)
                    .offset(x: leftBarPosition)
                    .onTapGesture { value in
                        
                        calculatePosition(x: value.x)
                                                    
                    }
                    .animation(animation, value: thumbValue)
                
                
                //thumb value's type is Int and show thumb value and touching thumb
                if isIntValue && !isHideThumbValue && isTouchThumb {
                    
                    Text("\(Int(round(thumbValue)))")
                        .textParameter(font: thumbValueFont, weight: thumbValueFontWeight, color: thumbValueColor, position: thumbPosition, offset: -thumbValueOffset, isUnderValue: isUnderValue, isVertical: isVertical)
                    
                //thumb value's type is Double and show thumb value nad touching thumb
                } else if !isIntValue && !isHideThumbValue && isTouchThumb {
                
                    Text(String(format: "%.1f", thumbValue))
                        .textParameter(font: thumbValueFont, weight: thumbValueFontWeight, color: thumbValueColor, position: thumbPosition, offset: -thumbValueOffset, isUnderValue: isUnderValue, isVertical: isVertical)
                    
                //thumb value's type is Int and show thumb value and thouch bar
                } else if isIntValue && !isHideThumbValue && !isTouchThumb {
                    
                    Text("\(Int(round(thumbValue)))")
                        .textParameter(font: thumbValueFont, weight: thumbValueFontWeight, color: thumbValueColor, position: thumbPosition, offset: -thumbValueOffset, animation: animation, value: thumbValue, isUnderValue: isUnderValue, isVertical: isVertical)
                    
                //thumb's value's type is Double and show thumb value
                } else if !isIntValue && !isHideThumbValue && !isTouchThumb {
                    
                    Text(String(format: "%.1f", thumbValue))
                        .textParameter(font: thumbValueFont, weight: thumbValueFontWeight, color: thumbValueColor, position: thumbPosition, offset: -thumbValueOffset, animation: animation, value: thumbValue, isUnderValue: isUnderValue, isVertical: isVertical)
                    
                }
                
                //thumb
                Capsule()
                    .thumbParameter(diameter: thumbDiameter, color: thumbColor, position: thumbPosition)
                    .gesture(
                        
                        DragGesture()
                        
                            .onChanged { value in
                                
                                isTouchThumb = true
                                
                                calculatePosition(x: value.location.x)
                                                
                            }
                            .onEnded { _ in
                                
                                isTouchThumb = false
                                
                            }
                        
                    )
                
            }
            
            
            //right limit value
            if !isHideLimitValue {
                
                Text("\(Int(maxValue))")
                    .font(maxValueFont)
                    .fontWeight(maxValueFontWeight)
                    .foregroundColor(maxValueColor)
                    .offset(x: isVertical ? 0 : limitValueOffset, y: isVertical ? limitValueOffset : 0)
                    .rotationEffect(isVertical ? .degrees(270) : .degrees(0))

                
            }
            
            //set image to the right of the maximum value
            Image(systemName: maxSFSymbolsString)
            
                .rotationEffect(isVertical ? .degrees(270) : .degrees(0))
                .offset(x: isVertical ? limitValueOffset : limitValueOffset)
            
        }
        .rotationEffect(isVertical ? .degrees(90) : .degrees(0))
        
    }
    
}

public extension PlusMinusSlider {
    
    //initialize
    private init(thumbValue: Binding<Double>, barWidth: Double, barHeight: Double, isHideLimitValue: Bool, isHideThumbValue: Bool, isIntValue: Bool, isSmoothDrag: Bool, isUnderValue: Bool, isVertical: Bool, limitValueOffset: Double, maxSFSymbolsString: String, maxValue: Double, maxValueColor: Color, maxValueFont: Font, maxValueFontWeight: Font.Weight, minSFSymbolsString: String, minValue: Double, minValueColor: Color, minValueFont: Font, minValueFontWeight: Font.Weight, sliderColor: Color, thumbColor: Color, thumbDiameter: Double, thumbValueColor: Color, thumbValueFont: Font, thumbValueFontWeight: Font.Weight, thumbValueOffset: Double, valueColor: Color) {
        
        self.barWidth = barWidth
        self.barHeight = barHeight
        self.isHideLimitValue = isHideLimitValue
        self.isHideThumbValue = isHideThumbValue
        self.isIntValue = isIntValue
        self.isSmoothDrag = isSmoothDrag
        self.isUnderValue = isUnderValue
        self.isVertical = isVertical
        self.limitValueOffset = limitValueOffset
        self.maxSFSymbolsString = maxSFSymbolsString
        self.maxValue = maxValue
        self.maxValueColor = maxValueColor
        self.maxValueFont = maxValueFont
        self.maxValueFontWeight = maxValueFontWeight
        self.minSFSymbolsString = minSFSymbolsString
        self.minValue = minValue
        self.minValueColor = minValueColor
        self.minValueFont = minValueFont
        self.minValueFontWeight = minValueFontWeight
        self.sliderColor = sliderColor
        self.thumbColor = thumbColor
        self.thumbDiameter = thumbDiameter
        self.thumbValueColor = thumbValueColor
        self.thumbValueFont = thumbValueFont
        self.thumbValueFontWeight = thumbValueFontWeight
        self.thumbValueOffset = thumbValueOffset
        self.valueColor = valueColor
        
        self._thumbValue = thumbValue

        let initialized = initialOperation(max: maxValue, min: minValue, thumbValue: thumbValue)
        
        self._thumbPosition = initialized.thumbPosition
        self._zeroPosition = initialized.zeroPosition
        self._leftBarPosition = initialized.leftBarPosition
        self._valueWidth = initialized.valueWidth
        
    }
    
    func checkValueDiameter(_ diameter: Double) -> Double {
        
        if (self.barWidth <= diameter) {
            
            return self.barWidth
            
        } else {
            
            return diameter
            
        }
        
    }
    
    func checkThumbValueOffset(_ diameter: Double) -> Double {
        
        if(diameter <= 30) {
            
            return 30
            
        } else {
            
            return diameter * 3 / 4
            
        }
        
    }

    //set slider's bar width
    func barWidth(_ width: Double) -> Self {
        
        PlusMinusSlider(thumbValue: self._thumbValue, barWidth: width, barHeight: self.barHeight, isHideLimitValue: self.isHideLimitValue, isHideThumbValue: self.isHideThumbValue, isIntValue: self.isIntValue, isSmoothDrag: self.isSmoothDrag, isUnderValue: self.isUnderValue, isVertical: self.isVertical, limitValueOffset: self.limitValueOffset, maxSFSymbolsString: self.maxSFSymbolsString, maxValue: self.maxValue, maxValueColor: self.maxValueColor, maxValueFont: self.maxValueFont, maxValueFontWeight: self.maxValueFontWeight, minSFSymbolsString: minSFSymbolsString, minValue: self.minValue, minValueColor: self.minValueColor, minValueFont: self.minValueFont, minValueFontWeight: self.minValueFontWeight, sliderColor: self.sliderColor, thumbColor: self.thumbColor, thumbDiameter: self.thumbDiameter, thumbValueColor: self.thumbValueColor, thumbValueFont: self.thumbValueFont, thumbValueFontWeight: self.thumbValueFontWeight, thumbValueOffset: self.thumbValueOffset, valueColor: self.valueColor)

    }
    
    //set slider's bar height
    func barHeight(_ height: Double) -> Self {
        
        PlusMinusSlider(thumbValue: self._thumbValue, barWidth: self.barWidth, barHeight: height, isHideLimitValue: self.isHideLimitValue, isHideThumbValue: self.isHideThumbValue, isIntValue: self.isIntValue, isSmoothDrag: self.isSmoothDrag, isUnderValue: self.isUnderValue, isVertical: self.isVertical,  limitValueOffset: self.limitValueOffset, maxSFSymbolsString: self.maxSFSymbolsString, maxValue: self.maxValue, maxValueColor: self.maxValueColor, maxValueFont: self.maxValueFont, maxValueFontWeight: self.maxValueFontWeight, minSFSymbolsString: self.minSFSymbolsString, minValue: self.minValue, minValueColor: self.minValueColor, minValueFont: self.minValueFont, minValueFontWeight: self.minValueFontWeight, sliderColor: self.sliderColor, thumbColor: self.thumbColor, thumbDiameter: self.thumbDiameter, thumbValueColor: self.thumbValueColor, thumbValueFont: self.thumbValueFont, thumbValueFontWeight: self.thumbValueFontWeight, thumbValueOffset: self.thumbValueOffset, valueColor: self.valueColor)

    }
    
    //hide left and right values
    func isHideLimitValue(_ bool: Bool) -> Self {
        
        PlusMinusSlider(thumbValue: self._thumbValue, barWidth: self.barWidth, barHeight: self.barHeight, isHideLimitValue: bool, isHideThumbValue: self.isHideThumbValue, isIntValue: self.isIntValue, isSmoothDrag: self.isSmoothDrag, isUnderValue: self.isUnderValue, isVertical: self.isVertical, limitValueOffset: self.limitValueOffset, maxSFSymbolsString: self.maxSFSymbolsString, maxValue: self.maxValue, maxValueColor: self.maxValueColor, maxValueFont: self.maxValueFont, maxValueFontWeight: self.maxValueFontWeight, minSFSymbolsString: self.minSFSymbolsString, minValue: self.minValue, minValueColor: self.minValueColor, minValueFont: self.minValueFont, minValueFontWeight: self.minValueFontWeight, sliderColor: self.sliderColor, thumbColor: self.thumbColor, thumbDiameter: self.thumbDiameter, thumbValueColor: self.thumbValueColor, thumbValueFont: self.thumbValueFont, thumbValueFontWeight: self.thumbValueFontWeight, thumbValueOffset: self.thumbValueOffset, valueColor: self.valueColor)

    }
    
    //hide value on the thumb
    func isHideThumbValue(_ bool: Bool) -> Self {
        
        PlusMinusSlider(thumbValue: self._thumbValue, barWidth: self.barWidth, barHeight: self.barHeight, isHideLimitValue: self.isHideLimitValue, isHideThumbValue: bool, isIntValue: self.isIntValue, isSmoothDrag: self.isSmoothDrag, isUnderValue: self.isUnderValue, isVertical: self.isVertical, limitValueOffset: self.limitValueOffset, maxSFSymbolsString: self.maxSFSymbolsString, maxValue: self.maxValue, maxValueColor: self.maxValueColor, maxValueFont: self.maxValueFont, maxValueFontWeight: self.maxValueFontWeight, minSFSymbolsString: self.minSFSymbolsString, minValue: self.minValue, minValueColor: self.minValueColor, minValueFont: self.minValueFont, minValueFontWeight: self.minValueFontWeight, sliderColor: self.sliderColor, thumbColor: self.thumbColor, thumbDiameter: self.thumbDiameter, thumbValueColor: self.thumbValueColor, thumbValueFont: self.thumbValueFont, thumbValueFontWeight: self.thumbValueFontWeight, thumbValueOffset: self.thumbValueOffset, valueColor: self.valueColor)

    }
    
    //change Int value from Double value
    func isIntValue(_ bool: Bool) -> Self {
        
        PlusMinusSlider(thumbValue: self._thumbValue, barWidth: self.barWidth, barHeight: self.barHeight, isHideLimitValue: self.isHideLimitValue, isHideThumbValue: self.isHideThumbValue, isIntValue: bool, isSmoothDrag: !bool, isUnderValue: self.isUnderValue, isVertical: self.isVertical, limitValueOffset: self.limitValueOffset, maxSFSymbolsString: self.maxSFSymbolsString, maxValue: self.maxValue, maxValueColor: self.maxValueColor, maxValueFont: self.maxValueFont, maxValueFontWeight: self.maxValueFontWeight, minSFSymbolsString: self.minSFSymbolsString, minValue: self.minValue, minValueColor: self.minValueColor, minValueFont: self.minValueFont, minValueFontWeight: self.minValueFontWeight, sliderColor: self.sliderColor, thumbColor: self.thumbColor, thumbDiameter: self.thumbDiameter, thumbValueColor: self.thumbValueColor, thumbValueFont: self.thumbValueFont, thumbValueFontWeight: self.thumbValueFontWeight, thumbValueOffset: self.thumbValueOffset, valueColor: self.valueColor)

    }

    //change Int value from Double value
    func isUnderValue(_ bool: Bool) -> Self {
        
        PlusMinusSlider(thumbValue: self._thumbValue, barWidth: self.barWidth, barHeight: self.barHeight, isHideLimitValue: self.isHideLimitValue, isHideThumbValue: self.isHideThumbValue, isIntValue: self.isIntValue, isSmoothDrag: self.isSmoothDrag, isUnderValue: bool, isVertical: self.isVertical, limitValueOffset: self.limitValueOffset, maxSFSymbolsString: self.maxSFSymbolsString, maxValue: self.maxValue, maxValueColor: self.maxValueColor, maxValueFont: self.maxValueFont, maxValueFontWeight: self.maxValueFontWeight, minSFSymbolsString: self.minSFSymbolsString, minValue: self.minValue, minValueColor: self.minValueColor, minValueFont: self.minValueFont, minValueFontWeight: self.minValueFontWeight, sliderColor: self.sliderColor, thumbColor: self.thumbColor, thumbDiameter: self.thumbDiameter, thumbValueColor: self.thumbValueColor, thumbValueFont: self.thumbValueFont, thumbValueFontWeight: self.thumbValueFontWeight, thumbValueOffset: self.thumbValueOffset, valueColor: self.valueColor)

    }
    
    //change vertical or horizontal
    func isVertical(_ bool: Bool) -> Self {
        
        PlusMinusSlider(thumbValue: self._thumbValue, barWidth: self.barWidth, barHeight: self.barHeight, isHideLimitValue: self.isHideLimitValue, isHideThumbValue: self.isHideThumbValue, isIntValue: self.isIntValue, isSmoothDrag: self.isSmoothDrag, isUnderValue: self.isUnderValue, isVertical: bool,  limitValueOffset: self.limitValueOffset, maxSFSymbolsString: self.maxSFSymbolsString, maxValue: self.maxValue, maxValueColor: self.maxValueColor, maxValueFont: self.maxValueFont, maxValueFontWeight: self.maxValueFontWeight, minSFSymbolsString: self.minSFSymbolsString, minValue: self.minValue, minValueColor: self.minValueColor, minValueFont: self.minValueFont, minValueFontWeight: self.minValueFontWeight, sliderColor: self.sliderColor, thumbColor: self.thumbColor, thumbDiameter: self.thumbDiameter, thumbValueColor: self.thumbValueColor, thumbValueFont: self.thumbValueFont, thumbValueFontWeight: self.thumbValueFontWeight, thumbValueOffset: self.thumbValueOffset, valueColor: self.valueColor)

    }
    
    //bar of slider and limit values offset
    func limitValueOffset(_ offset: CGFloat) -> Self {
        
        PlusMinusSlider(thumbValue: self._thumbValue, barWidth: self.barWidth, barHeight: self.barHeight, isHideLimitValue: self.isHideLimitValue, isHideThumbValue: self.isHideThumbValue, isIntValue: self.isIntValue, isSmoothDrag: self.isSmoothDrag, isUnderValue: self.isUnderValue, isVertical: self.isVertical, limitValueOffset: offset, maxSFSymbolsString: self.maxSFSymbolsString, maxValue: self.maxValue, maxValueColor: self.maxValueColor, maxValueFont: self.maxValueFont, maxValueFontWeight: self.maxValueFontWeight, minSFSymbolsString: self.minSFSymbolsString, minValue: self.minValue, minValueColor: self.minValueColor, minValueFont: self.minValueFont, minValueFontWeight: self.minValueFontWeight, sliderColor: self.sliderColor, thumbColor: self.thumbColor, thumbDiameter: self.thumbDiameter, thumbValueColor: self.thumbValueColor, thumbValueFont: self.thumbValueFont, thumbValueFontWeight: self.thumbValueFontWeight, thumbValueOffset: self.thumbValueOffset, valueColor:  self.valueColor)
        
    }
    
    //set right image. it's only SF Symbols' image.
    func maxSFSymbolsString(_ string: String) -> Self {
        
        PlusMinusSlider(thumbValue: self._thumbValue, barWidth: self.barWidth, barHeight: self.barHeight, isHideLimitValue: self.isHideLimitValue, isHideThumbValue: self.isHideThumbValue, isIntValue: self.isIntValue, isSmoothDrag: self.isSmoothDrag, isUnderValue: self.isUnderValue, isVertical: self.isVertical, limitValueOffset: self.limitValueOffset, maxSFSymbolsString: string, maxValue: self.maxValue, maxValueColor: self.maxValueColor, maxValueFont: self.maxValueFont, maxValueFontWeight: self.maxValueFontWeight, minSFSymbolsString: self.minSFSymbolsString, minValue: self.minValue, minValueColor: self.minValueColor, minValueFont: self.minValueFont, minValueFontWeight: self.minValueFontWeight, sliderColor: self.sliderColor, thumbColor: self.thumbColor, thumbDiameter: self.thumbDiameter, thumbValueColor: self.thumbValueColor, thumbValueFont: self.thumbValueFont, thumbValueFontWeight: self.thumbValueFontWeight, thumbValueOffset: self.thumbValueOffset, valueColor: self.valueColor)

    }
    
    //set maximum value
    func maxValue(_ value: Double) -> Self {
        
        PlusMinusSlider(thumbValue: self._thumbValue, barWidth: self.barWidth, barHeight: self.barHeight, isHideLimitValue: self.isHideLimitValue, isHideThumbValue: self.isHideThumbValue, isIntValue: self.isIntValue, isSmoothDrag: self.isSmoothDrag, isUnderValue: self.isUnderValue, isVertical: self.isVertical, limitValueOffset: self.limitValueOffset, maxSFSymbolsString: self.maxSFSymbolsString, maxValue: value, maxValueColor: self.maxValueColor, maxValueFont: self.maxValueFont, maxValueFontWeight: self.maxValueFontWeight, minSFSymbolsString: self.minSFSymbolsString, minValue: self.minValue, minValueColor: self.minValueColor, minValueFont: self.minValueFont, minValueFontWeight: self.minValueFontWeight, sliderColor: self.sliderColor, thumbColor: self.thumbColor, thumbDiameter: self.thumbDiameter, thumbValueColor: self.thumbValueColor, thumbValueFont: self.thumbValueFont, thumbValueFontWeight: self.thumbValueFontWeight, thumbValueOffset: self.thumbValueOffset, valueColor: self.valueColor)

    }
    
    //set maximum value's color
    func maxValueColor(_ color: Color) -> Self {
        
        PlusMinusSlider(thumbValue: self._thumbValue, barWidth: self.barWidth, barHeight: self.barHeight, isHideLimitValue: self.isHideLimitValue, isHideThumbValue: self.isHideThumbValue, isIntValue: self.isIntValue, isSmoothDrag: self.isSmoothDrag, isUnderValue: self.isUnderValue, isVertical: self.isVertical, limitValueOffset: self.limitValueOffset, maxSFSymbolsString: self.maxSFSymbolsString, maxValue: self.maxValue, maxValueColor: color, maxValueFont: self.maxValueFont, maxValueFontWeight: self.maxValueFontWeight, minSFSymbolsString: self.minSFSymbolsString, minValue: self.minValue, minValueColor: self.minValueColor, minValueFont: self.minValueFont, minValueFontWeight: self.minValueFontWeight, sliderColor: self.sliderColor, thumbColor: self.thumbColor, thumbDiameter: self.thumbDiameter, thumbValueColor: self.thumbValueColor, thumbValueFont: self.thumbValueFont, thumbValueFontWeight: self.thumbValueFontWeight, thumbValueOffset: self.thumbValueOffset, valueColor: self.valueColor)

    }
    
    //set maximum value's font
    func maxValueFont(_ font: Font) -> Self {
        
        PlusMinusSlider(thumbValue: self._thumbValue, barWidth: self.barWidth, barHeight: self.barHeight, isHideLimitValue: self.isHideLimitValue, isHideThumbValue: self.isHideThumbValue, isIntValue: self.isIntValue, isSmoothDrag: self.isSmoothDrag, isUnderValue: self.isUnderValue, isVertical: self.isVertical, limitValueOffset: self.limitValueOffset, maxSFSymbolsString: self.maxSFSymbolsString, maxValue: self.maxValue, maxValueColor: self.maxValueColor, maxValueFont: font, maxValueFontWeight: self.maxValueFontWeight, minSFSymbolsString: self.minSFSymbolsString, minValue: self.minValue, minValueColor: self.minValueColor, minValueFont: self.minValueFont, minValueFontWeight: self.minValueFontWeight, sliderColor: self.sliderColor, thumbColor: self.thumbColor, thumbDiameter: self.thumbDiameter, thumbValueColor: self.thumbValueColor, thumbValueFont: self.thumbValueFont, thumbValueFontWeight: self.thumbValueFontWeight, thumbValueOffset: self.thumbValueOffset, valueColor: self.valueColor)
        
    }
    
    //set maximum value's font weight
    func maxValueFontWeight(_ weight: Font.Weight) -> Self {
        
        PlusMinusSlider(thumbValue: self._thumbValue, barWidth: self.barWidth, barHeight: self.barHeight, isHideLimitValue: self.isHideLimitValue, isHideThumbValue: self.isHideThumbValue, isIntValue: self.isIntValue, isSmoothDrag: self.isSmoothDrag, isUnderValue: self.isUnderValue, isVertical: self.isVertical, limitValueOffset: self.limitValueOffset, maxSFSymbolsString: self.maxSFSymbolsString, maxValue: self.maxValue, maxValueColor: self.maxValueColor, maxValueFont: self.maxValueFont, maxValueFontWeight: weight, minSFSymbolsString: self.minSFSymbolsString, minValue: self.minValue, minValueColor: self.minValueColor, minValueFont: self.minValueFont, minValueFontWeight: self.minValueFontWeight, sliderColor: self.sliderColor, thumbColor: self.thumbColor, thumbDiameter: self.thumbDiameter, thumbValueColor: self.thumbValueColor, thumbValueFont: self.thumbValueFont, thumbValueFontWeight: self.thumbValueFontWeight, thumbValueOffset: self.thumbValueOffset, valueColor: self.valueColor)

    }
    
    //set maximum value
    func minSFSymbolsString(_ string: String) -> Self {
        
        PlusMinusSlider(thumbValue: self._thumbValue, barWidth: self.barWidth, barHeight: self.barHeight, isHideLimitValue: self.isHideLimitValue, isHideThumbValue: self.isHideThumbValue, isIntValue: self.isIntValue, isSmoothDrag: self.isSmoothDrag, isUnderValue: self.isUnderValue, isVertical: self.isVertical, limitValueOffset: self.limitValueOffset, maxSFSymbolsString: self.maxSFSymbolsString, maxValue: self.maxValue, maxValueColor: self.maxValueColor, maxValueFont: self.maxValueFont, maxValueFontWeight: self.maxValueFontWeight, minSFSymbolsString: string, minValue: self.minValue, minValueColor: self.minValueColor, minValueFont: self.minValueFont, minValueFontWeight: self.minValueFontWeight, sliderColor: self.sliderColor, thumbColor: self.thumbColor, thumbDiameter: self.thumbDiameter, thumbValueColor: self.thumbValueColor, thumbValueFont: self.thumbValueFont, thumbValueFontWeight: self.thumbValueFontWeight, thumbValueOffset: self.thumbValueOffset, valueColor: self.valueColor)

    }
    
    //set minimum value
    func minValue(_ value: Double) -> Self {
        
        PlusMinusSlider(thumbValue: self._thumbValue, barWidth: self.barWidth, barHeight: self.barHeight, isHideLimitValue: self.isHideLimitValue, isHideThumbValue: self.isHideThumbValue, isIntValue: self.isIntValue, isSmoothDrag: self.isSmoothDrag, isUnderValue: self.isUnderValue, isVertical: self.isVertical, limitValueOffset: self.limitValueOffset, maxSFSymbolsString: self.maxSFSymbolsString, maxValue: self.maxValue, maxValueColor: self.maxValueColor, maxValueFont: self.maxValueFont, maxValueFontWeight: self.maxValueFontWeight, minSFSymbolsString: self.minSFSymbolsString, minValue: value, minValueColor: self.minValueColor, minValueFont: self.minValueFont, minValueFontWeight: self.minValueFontWeight, sliderColor: self.sliderColor, thumbColor: self.thumbColor, thumbDiameter: self.thumbDiameter, thumbValueColor: self.thumbValueColor, thumbValueFont: self.thumbValueFont, thumbValueFontWeight: self.thumbValueFontWeight, thumbValueOffset: self.thumbValueOffset, valueColor: self.valueColor)

    }
    
    //set minimum value's color
    func minValueColor(_ color: Color) -> Self {
        
        PlusMinusSlider(thumbValue: self._thumbValue, barWidth: self.barWidth, barHeight: self.barHeight, isHideLimitValue: self.isHideLimitValue, isHideThumbValue: self.isHideThumbValue, isIntValue: self.isIntValue, isSmoothDrag: self.isSmoothDrag, isUnderValue: self.isUnderValue, isVertical: self.isVertical, limitValueOffset: self.limitValueOffset, maxSFSymbolsString: self.maxSFSymbolsString, maxValue: self.maxValue, maxValueColor: self.maxValueColor, maxValueFont: self.maxValueFont, maxValueFontWeight: self.maxValueFontWeight, minSFSymbolsString: self.minSFSymbolsString, minValue: self.minValue, minValueColor: color, minValueFont: self.minValueFont, minValueFontWeight: self.minValueFontWeight, sliderColor: self.sliderColor, thumbColor: self.thumbColor, thumbDiameter: self.thumbDiameter, thumbValueColor: self.thumbValueColor, thumbValueFont: self.thumbValueFont, thumbValueFontWeight: self.thumbValueFontWeight, thumbValueOffset: self.thumbValueOffset, valueColor: self.valueColor)
        
    }
    
    //set minimum value's font
    func minValueFont(_ font: Font) -> Self {
        
        PlusMinusSlider(thumbValue: self._thumbValue, barWidth: self.barWidth, barHeight: self.barHeight, isHideLimitValue: self.isHideLimitValue, isHideThumbValue: self.isHideThumbValue, isIntValue: self.isIntValue, isSmoothDrag: self.isSmoothDrag, isUnderValue: self.isUnderValue, isVertical: self.isVertical, limitValueOffset: self.limitValueOffset, maxSFSymbolsString: self.maxSFSymbolsString, maxValue: self.maxValue, maxValueColor: self.maxValueColor, maxValueFont: self.maxValueFont, maxValueFontWeight: self.maxValueFontWeight, minSFSymbolsString: self.minSFSymbolsString, minValue: self.minValue, minValueColor: self.minValueColor, minValueFont: font, minValueFontWeight: self.minValueFontWeight, sliderColor: self.sliderColor, thumbColor: self.thumbColor, thumbDiameter: self.thumbDiameter, thumbValueColor: self.thumbValueColor, thumbValueFont: self.thumbValueFont, thumbValueFontWeight: self.thumbValueFontWeight, thumbValueOffset: self.thumbValueOffset, valueColor: self.valueColor)
        
    }
    
    //set minimu value's font weight
    func minValueFontWeight(_ weight: Font.Weight) -> Self {
        
        PlusMinusSlider(thumbValue: self._thumbValue, barWidth: self.barWidth, barHeight: self.barHeight, isHideLimitValue: self.isHideLimitValue, isHideThumbValue: self.isHideThumbValue, isIntValue: self.isIntValue, isSmoothDrag: self.isSmoothDrag, isUnderValue: self.isUnderValue, isVertical: self.isVertical, limitValueOffset: self.limitValueOffset, maxSFSymbolsString: self.maxSFSymbolsString, maxValue: self.maxValue, maxValueColor: self.maxValueColor, maxValueFont: self.maxValueFont, maxValueFontWeight: self.maxValueFontWeight, minSFSymbolsString: self.minSFSymbolsString, minValue: self.minValue, minValueColor: self.minValueColor, minValueFont: self.minValueFont, minValueFontWeight: weight, sliderColor: self.sliderColor, thumbColor: self.thumbColor, thumbDiameter: self.thumbDiameter, thumbValueColor: self.thumbValueColor, thumbValueFont: self.thumbValueFont, thumbValueFontWeight: self.thumbValueFontWeight, thumbValueOffset: self.thumbValueOffset, valueColor: self.valueColor)

    }

    //set slider's color. it is background color. not value color.
    func sliderColor(_ color: Color) -> Self {
        
        PlusMinusSlider(thumbValue: self._thumbValue, barWidth: self.barWidth, barHeight: self.barHeight, isHideLimitValue: self.isHideLimitValue, isHideThumbValue: self.isHideThumbValue, isIntValue: self.isIntValue, isSmoothDrag: self.isSmoothDrag, isUnderValue: self.isUnderValue, isVertical: self.isVertical, limitValueOffset: self.limitValueOffset, maxSFSymbolsString: self.maxSFSymbolsString, maxValue: self.maxValue, maxValueColor: self.maxValueColor, maxValueFont: self.maxValueFont, maxValueFontWeight: self.maxValueFontWeight, minSFSymbolsString: self.minSFSymbolsString, minValue: self.minValue, minValueColor: self.minValueColor, minValueFont: self.minValueFont, minValueFontWeight: self.minValueFontWeight, sliderColor: color, thumbColor: self.thumbColor, thumbDiameter: self.thumbDiameter, thumbValueColor: self.thumbValueColor, thumbValueFont: self.thumbValueFont, thumbValueFontWeight: self.thumbValueFontWeight, thumbValueOffset: self.thumbValueOffset, valueColor:  self.valueColor)
        
    }
    
    //set thumb's color
    func thumbColor(_ color: Color) -> Self {
        
        PlusMinusSlider(thumbValue: self._thumbValue, barWidth: self.barWidth, barHeight: self.barHeight, isHideLimitValue: self.isHideLimitValue, isHideThumbValue: self.isHideThumbValue, isIntValue: self.isIntValue, isSmoothDrag: self.isSmoothDrag, isUnderValue: self.isUnderValue, isVertical: self.isVertical, limitValueOffset: self.limitValueOffset, maxSFSymbolsString: self.maxSFSymbolsString, maxValue: self.maxValue, maxValueColor: self.maxValueColor, maxValueFont: self.maxValueFont, maxValueFontWeight: self.maxValueFontWeight, minSFSymbolsString: self.minSFSymbolsString, minValue: self.minValue, minValueColor: self.minValueColor, minValueFont: self.minValueFont, minValueFontWeight: minValueFontWeight, sliderColor: self.sliderColor, thumbColor: color, thumbDiameter: self.thumbDiameter, thumbValueColor: self.thumbValueColor, thumbValueFont: self.thumbValueFont, thumbValueFontWeight: self.thumbValueFontWeight, thumbValueOffset: self.thumbValueOffset, valueColor: self.valueColor)
        
    }
    
    //set thumb's diameter
    func thumbDiameter(_ diameter: CGFloat) -> Self {
        
        let checkedDiameter = checkValueDiameter(diameter)
        let checkedThumbValueOffset =  checkThumbValueOffset(diameter)
        
        return PlusMinusSlider(thumbValue: self._thumbValue, barWidth: self.barWidth, barHeight: self.barHeight, isHideLimitValue: self.isHideLimitValue, isHideThumbValue: self.isHideThumbValue, isIntValue: self.isIntValue, isSmoothDrag: self.isSmoothDrag, isUnderValue: self.isUnderValue, isVertical: self.isVertical, limitValueOffset: self.limitValueOffset, maxSFSymbolsString: self.maxSFSymbolsString, maxValue: self.maxValue, maxValueColor: self.maxValueColor, maxValueFont: self.maxValueFont, maxValueFontWeight: self.maxValueFontWeight, minSFSymbolsString: self.minSFSymbolsString, minValue: self.minValue, minValueColor: self.minValueColor, minValueFont: self.minValueFont, minValueFontWeight: minValueFontWeight, sliderColor: self.sliderColor, thumbColor: self.thumbColor, thumbDiameter: checkedDiameter, thumbValueColor: self.thumbValueColor, thumbValueFont: self.thumbValueFont, thumbValueFontWeight: self.thumbValueFontWeight, thumbValueOffset: checkedThumbValueOffset, valueColor: self.valueColor)
        
    }
    
    //set thumb's value color.
    func thumbValueColor(_ color: Color) -> Self {
        
        PlusMinusSlider(thumbValue: self._thumbValue, barWidth: self.barWidth, barHeight: self.barHeight, isHideLimitValue: self.isHideLimitValue, isHideThumbValue: self.isHideThumbValue, isIntValue: self.isIntValue, isSmoothDrag: self.isSmoothDrag, isUnderValue: self.isUnderValue, isVertical: self.isVertical, limitValueOffset: self.limitValueOffset, maxSFSymbolsString: self.maxSFSymbolsString, maxValue: self.maxValue, maxValueColor: self.maxValueColor, maxValueFont: self.maxValueFont, maxValueFontWeight: self.maxValueFontWeight, minSFSymbolsString: self.minSFSymbolsString, minValue: self.minValue, minValueColor: self.minValueColor, minValueFont: self.minValueFont, minValueFontWeight: self.minValueFontWeight, sliderColor: self.sliderColor, thumbColor: self.thumbColor, thumbDiameter: self.thumbDiameter, thumbValueColor: color, thumbValueFont: self.thumbValueFont, thumbValueFontWeight: self.thumbValueFontWeight, thumbValueOffset: self.thumbValueOffset, valueColor: self.valueColor)
        
    }
    
    //set thumb's value font
    func thumbValueFont(_ font: Font) -> Self {
        
        PlusMinusSlider(thumbValue: self._thumbValue, barWidth: self.barWidth, barHeight: self.barHeight, isHideLimitValue: self.isHideLimitValue, isHideThumbValue: self.isHideThumbValue, isIntValue: self.isIntValue, isSmoothDrag: self.isSmoothDrag, isUnderValue: self.isUnderValue, isVertical: self.isVertical, limitValueOffset: self.limitValueOffset, maxSFSymbolsString: self.maxSFSymbolsString, maxValue: self.maxValue, maxValueColor: self.maxValueColor, maxValueFont: self.maxValueFont, maxValueFontWeight: self.maxValueFontWeight, minSFSymbolsString: self.minSFSymbolsString, minValue: self.minValue, minValueColor: self.minValueColor, minValueFont: self.minValueFont, minValueFontWeight: self.minValueFontWeight, sliderColor: self.sliderColor, thumbColor: self.thumbColor, thumbDiameter: self.thumbDiameter, thumbValueColor: self.thumbValueColor, thumbValueFont: font, thumbValueFontWeight: self.thumbValueFontWeight, thumbValueOffset: self.thumbValueOffset, valueColor: self.valueColor)
        
    }
    
    //set thumb's value font weight
    func thumbValueFontWeight(_ weight: Font.Weight) -> Self {
        
        PlusMinusSlider(thumbValue: self._thumbValue, barWidth: self.barWidth, barHeight: self.barHeight, isHideLimitValue: self.isHideLimitValue, isHideThumbValue: self.isHideThumbValue, isIntValue: self.isIntValue, isSmoothDrag: self.isSmoothDrag, isUnderValue: self.isUnderValue, isVertical: self.isVertical, limitValueOffset: self.limitValueOffset, maxSFSymbolsString: self.maxSFSymbolsString, maxValue: self.maxValue, maxValueColor: self.maxValueColor, maxValueFont: self.maxValueFont, maxValueFontWeight: self.maxValueFontWeight, minSFSymbolsString: self.minSFSymbolsString, minValue: self.minValue, minValueColor: self.minValueColor, minValueFont: self.minValueFont, minValueFontWeight: self.minValueFontWeight, sliderColor: self.sliderColor, thumbColor: self.thumbColor, thumbDiameter: self.thumbDiameter, thumbValueColor: self.thumbValueColor, thumbValueFont: self.thumbValueFont, thumbValueFontWeight: weight, thumbValueOffset: self.thumbValueOffset, valueColor: self.valueColor)

    }
    
    //set thumb's value font weight
    func thumbValueOffset(_ offset: CGFloat) -> Self {
        
        PlusMinusSlider(thumbValue: self._thumbValue, barWidth: self.barWidth, barHeight: self.barHeight, isHideLimitValue: self.isHideLimitValue, isHideThumbValue: self.isHideThumbValue, isIntValue: self.isIntValue, isSmoothDrag: self.isSmoothDrag, isUnderValue: self.isUnderValue, isVertical: self.isVertical, limitValueOffset: self.limitValueOffset, maxSFSymbolsString: self.maxSFSymbolsString, maxValue: self.maxValue, maxValueColor: self.maxValueColor, maxValueFont: self.maxValueFont, maxValueFontWeight: self.maxValueFontWeight, minSFSymbolsString: self.minSFSymbolsString, minValue: self.minValue, minValueColor: self.minValueColor, minValueFont: self.minValueFont, minValueFontWeight: self.minValueFontWeight, sliderColor: self.sliderColor, thumbColor: self.thumbColor, thumbDiameter: self.thumbDiameter, thumbValueColor: self.thumbValueColor, thumbValueFont: self.thumbValueFont, thumbValueFontWeight: self.thumbValueFontWeight, thumbValueOffset: offset, valueColor: self.valueColor)

    }
    
    //set value color. default color is blue. it is value.
    func valueColor(_ color: Color) -> Self {
        
        PlusMinusSlider(thumbValue: self._thumbValue, barWidth: self.barWidth, barHeight: self.barHeight, isHideLimitValue: self.isHideLimitValue, isHideThumbValue: self.isHideThumbValue, isIntValue: self.isIntValue, isSmoothDrag: self.isSmoothDrag, isUnderValue: self.isUnderValue, isVertical: self.isVertical, limitValueOffset: self.limitValueOffset, maxSFSymbolsString: self.maxSFSymbolsString, maxValue: self.maxValue, maxValueColor: self.maxValueColor, maxValueFont: self.maxValueFont, maxValueFontWeight: self.maxValueFontWeight, minSFSymbolsString: self.minSFSymbolsString, minValue: self.minValue, minValueColor: self.minValueColor, minValueFont: self.minValueFont, minValueFontWeight: self.minValueFontWeight, sliderColor: self.sliderColor, thumbColor: self.thumbColor, thumbDiameter: self.thumbDiameter, thumbValueColor: self.thumbValueColor, thumbValueFont: self.thumbValueFont, thumbValueFontWeight: self.thumbValueFontWeight, thumbValueOffset: self.thumbValueOffset, valueColor: color)
        
    }
    
    private func initialOperation(max: Double, min: Double, thumbValue: Binding<Double>) -> (thumbPosition: State<Double>, zeroPosition: State<Double>, leftBarPosition: State<Double>, valueWidth: State<Double>) {
        
        let thumbPosition: State<Double>
        let zeroPosition: State<Double>
        let leftBarPosition: State<Double>
        let valueWidth: State<Double>

        thumbPosition = State(initialValue: Double(barWidth / (max - min) * (thumbValue.wrappedValue - min)))
        
        if min <= 0 && max >= 0 && thumbValue.wrappedValue <= 0 {

            zeroPosition = State(initialValue: Double(barWidth / (max - min) * -min))
            leftBarPosition = State(initialValue: Double(barWidth / (max - min) * (thumbValue.wrappedValue - min)))
            valueWidth = State(initialValue: Double(fabs(barWidth / (max - min) * thumbValue.wrappedValue)))
            
        } else if min <= 0 && max <= 0 && thumbValue.wrappedValue <= 0 {
            
            zeroPosition = State(initialValue: Double(barWidth))
            leftBarPosition = State(initialValue: Double(barWidth / (max - min) * (thumbValue.wrappedValue - min)))
            valueWidth = State(initialValue: Double(fabs(barWidth / (max - min) * (thumbValue.wrappedValue - max))))
            
        } else if min <= 0 && max >= 0 && thumbValue.wrappedValue >= 0  {

            zeroPosition = State(initialValue: Double(barWidth / (max - min) * -min))
            leftBarPosition = State(initialValue: Double(barWidth / (max - min) * -min))
            valueWidth = State(initialValue: Double(fabs(barWidth / (max - min) * thumbValue.wrappedValue)))

        } else if min >= 0 && max >= 0 && thumbValue.wrappedValue >= 0 {

            zeroPosition = State(initialValue: Double(0))
            leftBarPosition = State(initialValue: Double(0))
            valueWidth = State(initialValue: Double(barWidth / (max - min) * (thumbValue.wrappedValue - min)))

        } else {
            
            zeroPosition = State(initialValue: Double(0))
            leftBarPosition = State(initialValue: Double(0))
            valueWidth = State(initialValue: Double(0))

        }
        
        return (thumbPosition: thumbPosition, zeroPosition: zeroPosition, leftBarPosition: leftBarPosition, valueWidth: valueWidth)
        
    }
    
    func calculatePosition(x: CGFloat) {
        
        if x > 0 && x < barWidth {
            
            if isSmoothDrag {
                
                //calculate thumb's center position.
                thumbPosition = Double(x)

                //calculate thumb's value.
                thumbValue = Double(thumbPosition / barWidth) * (maxValue - minValue) + minValue
                
            } else {
                
                thumbPosition = round(Double(x / barWidth * (maxValue - minValue))) * barWidth / (maxValue - minValue)
                
                thumbValue = round((Double(thumbPosition / barWidth)) * (maxValue - minValue)) + minValue
                
            }
            
            //width represents the width of the blue capsule. allow for negative.
            let width = thumbPosition - zeroPosition
            
            if width >= 0 {
                
                //blue capsule's width
                valueWidth = width
                //leftBarPosition is center
                leftBarPosition = zeroPosition
                
            } else {
                
                //width is minus value. at first make it absolute. and decide bar's left position.
                valueWidth = fabs(width)
                leftBarPosition = barWidth / (maxValue - minValue) * (thumbValue - minValue)

            }
            
        } else if x <= 0 {
            
            //thumb over minValue, thumbValue is always minValue.
            thumbValue = minValue
            
        } else if x >= barWidth {
            
            //thumb over maxValue, thumbValue is always maxValue.
            thumbValue = maxValue
            
        }
        
    }
    
}

extension View {
    
    func textParameter(font: Font, weight: Font.Weight, color: Color, position: Double, offset: Double, animation: Animation, value: Double, isUnderValue: Bool, isVertical: Bool) -> some View {
        
        self
            .rotationEffect(isVertical ? .degrees(-90) : .degrees(0))
            .fixedSize(horizontal: true, vertical: false)
            .font(font)
            .fontWeight(weight)
            .foregroundColor(color)
            .frame(width: 0, height: 0, alignment: .center)
            .offset(x: position, y: isUnderValue ? -offset : offset)
            .animation(animation, value: value)

    }
    
    func textParameter(font: Font, weight: Font.Weight, color: Color, position: Double, offset: Double, isUnderValue: Bool, isVertical: Bool) -> some View {
        
        self
            .rotationEffect(isVertical ? .degrees(-90) : .degrees(0))
            .fixedSize(horizontal: true, vertical: false)
            .font(font)
            .fontWeight(weight)
            .foregroundColor(color)
            .frame(width: 0, height: 0, alignment: .center)
            .offset(x: position, y: isUnderValue ? -offset : offset)

    }
    
    func thumbParameter(diameter:Double, color: Color, position: Double) -> some View {
        
        self
            .frame(width: diameter, height: diameter)
            .foregroundColor(color)
            .offset(x: -diameter / 2 + position)
        
    }
    
}
