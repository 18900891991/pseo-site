---
title: "excel如何編頁碼"
date: 2026-02-07T08:17:23.722613+08:00
description: "Excel 如何編頁碼  在將 Excel 工作表列印或輸出為 PDF 時，往往需要在頁眉或頁腳中加入頁碼。雖然 Excel 本身可以在「頁面佈局」中設置頁碼，但在某些情況下仍需要更靈活的方式（例如多工作表、非連續列印範圍、或需要把頁碼放在表格內部）。下面將從原因分析開始，依次提供三種常見的分步"
draft: false
categories: ["AI教程"]
---

# Excel 如何編頁碼

在將 Excel 工作表列印或輸出為 PDF 時，往往需要在頁眉或頁腳中加入頁碼。雖然 Excel 本身可以在「頁面佈局」中設置頁碼，但在某些情況下仍需要更靈活的方式（例如多工作表、非連續列印範圍、或需要把頁碼放在表格內部）。下面將從原因分析開始，依次提供三種常見的分步驟解決方案，並整理常見問題與解答。

---

## 原因分析

| 需求 | 為什麼需要自訂頁碼 | 典型情境 |
|------|-------------------|----------|
| **列印時顯示頁碼** | 方便閱讀、驗證資料完整性 | 報表、合約、學術論文 |
| **在工作表內部插入頁碼** | 需要在表格中顯示「第 X 頁」的標示（例如長列表分頁） | 長度超過一屏的資料，或需要在資料中標示「第 X 頁」 |
| **多工作表/多列印區域** | 需要每個工作表或區域有獨立的頁碼 | 多個客戶報告、分頁合併成單一 PDF |
| **自動更新** | 只要資料變動，頁碼自動調整 | 需要動態生成的報表 |

---

## 方案一：使用「頁面佈局」→「頁眉/頁腳」插入頁碼

這是最簡單、最常用的方式，適合需要在列印時顯示頁碼的情況。

1. **打開「頁面佈局」**
   - 點選工作表左下角的「頁面佈局」Tab 或 `Ctrl+P` 打開列印預覽。

2. **設定頁眉/頁腳**
   - 點選「頁眉/頁腳」>「頁眉」或「頁腳」。
   - 在需要的位置點擊「頁碼」圖示，選擇「插入頁碼」(`&P`)。  
   - 若想同時顯示「共 X 頁」則可使用 `&P / &N`。

3. **自訂格式（可選）**
   - 右鍵點擊頁眉/頁腳，選擇「自訂頁眉/頁腳」。
   - 在「頁碼」欄位輸入 `第 &P / &N 頁`，即可顯示「第 1 / 5 頁」。

4. **列印或輸出 PDF**
   - `Ctrl+P` → 設定完成，即可列印或儲存為 PDF。

> **注意**：此方式只在列印或 PDF 時顯示，若要在工作表中看到頁碼，請參考方案二或三。

---

## 方案二：在工作表中使用公式自動生成「第 X 頁」標示

適合需要在表格內部標示頁碼（例如長列表分頁）或輸出到 CSV、Excel 本身顯示的場景。

1. **決定列寬與每頁顯示行數**  
   - 例如：A 列為頁碼，假設每頁 50 行。

2. **輸入公式**  
   - 在 A2（假設第一行是標題）輸入以下公式：

     ```excel
     =IF(ROW()=1,"",INT((ROW()-2)/50)+1)
     ```

   - 說明：  
     - `ROW()` 取得當前行號。  
     - `-2` 讓第一行（標題）不算。  
     - `INT((ROW()-2)/50)+1` 計算第幾頁。

3. **複製公式**  
   - 將 A2 向下拖曳，直到資料結束。

4. **設定列印範圍**（若需要）  
   - `Ctrl+P` → 「列印區」設定，確保只列印需要的行。

> **變化**：若行數不是 50，可將公式中的 `50` 改為你的每頁行數。

---

## 方案三：使用 VBA 自動插入頁碼（多工作表、動態列印範圍）

當你需要更高級的控制（例如多工作表、不同列印區域、或一次性將頁碼寫進工作表）時，可以使用 VBA 來完成。

### 1. 打開 VBA 編輯器

```text
Alt + F11
```

### 2. 插入新模組

右鍵點擊「VBAProject (你的工作簿)」 → `Insert` → `Module`。

### 3. 複製以下程式碼

```vba
Sub InsertPageNumbers()
    Dim ws As Worksheet
    Dim rng As Range
    Dim pageStartRow As Long
    Dim rowsPerPage As Long
    Dim currentPage As Long
    Dim i As Long
    
    ' 每頁顯示的行數
    rowsPerPage = 50
    
    ' 循環所有工作表
    For Each ws In ThisWorkbook.Worksheets
        ' 先清除原有頁碼（假設在列 A）
        ws.Columns("A").ClearContents
        
        pageStartRow = 2 ' 假設第 1 行是標題
        currentPage = 1
        
        ' 以每 rowsPerPage 行為一頁，插入頁碼
        For i = pageStartRow To ws.Cells(ws.Rows.Count, "B").End(xlUp).Row
            If (i - pageStartRow) Mod rowsPerPage = 0 Then
                ws.Cells(i, 1).Value = "第 " & currentPage & " 頁"
                currentPage = currentPage + 1
            End If
        Next i
    Next ws
End Sub
```

### 4. 執行程式

```text
F5 或 Run > Run Sub/UserForm
```

> **說明**  
> - 這段程式會在每個工作表的 A 列寫入「第 X 頁」的標示。  
> - `rowsPerPage` 可自行調整。  
> - 若想在列印時自動分頁，可結合 `PageSetup` 屬性。

### 5. 進階：自動更新列印區域

如果你想在列印時自動將列印區域設定為每頁 50 行，可以使用以下程式碼：

```vba
Sub SetPrintAreaByPage()
    Dim ws As Worksheet
    Dim rowsPerPage As Long
    Dim lastRow As Long
    Dim i As Long
    
    rowsPerPage = 50
    
    For Each ws In ThisWorkbook.Worksheets
        lastRow = ws.Cells(ws.Rows.Count, "B").End(xlUp).Row
        For i = 1 To lastRow Step rowsPerPage
            ws.PageSetup.PrintArea = ws.Range("A1:B" & i + rowsPerPage - 1).Address
            ws.PrintOut ' 或者 ws.ExportAsFixedFormat Type:=xlTypePDF, Filename:="..."
        Next i
    Next ws
End Sub
```

> **提示**：在正式使用前，先在測試工作簿中執行，確認列印區域與頁碼符合預期。

---

## 常見問題解答（FAQ）

| # | 問題 | 解答 |
|---|------|------|
| 1 | **頁碼不會隨列印範圍變動更新** | 確認「列印區」已正確設定；若使用公式，確保公式覆蓋到所有列。 |
| 2 | **頁碼顯示為空白** | 在公式中檢查 `IF(ROW()=1,"",...)` 的條件；若工作表行數不足，公式可能會返回空值。 |
| 3 | **多工作表頁碼混亂** | 在 VBA 解決方案中，先清除原有頁碼，再重新插入；或在「頁眉/頁腳」中使用 `&[Sheet]` 顯示工作表名稱。 |
| 4 | **列印時頁碼顯示不同** | Excel 的「頁眉/頁腳」頁碼（&P）僅列印時顯示；若在工作表內使用公式，列印時會直接列印內容。 |
| 5 | **如何在 PDF 中保留頁碼** | 在列印預覽中選擇「Microsoft Print to PDF」或「Adobe PDF」輸出，頁眉/頁腳會自動保留。 |
| 6 | **頁碼格式需要「第X/共Y頁」** | 在「頁眉/頁腳」中輸入 `第 &P / &N 頁`；若使用公式，可自行組合字串：`="第 " & A2 & " / " & INT((lastRow-2)/rowsPerPage)+1 & " 頁"`。 |
| 7 | **VBA 失敗，出現錯誤 1004** | 檢查工作表名稱、列印區是否有效；確保範圍不超過工作表最大行數。 |
| 8 | **列印列數不一致，導致頁碼錯位** | 先在「頁面佈局」設定「列印標題」或「每頁行數」；可使用 `Worksheet.PageSetup.RowsToRepeatAtTop` 或 `PrintArea`。 |
| 9 | **希望在列印時顯示「第 X 頁」而不是「第 X / Y 頁」** | 在「頁眉/頁腳」中僅使用 `&P`；或在公式中只輸出 `="第 " & A2 & " 頁"`。 |
| 10 | **如何在單元格中顯示「合計 5 頁」** | 在任意單元格輸入公式：`="合計 " & INT((lastRow-2)/rowsPerPage)+1 & " 頁"`。 |

---

## 小結

- **方案一**：最簡單，適用於列印時需要頁碼。  
- **方案二**：在工作表內部使用公式，快速生成「第 X 頁」。  
- **方案三**：VBA 方案，適合多工作表、動態列印範圍或複雜排版需求。  

根據你的實際需求選擇適合的方案，並在列印前預覽確認頁碼正確。祝你使用愉快！