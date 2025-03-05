<img src="https://img.shields.io/badge/4.0-Swift-red?style=flat&logo=Swift&logoColor=FA7343"> <img src="https://img.shields.io/badge/15.6-iOS-orange?style=flat"> <img src="https://img.shields.io/badge/SUCCESS-Swift%20Package%20Manager-blue?style=flat"> <img src="https://img.shields.io/badge/LICENSE-Apache%20License%202.0-green?style=flat">


<img src="https://github.com/xAxis47/PlusMinusSlider/assets/140302470/cccaeff2-41df-4d54-b995-d3e5c1306bb7" width="300">

If you want to express plus and minus values with one slider, please use this PlusMinusSlider. It is written in SwiftUI.

# Installation

Use Swift Package Manager.

# Usage

Import the framework.

```
import PlusMinusSlider
```

Make PlusMinusSlider and must fill “thumbValue”.

```
import SwiftUI

struct ContentView: View {

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
      .isIntThumb(_ bool:)
      .isSmoothDrag(_ bool:)
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
```

# Untested

The library is basically untested. Please report bugs via the issue tracker on GitHub.

# License

Licensed under the Apache License 2.0. See the LICENSE file for more information.


Thanks!
