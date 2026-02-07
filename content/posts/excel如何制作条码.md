---
title: "excel如何制作条码"
date: 2026-02-07T08:17:23.705648+08:00
description: "Excel 制作条码完整教程   目标    通过 Excel 轻松生成多种条码（Code‑128、EAN13、QR 等），适用于库存管理、标签打印、资产跟踪等场景。  ---   原因分析  | 需求 | 可能的做法 | 主要难点 | |------|------------|"
draft: false
categories: ["AI教程"]
---

# Excel 制作条码完整教程

> **目标**  
> 通过 Excel 轻松生成多种条码（Code‑128、EAN13、QR 等），适用于库存管理、标签打印、资产跟踪等场景。

---

## 原因分析

| 需求 | 可能的做法 | 主要难点 |
|------|------------|----------|
| 只需在表格中显示条码符号 | 直接使用条码字体（如 **IDAutomationHC39M**、**Code 128** 等） | ① 需要下载并安装条码字体<br>② 需要在单元格前后加上对应的 **起始/结束符**（如 `*`、`+`） |
| 需要生成图片条码 | 用插件或 VBA 调用外部 API 生成 PNG/JPG 并插入 | ① 插件收费或功能有限<br>② VBA 需要一定编码经验 |
| 高度可定制（颜色、尺寸、二维码） | 使用在线 API 或第三方库 | ① 需要网络环境<br>② 需要将图片导入表格 |

> **结论**  
> 1. **条码字体** 是最快捷、最轻量的方案，适合单次打印。  
> 2. **插件/VBA** 适合需要批量生成、自动化或需在 Excel 里直接预览。  
> 3. **在线生成 + 插件** 适合需要多种条码类型（如二维码、条形码混排）且对图像质量要求高。

---

## 方案一：使用条码字体

> **适用场景**：需要快速在表格中显示条码，打印时即可使用，且条码类型为常见的 1D 条码（Code‑128、Code‑39、EAN13 等）。

### 步骤 1：下载并安装条码字体

| 字体 | 说明 | 下载地址 |
|------|------|----------|
| IDAutomationHC39M | Code‑39（含起止符 `*`） | https://www.idautomation.com/barcode-fonts/ |
| IDAutomationCode128M | Code‑128 | 同上 |
| IDAutomationEAN13 | EAN‑13 | 同上 |

> **安装**：双击 `.ttf` 文件，点击“安装”。安装完后重启 Excel。

### 步骤 2：准备数据

| 列 | 说明 | 示例 |
|----|------|------|
| A | 商品编号 | 123456789012 |
| B | 条码格式 | Code‑128 |
| C | 备注 |  |

> **提示**：若使用 Code‑39，需在每个条码前后加上 `*`（如 `*123456*`）。

### 步骤 3：添加条码前后缀

在 **D 列**（条码列）使用公式：

```excel
=IF(B2="Code-39", "*" & A2 & "*", A2)
```

> ① 对 Code‑39 需要 `*` 作为起止符。<br>② 对 Code‑128 不需要。

### 步骤 4：设置字体

1. 选中 **D 列**，右键 → “设置单元格格式” → “字体” → 选择已安装的条码字体（如 `IDAutomationHC39M`）。<br>
2. 如需调整条码大小，修改“字体大小”即可。

### 步骤 5：打印

> 打印前请先在“页面布局”中检查页边距，确保条码完整。

---

## 方案二：使用 Excel 插件（免费/付费）

> **适用场景**：需要图像条码（二维码、条形码混排）或批量生成。

### 方案二-1：使用 **Barcode Add-in for Excel**（免费版）

1. 打开 Excel → 插件市场 → 搜索 “Barcode” → 安装“Barcode by Templafy”或“Barcode for Excel”。  
2. 选中需要生成条码的单元格，点击插件 → 选择条码类型 → 输入数据 → 生成。  
3. 生成后可将条码图像插入单元格或直接复制到打印模板。

> **优点**：图像质量高，支持多种编码。<br>**缺点**：免费版功能有限，需付费解锁。

### 方案二-2：使用 **VBA 调用在线 API**

> 例如 `https://api.qrserver.com/v1/create-qr-code/`（二维码）或 `https://bwipjs-api.metafloor.com/`（1D 条码）。

```vb
Option Explicit

Sub InsertBarcode()
    Dim ws As Worksheet
    Dim cell As Range
    Dim barcodeURL As String
    Dim pic As Picture
    
    Set ws = ThisWorkbook.Sheets("Sheet1")
    For Each cell In ws.Range("A2:A10") ' 假设 A 列是数据
        barcodeURL = "https://bwipjs-api.metafloor.com/?bcid=code128&text=" & cell.Value
        Set pic = ws.Pictures.Insert(barcodeURL)
        With pic
            .Left = cell.Offset(0, 1).Left
            .Top = cell.Offset(0, 1).Top
            .ShapeRange.LockAspectRatio = msoTrue
            .ShapeRange.Height = 30
        End With
    Next cell
End Sub
```

> **步骤说明**：  
> 1. 读取数据列。  
> 2. 通过 HTTP 生成条码图片链接。  
> 3. 插入图片并对齐。  

> **注意**：需要网络连接，且 API 调用频率有限。

---

## 方案三：使用 Power Query + 条码生成器（如 `bwip-js` 或 `Zint`）

> **适用场景**：大批量数据，需要在 Excel 内部完成所有步骤，且不想安装插件。

### 步骤 1：导入数据

1. 在 **Power Query**（数据 → 获取外部数据）中导入数据表。  

### 步骤 2：添加列生成条码 URL

在查询编辑器中，使用自定义列：

```m
= "https://bwipjs-api.metafloor.com/?bcid=code128&text=" & [商品编号]
```

### 步骤 3：下载图片

在 Power Query 中无法直接下载图片，但可以导出 URL 列到 Excel，然后使用 VBA 或者 **Office 365** 的 `IMAGE()` 函数：

```excel
=IMAGE(D2, 1, 30, 100)   ' D2 为 URL
```

> **说明**：`IMAGE` 函数在 Excel 365/2021 可用，支持从 URL 直接渲染图像。

### 步骤 4：完成

将生成的图片列放置在打印模板中即可。

---

## 常见问题解答

| 问题 | 解决方案 | 备注 |
|------|----------|------|
| **条码字体安装后不生效** | 重新启动 Excel，或在单元格里先敲入空格再删除；检查字体是否被锁定 | 某些旧版本 Excel 需要重启 |
| **条码显示不完整** | 调整列宽或单元格高度；设置字体大小；打印预览检查边距 | 也可使用 `图片` 方案 |
| **条码不被扫码机识别** | 确认使用的编码类型与扫描设备匹配；检查是否缺少起止符；尝试调整条码宽度 | 例如 Code‑39 需要 `*`，EAN13 则不 |
| **图片条码无法打印** | 确认打印机支持图像打印；调整图片分辨率；使用高 DPI 生成 | 若使用在线 API，建议下载 PNG 再插入 |
| **插件太占用资源** | 关闭不必要的插件；使用 VBA 方案 | 付费插件可按需开启 |
| **需要多种条码类型（如二维码+条形码）** | 组合使用方案二的 VBA 或方案三的 `IMAGE` | 也可考虑第三方软件如 **BarCode Studio** |

---

## 小结

- **条码字体** 是最轻量、最易操作的方案，适合单次打印。  
- **插件 / VBA** 适合需要图像条码、批量生成或自动化的场景。  
- **Power Query + IMAGE** 适合 Office 365 用户，完全在 Excel 内完成。

根据实际需求、Excel 版本、条码类型，任选其一即可实现高效的条码生成。祝你使用愉快！