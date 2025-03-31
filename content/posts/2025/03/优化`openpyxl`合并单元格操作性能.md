---
title: "优化`openpyxl`合并单元格操作性能"
date: "2025-03-31T07:41:51Z"
draft: false
discussion_id: "D_kwDOCretjM4AfFYZ"
---

## **问题现象**
- 在使用`openpyxl`实现大规模单元格合并时发现，随着需要合并的区域增多，代码运行时间显著增加且性能下降。
- 对`sheet.merge_cells`的逐次调用占用了大量时间。

---

## **原因分析**
- 每次调用`sheet.merge_cells`，`openpyxl`会触发以下操作：
  1. 校验合并区域是否重复或冲突。
  2. 重建内部的单元格模型，维护读取、写入和引用的正确性。
- 当合并区域较多时，每次调用都需多次更新和校验，导致时间复杂度呈线性增长，同时增加了内部模型调整的开销。

---

## **解决方案**
为优化合并操作，可以**延迟合并**并通过直接批量构造合并区域的方式减少重复校验。

### **具体方法**
1. **记录需要合并的区域：**
   - 在遍历过程中，将需要合并的单元格区域收集为列表或集合（例如`start_row`和`end_row`）。
   - 合并区域可以根据列号（或其他索引）分组记录。

2. **构造合并区域对象：**
   - 使用`openpyxl.worksheet.cell_range.CellRange`提供的功能，直接创建每个合并区域（而非逐次调用`sheet.merge_cells`）。
   - 这种方式不会在每次添加时触发内部校验，而是在更新完成后一次性校验。

3. **批量更新合并集合：**
   - 利用`sheet.merged_cells.ranges.update()`方法一次性将所有合并区域提交到工作表中，避免逐次更新的性能开销。

4. **保存数据到文件：**
   - 使用`workbook.save()`将内存中的更新保存到文件，这一步进行实际的 I/O 操作。

---

## **优化代码示例**
```python
from openpyxl.utils import get_column_letter
from openpyxl.worksheet.cell_range import CellRange

# 假设需要合并的范围是下面的数据格式
merge_ranges = {"A": [(7, 10), (12, 15)], "B": [(7, 8), (9, 12)]}  # 各列对应的合并起止行
merged_cells = set()

# 构造所有合并区域
for col_letter, ranges in merge_ranges.items():
    for start, end in ranges:
        merged_cells.add(CellRange(f"{col_letter}{start}:{col_letter}{end}"))

# 将合并区域提交到 sheet
sheet.merged_cells.ranges.update(merged_cells)
```

---

## **效果和好处**
1. **性能提升：**
   - 原先逐个调用`merge_cells`的 O(n) 操作优化为一次性的批量提交，大幅降低了多次校验和模型重建的开销。
   - 对于大规模合并区域操作，代码执行时间从以分钟计降至几秒。

2. **保持表格内容不变：**
   - 使用`CellRange`可以生成与手动调用`merge_cells`完全一致的合并效果，不会改变最终表格结构。

3. **可扩展性：**
   - 此优化逻辑可以通用于记录大量单元格合并需求的场景，例如以数据驱动的动态表格生成。

---

## **场景适用性**
- 适用于任何需要大规模进行单元格合并的场景。
- 优化主要针对`openpyxl`中因多次调用`merge_cells`导致性能问题的情况，而不会影响表格的最终呈现效果。