# UIView-WZB

[简体中文](./README.zh-CN.md)

A Swift rewrite of `UIView-WZB` for drawing lightweight grid layouts and custom separator lines on top of any `UIView`.

## Features

- Draw table-style grids with a single API call
- Override column counts on specific rows
- Customize row heights and per-row column width ratios
- Customize text color and cell background color by cell index
- Render large data sets inside a `UIScrollView` without squeezing cells
- Retrieve any rendered cell label for gesture handling or extra styling
- Draw standalone horizontal and vertical lines

## Preview

![Demo](https://github.com/WZBbiao/UIView-WZB/blob/master/1.gif?raw=true)

## Requirements

- iOS 11.0+
- Swift 5.0+
- Xcode 15 or later recommended

## Installation

### Swift Package Manager

```swift
.package(url: "https://github.com/WZBbiao/UIView-WZB.git", from: "2.0.0")
```

Add the `UIViewWZB` product to your target dependencies.

### CocoaPods

```ruby
pod "UIView-WZB", "~> 2.0"
```

## Quick Start

```swift
import UIKit
import UIViewWZB

let tableView = UIView(frame: CGRect(x: 16, y: 120, width: 320, height: 180))

tableView.wzb_drawList(
    with: tableView.bounds,
    columns: 4,
    rows: 4,
    datas: [
        "", "Chinese", "Math", "English",
        "Wang Xiaoming", "100.5", "128", "95",
        "Li Xiaohua", "96.0", "105", "89",
        "Zhang Aiqi", "88.0", "118", "93"
    ]
)
```

## API

```swift
func wzb_drawList(with rect: CGRect, columns: Int, rows: Int, datas: [Any])

func wzb_drawList(
    with rect: CGRect,
    columns: Int,
    rows: Int,
    datas: [Any],
    columnsInfo: [Int: Int]?
)

func wzb_drawList(
    with rect: CGRect,
    columns: Int,
    rows: Int,
    datas: [Any],
    colorInfo: [Int: UIColor]?
)

func wzb_drawList(
    with rect: CGRect,
    columns: Int,
    rows: Int,
    datas: [Any],
    colorInfo: [Int: UIColor]?,
    columnsInfo: [Int: Int]?,
    backgroundColorInfo: [Int: UIColor]?
)

func wzb_drawList(
    with rect: CGRect,
    defaultColumns: Int,
    rowHeights: [CGFloat],
    datas: [Any],
    colorInfo: [Int: UIColor]? = nil,
    columnsInfo: [Int: Int]? = nil,
    columnWidthInfo: [Int: [CGFloat]]? = nil,
    backgroundColorInfo: [Int: UIColor]? = nil
)

func wzb_drawScrollableList(
    origin: CGPoint = .zero,
    cellSize: CGSize,
    columns: Int,
    rows: Int,
    datas: [Any],
    colorInfo: [Int: UIColor]? = nil,
    columnsInfo: [Int: Int]? = nil,
    backgroundColorInfo: [Int: UIColor]? = nil
) -> UIView

func getLabel(withIndex index: Int) -> UILabel?

func wzb_drawLine(with frame: CGRect, lineType: WZBLineType, color: UIColor, lineWidth: CGFloat)

func wzb_removeGrid()
```

## Demo

The Swift demo app lives in `Demo/Swift/UIView-WZB` and includes:

- A basic score table
- A merged-row sales table with tap interaction
- A variable-size grid with uneven row heights and column widths
- A scrollable large table demo
- A decorative line canvas

## Notes

- `columns` always means the number of cells in one row.
- `rows` always means the number of horizontal rows.
- Use `columnsInfo` when a specific row should have a different number of cells.
- Use `columnWidthInfo` when cells in the same row should not share equal width.
- Use `wzb_drawScrollableList` when the grid should keep a fixed cell size and scroll instead of shrinking.

## Legacy

The original Objective-C implementation is still kept under `Source/OC` and `Demo/OC` for migration reference.

## License

`UIView-WZB` is available under the MIT license.
