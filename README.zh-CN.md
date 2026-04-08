# UIView-WZB

[English](./README.md)

`UIView-WZB` 的 Swift 重写版，用来在任意 `UIView` 上快速绘制表格式网格和自定义线条。

## 功能

- 一行代码绘制表格
- 支持某些行使用不同列数
- 支持按单元格索引设置文字颜色和背景色
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

func getLabel(withIndex index: Int) -> UILabel?

func wzb_drawLine(with frame: CGRect, lineType: WZBLineType, color: UIColor, lineWidth: CGFloat)

func wzb_removeGrid()
```

## Demo

Swift demo 位于 `Demo/Swift/UIView-WZB`，包含：

- 基础成绩表
- 支持点击交互的合并表头销售表
- 随机彩色线条示例

## 兼容说明

旧的 Objective-C 实现仍然保留在 `Source/OC` 和 `Demo/OC` 目录，方便迁移参考。

## License

`UIView-WZB` 使用 MIT License。
