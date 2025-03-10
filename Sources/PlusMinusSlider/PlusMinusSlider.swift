import SwiftUI

public struct PlusMinusSlider: View {
    
    @State var thumbPosition: Double = 0
    @State var leftBarPosition: Double = 0
    @State var zeroPosition: Double = 0
    
    @State var valueWidth: Double = 0
    
    @Binding var thumbValue: Double
    
    private let barWidth: CGFloat
    private let barHeight: CGFloat
    private let isHideLimitValue: Bool
    private let isHideThumbValue: Bool
    private let isIntThumb: Bool
    private let isSmoothDrag: Bool
    private let limitValueOffset: CGFloat
    private let maxValue: Double
    private let maxValueColor: Color
    private let maxValueFont: Font
    private let maxValueFontWeight: Font.Weight
    private let minValue: Double
    private let minValueColor: Color
    private let minValueFont: Font
    private let minValueFontWeight: Font.Weight
    private let sliderColor: Color
    private let thumbColor: Color
    private let thumbDiameter: CGFloat
    private let thumbValueColor: Color
    private let thumbValueFont: Font
    private let thumbValueFontWeight: Font.Weight
    private let thumbValueOffset: CGFloat
    private let valueColor: Color
    
    public init(barWidth: Double = UIScreen.main.bounds.width * 0.65, maxValue: Double = 5, minValue: Double = -5, thumbValue: Binding<Double>) {
        
        self.barWidth = barWidth
        self.barHeight = 10
        self.isHideLimitValue = false
        self.isHideThumbValue = false
        self.isIntThumb = false
        self.isSmoothDrag = false
        self.limitValueOffset = 10
        self.maxValue = maxValue
        self.maxValueColor = Color.primary
        self.maxValueFont = .body
        self.maxValueFontWeight = .regular
        self.minValue = minValue
        self.minValueColor = Color.primary
        self.minValueFont = .body
        self.minValueFontWeight = .regular
        self.sliderColor = Color(.systemGray5)
        self.thumbColor = Color(.systemGray)
        self.thumbDiameter = 30
        self.thumbValueColor = Color.primary
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
        
        VStack {
            
            HStack {
                
                if !isHideLimitValue {
                    
                    //left limit value
                    Text("\(Int(minValue))")
                        .font(minValueFont)
                        .fontWeight(minValueFontWeight)
                        .foregroundColor(minValueColor)
                        .offset(x: limitValueOffset * -1)
                    
                }
                
                ZStack(alignment: .leading) {
                    
                    //background bar. default color is gray.
                    Capsule()
                        .frame(width: barWidth, height: barHeight)
                        .foregroundColor(sliderColor)
                    
                    //value bar. default color is blue.
                    Capsule()
                        .frame(width: valueWidth, height: barHeight)
                        .foregroundColor(valueColor)
                        .offset(x: leftBarPosition)
                    
                    //thumb value's type is Int and show thumb value
                    if isIntThumb && !isHideThumbValue {
                        
                        Text("\(Int(thumbValue))")
                            .fixedSize(horizontal: true, vertical: false)
                            .font(thumbValueFont)
                            .fontWeight(thumbValueFontWeight)
                            .foregroundColor(thumbValueColor)
                            .frame(width: 0, height: 0, alignment: .center)
                            .offset(x: thumbPosition, y: -thumbValueOffset)
                      
                    //thumb's value's type is Double and show thumb value
                    } else if !isIntThumb && !isHideThumbValue {
                        
                        Text("\(Double(thumbValue))")
                            .fixedSize(horizontal: true, vertical: false)
                            .font(thumbValueFont)
                            .fontWeight(thumbValueFontWeight)
                            .foregroundColor(thumbValueColor)
                            .frame(width: 0, height: 0, alignment: .center)
                            .offset(x: thumbPosition, y: -thumbValueOffset)
                        
                    }
                    
                    //thumb
                    Capsule()
                        .frame(width: thumbDiameter, height: thumbDiameter)
                        .foregroundColor(thumbColor)
                        .offset(x: -thumbDiameter / 2 + thumbPosition)
                        .gesture(
                            
                            DragGesture()
                            
                                .onChanged { value in
                                    
                                    if value.location.x > 0 && value.location.x < barWidth {
                                        
                                        let sliderValue: Double
                                        
                                        if isSmoothDrag {
                                            
                                            //calculate thumb's center position.
                                            thumbPosition = Double(value.location.x)

                                            //calculate thumb's value.
                                            thumbValue = Double(thumbPosition / barWidth) * (maxValue - minValue) + minValue
                                            
                                        } else {
                                            
                                            self.thumbPosition = round(Double(value.location.x / barWidth * (maxValue - minValue))) * barWidth / (maxValue - minValue)
                                            
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
                                            leftBarPosition = CGFloat(barWidth / (maxValue - minValue) * (thumbValue - minValue))

                                        }
                                        
                                    } else if value.location.x <= 0 {
                                        
                                        //thumb over minValue, thumbValue is always minValue.
                                        thumbValue = minValue
                                        
                                    } else if value.location.x >= barWidth {
                                        
                                        //thumb over maxValue, thumbValue is always maxValue.
                                        thumbValue = maxValue
                                        
                                    }
                                    
                                }
                            
                        )
                    
                }
                
                //right limit value
                if !isHideLimitValue {
                    
                    Text("\(Int(maxValue))")
                        .font(maxValueFont)
                        .fontWeight(maxValueFontWeight)
                        .foregroundColor(maxValueColor)
                        .offset(x: limitValueOffset)
                    
                }
                
            }
            
        }
        
    }
    
}

public extension PlusMinusSlider {
    
    //initialize
    private init(thumbValue: Binding<Double>, barWidth: CGFloat, barHeight: CGFloat, isHideLimitValue: Bool, isHideThumbValue: Bool, isIntThumb: Bool, isSmoothDrag: Bool,  limitValueOffset: CGFloat, maxValue: Double, maxValueColor: Color, maxValueFont: Font, maxValueFontWeight: Font.Weight, minValue: Double, minValueColor: Color, minValueFont: Font, minValueFontWeight: Font.Weight, sliderColor: Color, thumbColor: Color, thumbDiameter: CGFloat, thumbValueColor: Color, thumbValueFont: Font, thumbValueFontWeight: Font.Weight, thumbValueOffset: CGFloat, valueColor: Color) {
        
        self.barWidth = barWidth
        self.barHeight = barHeight
        self.isHideLimitValue = isHideLimitValue
        self.isHideThumbValue = isHideThumbValue
        self.isIntThumb = isIntThumb
        self.isSmoothDrag = isSmoothDrag
        self.limitValueOffset = limitValueOffset
        self.maxValue = maxValue
        self.maxValueColor = maxValueColor
        self.maxValueFont = maxValueFont
        self.maxValueFontWeight = maxValueFontWeight
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
    
    func checkValueDiameter(_ diameter: CGFloat) -> CGFloat {
        
        if (self.barWidth <= diameter) {
            
            return self.barWidth
            
        } else {
            
            return diameter
            
        }
        
    }
    
    func checkThumbValueOffset(_ diameter: CGFloat) -> CGFloat {
        
        if(diameter <= 30) {
            
            return 30
            
        } else {
            
            return diameter * 3 / 4
            
        }
        
    }

    //set slider's bar width
    func barWidth(_ width: Double) -> Self {
        
        PlusMinusSlider(thumbValue: self._thumbValue, barWidth: width, barHeight: self.barHeight, isHideLimitValue: self.isHideLimitValue, isHideThumbValue: self.isHideThumbValue, isIntThumb: self.isIntThumb, isSmoothDrag: self.isSmoothDrag, limitValueOffset: self.limitValueOffset, maxValue: self.maxValue, maxValueColor: self.maxValueColor, maxValueFont: self.maxValueFont, maxValueFontWeight: self.maxValueFontWeight, minValue: self.minValue, minValueColor: self.minValueColor, minValueFont: self.minValueFont, minValueFontWeight: self.minValueFontWeight, sliderColor: self.sliderColor, thumbColor: self.thumbColor, thumbDiameter: self.thumbDiameter, thumbValueColor: self.thumbValueColor, thumbValueFont: self.thumbValueFont, thumbValueFontWeight: self.thumbValueFontWeight, thumbValueOffset: self.thumbValueOffset, valueColor: self.valueColor)

    }
    
    //set slider's bar height
    func barHeight(_ height: Double) -> Self {
        
        PlusMinusSlider(thumbValue: self._thumbValue, barWidth: self.barWidth, barHeight: height, isHideLimitValue: self.isHideLimitValue, isHideThumbValue: self.isHideThumbValue, isIntThumb: self.isIntThumb, isSmoothDrag: self.isSmoothDrag, limitValueOffset: self.limitValueOffset, maxValue: self.maxValue, maxValueColor: self.maxValueColor, maxValueFont: self.maxValueFont, maxValueFontWeight: self.maxValueFontWeight, minValue: self.minValue, minValueColor: self.minValueColor, minValueFont: self.minValueFont, minValueFontWeight: self.minValueFontWeight, sliderColor: self.sliderColor, thumbColor: self.thumbColor, thumbDiameter: self.thumbDiameter, thumbValueColor: self.thumbValueColor, thumbValueFont: self.thumbValueFont, thumbValueFontWeight: self.thumbValueFontWeight, thumbValueOffset: self.thumbValueOffset, valueColor: self.valueColor)

    }
    
    //hide left and right values
    func isHideLimitValue(_ bool: Bool) -> Self {
        
        PlusMinusSlider(thumbValue: self._thumbValue, barWidth: self.barWidth, barHeight: self.barHeight, isHideLimitValue: bool, isHideThumbValue: self.isHideThumbValue, isIntThumb: self.isIntThumb, isSmoothDrag: self.isSmoothDrag, limitValueOffset: self.limitValueOffset, maxValue: self.maxValue, maxValueColor: self.maxValueColor, maxValueFont: self.maxValueFont, maxValueFontWeight: self.maxValueFontWeight, minValue: self.minValue, minValueColor: self.minValueColor, minValueFont: self.minValueFont, minValueFontWeight: self.minValueFontWeight, sliderColor: self.sliderColor, thumbColor: self.thumbColor, thumbDiameter: self.thumbDiameter, thumbValueColor: self.thumbValueColor, thumbValueFont: self.thumbValueFont, thumbValueFontWeight: self.thumbValueFontWeight, thumbValueOffset: self.thumbValueOffset, valueColor: self.valueColor)

    }
    
    //hide value on the thumb
    func isHideThumbValue(_ bool: Bool) -> Self {
        
        PlusMinusSlider(thumbValue: self._thumbValue, barWidth: self.barWidth, barHeight: self.barHeight, isHideLimitValue: self.isHideLimitValue, isHideThumbValue: bool, isIntThumb: self.isIntThumb, isSmoothDrag: self.isSmoothDrag, limitValueOffset: self.limitValueOffset, maxValue: self.maxValue, maxValueColor: self.maxValueColor, maxValueFont: self.maxValueFont, maxValueFontWeight: self.maxValueFontWeight, minValue: self.minValue, minValueColor: self.minValueColor, minValueFont: self.minValueFont, minValueFontWeight: self.minValueFontWeight, sliderColor: self.sliderColor, thumbColor: self.thumbColor, thumbDiameter: self.thumbDiameter, thumbValueColor: self.thumbValueColor, thumbValueFont: self.thumbValueFont, thumbValueFontWeight: self.thumbValueFontWeight, thumbValueOffset: self.thumbValueOffset, valueColor: self.valueColor)

    }
    
    //change Int value from Double value
    func isIntThumb(_ bool: Bool) -> Self {
        
        PlusMinusSlider(thumbValue: self._thumbValue, barWidth: self.barWidth, barHeight: self.barHeight, isHideLimitValue: self.isHideLimitValue, isHideThumbValue: self.isHideThumbValue, isIntThumb: bool, isSmoothDrag: self.isSmoothDrag, limitValueOffset: self.limitValueOffset, maxValue: self.maxValue, maxValueColor: self.maxValueColor, maxValueFont: self.maxValueFont, maxValueFontWeight: self.maxValueFontWeight, minValue: self.minValue, minValueColor: self.minValueColor, minValueFont: self.minValueFont, minValueFontWeight: self.minValueFontWeight, sliderColor: self.sliderColor, thumbColor: self.thumbColor, thumbDiameter: self.thumbDiameter, thumbValueColor: self.thumbValueColor, thumbValueFont: self.thumbValueFont, thumbValueFontWeight: self.thumbValueFontWeight, thumbValueOffset: self.thumbValueOffset, valueColor: self.valueColor)

    }
    
    //smooth drag of thumb
    func isSmoothDrag(_ bool: Bool) -> Self {
        
        PlusMinusSlider(thumbValue: self._thumbValue, barWidth: self.barWidth, barHeight: self.barHeight, isHideLimitValue: self.isHideLimitValue, isHideThumbValue: self.isHideThumbValue, isIntThumb: self.isIntThumb, isSmoothDrag: bool, limitValueOffset: self.limitValueOffset, maxValue: self.maxValue, maxValueColor: self.maxValueColor, maxValueFont: self.maxValueFont, maxValueFontWeight: self.maxValueFontWeight, minValue: self.minValue, minValueColor: self.minValueColor, minValueFont: self.minValueFont, minValueFontWeight: self.minValueFontWeight, sliderColor: self.sliderColor, thumbColor: self.thumbColor, thumbDiameter: self.thumbDiameter, thumbValueColor: self.thumbValueColor, thumbValueFont: self.thumbValueFont, thumbValueFontWeight: self.thumbValueFontWeight, thumbValueOffset: self.thumbValueOffset, valueColor: self.valueColor)

    }
    
    //bar of slider and limit values offset
    func limitValueOffset(_ offset: CGFloat) -> Self {
        
        PlusMinusSlider(thumbValue: self._thumbValue, barWidth: self.barWidth, barHeight: self.barHeight, isHideLimitValue: self.isHideLimitValue, isHideThumbValue: self.isHideThumbValue, isIntThumb: self.isIntThumb, isSmoothDrag: self.isSmoothDrag, limitValueOffset: offset, maxValue: self.maxValue, maxValueColor: self.maxValueColor, maxValueFont: self.maxValueFont, maxValueFontWeight: self.maxValueFontWeight, minValue: self.minValue, minValueColor: self.minValueColor, minValueFont: self.minValueFont, minValueFontWeight: self.minValueFontWeight, sliderColor: self.sliderColor, thumbColor: self.thumbColor, thumbDiameter: self.thumbDiameter, thumbValueColor: self.thumbValueColor, thumbValueFont: self.thumbValueFont, thumbValueFontWeight: self.thumbValueFontWeight, thumbValueOffset: self.thumbValueOffset, valueColor:  self.valueColor)
        
    }
    
    //set maximum value's color
    func maxValueColor(_ color: Color) -> Self {
        
        PlusMinusSlider(thumbValue: self._thumbValue, barWidth: self.barWidth, barHeight: self.barHeight, isHideLimitValue: self.isHideLimitValue, isHideThumbValue: self.isHideThumbValue, isIntThumb: self.isIntThumb, isSmoothDrag: self.isSmoothDrag, limitValueOffset: self.limitValueOffset, maxValue: self.maxValue, maxValueColor: color, maxValueFont: self.maxValueFont, maxValueFontWeight: self.maxValueFontWeight, minValue: self.minValue, minValueColor: self.minValueColor, minValueFont: self.minValueFont, minValueFontWeight: self.minValueFontWeight, sliderColor: self.sliderColor, thumbColor: self.thumbColor, thumbDiameter: self.thumbDiameter, thumbValueColor: self.thumbValueColor, thumbValueFont: self.thumbValueFont, thumbValueFontWeight: self.thumbValueFontWeight, thumbValueOffset: self.thumbValueOffset, valueColor: self.valueColor)

    }
    
    //set maximum value's font
    func maxValueFont(_ font: Font) -> Self {
        
        PlusMinusSlider(thumbValue: self._thumbValue, barWidth: self.barWidth, barHeight: self.barHeight, isHideLimitValue: self.isHideLimitValue, isHideThumbValue: self.isHideThumbValue, isIntThumb: self.isIntThumb, isSmoothDrag: self.isSmoothDrag, limitValueOffset: self.limitValueOffset, maxValue: self.maxValue, maxValueColor: self.maxValueColor, maxValueFont: font, maxValueFontWeight: self.maxValueFontWeight, minValue: self.minValue, minValueColor: self.minValueColor, minValueFont: self.minValueFont, minValueFontWeight: self.minValueFontWeight, sliderColor: self.sliderColor, thumbColor: self.thumbColor, thumbDiameter: self.thumbDiameter, thumbValueColor: self.thumbValueColor, thumbValueFont: self.thumbValueFont, thumbValueFontWeight: self.thumbValueFontWeight, thumbValueOffset: self.thumbValueOffset, valueColor: self.valueColor)
        
    }
    
    //set maximum value's font weight
    func maxValueFontWeight(_ weight: Font.Weight) -> Self {
        
        PlusMinusSlider(thumbValue: self._thumbValue, barWidth: self.barWidth, barHeight: self.barHeight, isHideLimitValue: self.isHideLimitValue, isHideThumbValue: self.isHideThumbValue, isIntThumb: self.isIntThumb, isSmoothDrag: self.isSmoothDrag, limitValueOffset: self.limitValueOffset, maxValue: self.maxValue, maxValueColor: self.maxValueColor, maxValueFont: self.maxValueFont, maxValueFontWeight: weight, minValue: self.minValue, minValueColor: self.minValueColor, minValueFont: self.minValueFont, minValueFontWeight: self.minValueFontWeight, sliderColor: self.sliderColor, thumbColor: self.thumbColor, thumbDiameter: self.thumbDiameter, thumbValueColor: self.thumbValueColor, thumbValueFont: self.thumbValueFont, thumbValueFontWeight: self.thumbValueFontWeight, thumbValueOffset: self.thumbValueOffset, valueColor: self.valueColor)

    }
    
    //set minimum value's color
    func minValueColor(_ color: Color) -> Self {
        
        PlusMinusSlider(thumbValue: self._thumbValue, barWidth: self.barWidth, barHeight: self.barHeight, isHideLimitValue: self.isHideLimitValue, isHideThumbValue: self.isHideThumbValue, isIntThumb: self.isIntThumb, isSmoothDrag: self.isSmoothDrag, limitValueOffset: self.limitValueOffset, maxValue: self.maxValue, maxValueColor: self.maxValueColor, maxValueFont: self.maxValueFont, maxValueFontWeight: self.maxValueFontWeight, minValue: self.minValue, minValueColor: color, minValueFont: self.minValueFont, minValueFontWeight: self.minValueFontWeight, sliderColor: self.sliderColor, thumbColor: self.thumbColor, thumbDiameter: self.thumbDiameter, thumbValueColor: self.thumbValueColor, thumbValueFont: self.thumbValueFont, thumbValueFontWeight: self.thumbValueFontWeight, thumbValueOffset: self.thumbValueOffset, valueColor: self.valueColor)
        
    }
    
    //set minimum value's font
    func minValueFont(_ font: Font) -> Self {
        
        PlusMinusSlider(thumbValue: self._thumbValue, barWidth: self.barWidth, barHeight: self.barHeight, isHideLimitValue: self.isHideLimitValue, isHideThumbValue: self.isHideThumbValue, isIntThumb: self.isIntThumb, isSmoothDrag: self.isSmoothDrag, limitValueOffset: self.limitValueOffset, maxValue: self.maxValue, maxValueColor: self.maxValueColor, maxValueFont: self.maxValueFont, maxValueFontWeight: self.maxValueFontWeight, minValue: self.minValue, minValueColor: self.minValueColor, minValueFont: font, minValueFontWeight: self.minValueFontWeight, sliderColor: self.sliderColor, thumbColor: self.thumbColor, thumbDiameter: self.thumbDiameter, thumbValueColor: self.thumbValueColor, thumbValueFont: self.thumbValueFont, thumbValueFontWeight: self.thumbValueFontWeight, thumbValueOffset: self.thumbValueOffset, valueColor: self.valueColor)
        
    }
    
    //set minimu value's font weight
    func minValueFontWeight(_ weight: Font.Weight) -> Self {
        
        PlusMinusSlider(thumbValue: self._thumbValue, barWidth: self.barWidth, barHeight: self.barHeight, isHideLimitValue: self.isHideLimitValue, isHideThumbValue: self.isHideThumbValue, isIntThumb: self.isIntThumb, isSmoothDrag: self.isSmoothDrag, limitValueOffset: self.limitValueOffset, maxValue: self.maxValue, maxValueColor: self.maxValueColor, maxValueFont: self.maxValueFont, maxValueFontWeight: self.maxValueFontWeight, minValue: self.minValue, minValueColor: self.minValueColor, minValueFont: self.minValueFont, minValueFontWeight: weight, sliderColor: self.sliderColor, thumbColor: self.thumbColor, thumbDiameter: self.thumbDiameter, thumbValueColor: self.thumbValueColor, thumbValueFont: self.thumbValueFont, thumbValueFontWeight: self.thumbValueFontWeight, thumbValueOffset: self.thumbValueOffset, valueColor: self.valueColor)

    }

    //set slider's color. it is background color. not value color.
    func sliderColor(_ color: Color) -> Self {
        
        PlusMinusSlider(thumbValue: self._thumbValue, barWidth: self.barWidth, barHeight: self.barHeight, isHideLimitValue: self.isHideLimitValue, isHideThumbValue: self.isHideThumbValue, isIntThumb: self.isIntThumb, isSmoothDrag: self.isSmoothDrag, limitValueOffset: self.limitValueOffset, maxValue: self.maxValue, maxValueColor: self.maxValueColor, maxValueFont: self.maxValueFont, maxValueFontWeight: self.maxValueFontWeight, minValue: self.minValue, minValueColor: self.minValueColor, minValueFont: self.minValueFont, minValueFontWeight: self.minValueFontWeight, sliderColor: color, thumbColor: self.thumbColor, thumbDiameter: self.thumbDiameter, thumbValueColor: self.thumbValueColor, thumbValueFont: self.thumbValueFont, thumbValueFontWeight: self.thumbValueFontWeight, thumbValueOffset: self.thumbValueOffset, valueColor:  self.valueColor)
        
    }
    
    //set thumb's color
    func thumbColor(_ color: Color) -> Self {
        
        PlusMinusSlider(thumbValue: self._thumbValue, barWidth: self.barWidth, barHeight: self.barHeight, isHideLimitValue: self.isHideLimitValue, isHideThumbValue: self.isHideThumbValue, isIntThumb: self.isIntThumb, isSmoothDrag: self.isSmoothDrag, limitValueOffset: self.limitValueOffset, maxValue: self.maxValue, maxValueColor: self.maxValueColor, maxValueFont: self.maxValueFont, maxValueFontWeight: self.maxValueFontWeight, minValue: self.minValue, minValueColor: self.minValueColor, minValueFont: self.minValueFont, minValueFontWeight: minValueFontWeight, sliderColor: self.sliderColor, thumbColor: color, thumbDiameter: self.thumbDiameter, thumbValueColor: self.thumbValueColor, thumbValueFont: self.thumbValueFont, thumbValueFontWeight: self.thumbValueFontWeight, thumbValueOffset: self.thumbValueOffset, valueColor: self.valueColor)
        
    }
    
    //set thumb's diameter
    func thumbDiameter(_ diameter: CGFloat) -> Self {
        
        let checkedDiameter = checkValueDiameter(diameter)
        let checkedThumbValueOffset =  checkThumbValueOffset(diameter)
        
        return PlusMinusSlider(thumbValue: self._thumbValue, barWidth: self.barWidth, barHeight: self.barHeight, isHideLimitValue: self.isHideLimitValue, isHideThumbValue: self.isHideThumbValue, isIntThumb: self.isIntThumb, isSmoothDrag: self.isSmoothDrag, limitValueOffset: self.limitValueOffset, maxValue: self.maxValue, maxValueColor: self.maxValueColor, maxValueFont: self.maxValueFont, maxValueFontWeight: self.maxValueFontWeight, minValue: self.minValue, minValueColor: self.minValueColor, minValueFont: self.minValueFont, minValueFontWeight: minValueFontWeight, sliderColor: self.sliderColor, thumbColor: self.thumbColor, thumbDiameter: checkedDiameter, thumbValueColor: self.thumbValueColor, thumbValueFont: self.thumbValueFont, thumbValueFontWeight: self.thumbValueFontWeight, thumbValueOffset: checkedThumbValueOffset, valueColor: self.valueColor)
        
    }
    
    //set thumb's value color.
    func thumbValueColor(_ color: Color) -> Self {
        
        PlusMinusSlider(thumbValue: self._thumbValue, barWidth: self.barWidth, barHeight: self.barHeight, isHideLimitValue: self.isHideLimitValue, isHideThumbValue: self.isHideThumbValue, isIntThumb: self.isIntThumb, isSmoothDrag: self.isSmoothDrag, limitValueOffset: self.limitValueOffset, maxValue: self.maxValue, maxValueColor: self.maxValueColor, maxValueFont: self.maxValueFont, maxValueFontWeight: self.maxValueFontWeight, minValue: self.minValue, minValueColor: self.minValueColor, minValueFont: self.minValueFont, minValueFontWeight: self.minValueFontWeight, sliderColor: self.sliderColor, thumbColor: self.thumbColor, thumbDiameter: self.thumbDiameter, thumbValueColor: color, thumbValueFont: self.thumbValueFont, thumbValueFontWeight: self.thumbValueFontWeight, thumbValueOffset: self.thumbValueOffset, valueColor: self.valueColor)
        
    }
    
    //set thumb's value font
    func thumbValueFont(_ font: Font) -> Self {
        
        PlusMinusSlider(thumbValue: self._thumbValue, barWidth: self.barWidth, barHeight: self.barHeight, isHideLimitValue: self.isHideLimitValue, isHideThumbValue: self.isHideThumbValue, isIntThumb: self.isIntThumb, isSmoothDrag: self.isSmoothDrag, limitValueOffset: self.limitValueOffset, maxValue: self.maxValue, maxValueColor: self.maxValueColor, maxValueFont: self.maxValueFont, maxValueFontWeight: self.maxValueFontWeight, minValue: self.minValue, minValueColor: self.minValueColor, minValueFont: self.minValueFont, minValueFontWeight: self.minValueFontWeight, sliderColor: self.sliderColor, thumbColor: self.thumbColor, thumbDiameter: self.thumbDiameter, thumbValueColor: self.thumbValueColor, thumbValueFont: font, thumbValueFontWeight: self.thumbValueFontWeight, thumbValueOffset: self.thumbValueOffset, valueColor: self.valueColor)
        
    }
    
    //set thumb's value font weight
    func thumbValueFontWeight(_ weight: Font.Weight) -> Self {
        
        PlusMinusSlider(thumbValue: self._thumbValue, barWidth: self.barWidth, barHeight: self.barHeight, isHideLimitValue: self.isHideLimitValue, isHideThumbValue: self.isHideThumbValue, isIntThumb: self.isIntThumb, isSmoothDrag: self.isSmoothDrag, limitValueOffset: self.limitValueOffset, maxValue: self.maxValue, maxValueColor: self.maxValueColor, maxValueFont: self.maxValueFont, maxValueFontWeight: self.maxValueFontWeight, minValue: self.minValue, minValueColor: self.minValueColor, minValueFont: self.minValueFont, minValueFontWeight: self.minValueFontWeight, sliderColor: self.sliderColor, thumbColor: self.thumbColor, thumbDiameter: self.thumbDiameter, thumbValueColor: self.thumbValueColor, thumbValueFont: self.thumbValueFont, thumbValueFontWeight: weight, thumbValueOffset: self.thumbValueOffset, valueColor: self.valueColor)

    }
    
    //set thumb's value font weight
    func thumbValueOffset(_ offset: CGFloat) -> Self {
        
        PlusMinusSlider(thumbValue: self._thumbValue, barWidth: self.barWidth, barHeight: self.barHeight, isHideLimitValue: self.isHideLimitValue, isHideThumbValue: self.isHideThumbValue, isIntThumb: self.isIntThumb, isSmoothDrag: self.isSmoothDrag, limitValueOffset: self.limitValueOffset, maxValue: self.maxValue, maxValueColor: self.maxValueColor, maxValueFont: self.maxValueFont, maxValueFontWeight: self.maxValueFontWeight, minValue: self.minValue, minValueColor: self.minValueColor, minValueFont: self.minValueFont, minValueFontWeight: self.minValueFontWeight, sliderColor: self.sliderColor, thumbColor: self.thumbColor, thumbDiameter: self.thumbDiameter, thumbValueColor: self.thumbValueColor, thumbValueFont: self.thumbValueFont, thumbValueFontWeight: self.thumbValueFontWeight, thumbValueOffset: offset, valueColor: self.valueColor)

    }
    
    //set value color. default color is blue. it is value.
    func valueColor(_ color: Color) -> Self {
        
        PlusMinusSlider(thumbValue: self._thumbValue, barWidth: self.barWidth, barHeight: self.barHeight, isHideLimitValue: self.isHideLimitValue, isHideThumbValue: self.isHideThumbValue, isIntThumb: self.isIntThumb, isSmoothDrag: self.isSmoothDrag, limitValueOffset: self.limitValueOffset, maxValue: self.maxValue, maxValueColor: self.maxValueColor, maxValueFont: self.maxValueFont, maxValueFontWeight: self.maxValueFontWeight, minValue: self.minValue, minValueColor: self.minValueColor, minValueFont: self.minValueFont, minValueFontWeight: self.minValueFontWeight, sliderColor: self.sliderColor, thumbColor: self.thumbColor, thumbDiameter: self.thumbDiameter, thumbValueColor: self.thumbValueColor, thumbValueFont: self.thumbValueFont, thumbValueFontWeight: self.thumbValueFontWeight, thumbValueOffset: self.thumbValueOffset, valueColor: color)
        
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
    
}

