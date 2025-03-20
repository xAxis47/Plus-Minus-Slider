<img src="https://img.shields.io/badge/4.0-Swift-red?style=flat&logo=Swift&logoColor=FA7343"> <img src="https://img.shields.io/badge/16.0-iOS-orange?style=flat"> <img src="https://img.shields.io/badge/LICENSE-Apache%20License%202.0-green?style=flat">

<img src="https://github.com/xAxis47/PlusMinusSlider/blob/8d19fca76b9351d9eeefa99ca79f5515fb145543/PlusMinusSlider/Assets/screenshot01.gif" width="300">

If you want to express plus and minus values with one slider, please use this PlusMinusSlider. This slider can provide you positive and negative values, several fonts, font weights and colors. It is written in SwiftUI.

# Installation
## Cocoapods

pod “PlusMinusSlider”

# Usage

Import the framework.

```
import PlusMinusSlider
```

Make PlusMinusSlider and must fill “thumbValue”. Don't set over limit value. If the upper limit is exceeded, a fatalError will occur.

```
import SwiftUI
import PlusMinusSlider

struct ContentView: View {

//you can set several thumbValue
  @State var thumbValue: Double = 0

  var body: some View {

    PlusMinusSlider(thumbValue: $thumbValue)

  }

}
```

If you need you can change appearance with some modifier.

```
      .isHideLimitValue(_ bool:)
      .isHideThumbValue(_ bool:)
      .isIntValue(_ bool:)
      .limitValueOffset(_ offset:)
      .maxValueColor(_ color:)
      .maxValueFont(_ font:)
      .maxValueFontWeight(_ weight:)
      .minValueColor(_ color:)
      .minValueFont(_ font:)
      .minValueFontWeight(_ weight:)
      .sliderColor(_ color:)
      .thumbColor(_ color:)
      .thumbValueColor(_ color:)
      .thumbValueFont(_ font:)
      .thumbValueFontWeight(_ weight:)
      .valueColor(_ color:)
            
      new!!
      .barWidth(_ width:)
      .barHeight(_ height:)
      .maxValue(_ value:)
      .minValue(_ value:)
      .thumbDiameter(_ diameter:)
      .thumbValueOffset(_ offset:)
      .isVertical(_ bool:)
      .maxSFSymbolsString(_ string:)
      .minSFSymbolsString(_ string:)


      
```

# Untested

The library is basically untested. Please report bugs via the issue tracker on GitHub.

# License

Licensed under the Apache License 2.0. See the LICENSE file for more information.


Thanks!
