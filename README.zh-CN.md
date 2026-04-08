# UIView-WZB

[English](./README.md)

`UIView-WZB` 的 Swift 重写版，用来在任意 `UIView` 上快速绘制表格式网格和自定义线条。

## 功能

- 一行代码绘制表格
- 支持某些行使用不同列数
- 支持自定义行高和每一行的列宽比例
- 支持按单元格索引设置文字颜色和背景色
- 数据很多时可放进 `UIScrollView`，保持固定格子尺寸并滚动
- 支持通过索引取回某个格子的 `UILabel`
- 支持单独绘制横线和竖线

## 预览

![Demo](https://github.com/WZBbiao/UIView-WZB/blob/master/1.gif?raw=true)

## 环境要求

- iOS 11.0+
- Swift 5.0+

## 安装

### Swift Package Manager

```swift
.package(url: "https://github.com/WZBbiao/UIView-WZB.git", from: "2.0.0")
```

然后在 target 中添加 `UIViewWZB` 依赖。

### CocoaPods

```ruby
pod "UIView-WZB", "~> 2.0"
```

## 快速开始

```swift
import UIKit
import UIViewWZB

let tableView = UIView(frame: CGRect(x: 16, y: 120, width: 320, height: 180))

tableView.wzb_drawList(
    with: tableView.bounds,
    columns: 4,
    rows: 4,
    datas: [
        "", "语文", "数学", "英语",
        "王晓明", "100.5", "128", "95",
        "李小华", "96.0", "105", "89",
        "张爱奇", "88.0", "118", "93"
    ]
)
```

## 主要 API

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

Swift demo 位于 `Demo/Swift/UIView-WZB`，包含：

- 基础成绩表
- 支持点击交互的合并表头销售表
- 不等高、不等宽的网格示例
- 大表格滚动示例
- 随机彩色线条示例

## 说明

- `columns` 表示一行里默认有多少列。
- `rows` 表示一共有多少行。
- 某一行列数不同，用 `columnsInfo`。
- 某一行列宽不等，用 `columnWidthInfo`。
- 行高不等时，用 `rowHeights`。
- 想保留固定 cell 尺寸并支持滚动时，用 `wzb_drawScrollableList`。

## 兼容说明

旧的 Objective-C 实现仍然保留在 `Source/OC` 和 `Demo/OC` 目录，方便迁移参考。

## License

`UIView-WZB` 使用 MIT License。
