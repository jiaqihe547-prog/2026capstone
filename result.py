# -*- coding: utf-8 -*-
"""
Created on Mon Apr 13 16:28:05 2026

@author: TEST
"""

# 导入依赖库
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib import rcParams

# -------------------------- 全局学术风格设置（英文论文标准） --------------------------
# 设置全局字体为Times New Roman，符合英文学术论文规范
rcParams['font.family'] = 'Times New Roman'
rcParams['font.size'] = 10
rcParams['axes.titlesize'] = 12
rcParams['axes.labelsize'] = 10
rcParams['xtick.labelsize'] = 9
rcParams['ytick.labelsize'] = 9
rcParams['legend.fontsize'] = 9
# 禁用网格线，设置矢量图导出
rcParams['axes.grid'] = False
rcParams['savefig.dpi'] = 600
rcParams['savefig.format'] = 'svg'  # 矢量图格式，Word/LaTeX通用

# -------------------------- 1. 数据读取与标准化 --------------------------

# 提取5组核心数据（完全匹配原始CSV）
# 1.1 基础测试核心指标
base_data = {
    'Metric': ['Total Executed Tasks', 'Total Execution Time (ms)', 'Task Success Rate', 'Exception Occurrences', 'Total Component Coverage'],
    'Value': [1755, 4048, 100, 0, 100]
}
df_base = pd.DataFrame(base_data)

# 1.2 全量UI组件执行占比
component_ratio_data = {
    'Component': ['Text', 'Button', 'Toggle', 'Blank', 'Image'],
    'Execution Times': [1346, 249, 112, 32, 16],
    'Proportion (%)': [76.70, 14.19, 6.38, 1.82, 0.91]
}
df_ratio = pd.DataFrame(component_ratio_data)

# 1.3 UI组件覆盖度对比
coverage_data = {
    'Component': ['Text', 'Button', 'Toggle', 'Blank', 'Image'],
    'Expected': [19, 3, 7, 1, 8],
    'Actual': [19, 3, 7, 1, 8]
}
df_coverage = pd.DataFrame(coverage_data)

# 1.4 双模块组件执行对比
module_data = {
    'Module': ['Main App', 'Main App', 'Main App', 'Main App', 'Service Card'],
    'Component': ['Text', 'Button', 'Toggle', 'Blank', 'Image'],
    'Execution Times': [1346, 249, 112, 32, 16]
}
df_module = pd.DataFrame(module_data)

# 1.5 Ability组件覆盖度
ability_data = {
    'Bundle': ['Main App Entry', 'Service Card Entry'],
    'Expected': [1, 1],
    'Actual': [1, 1]
}
df_ability = pd.DataFrame(ability_data)

# -------------------------- 2. 一键生成所有5张图 --------------------------
# 图1：核心测试概况条形图
plt.figure(figsize=(8, 5))
bars = plt.barh(df_base['Metric'], df_base['Value'], color='#003366')
# 高亮核心指标
bars[2].set_color('#cc0000')
bars[3].set_color('#cc0000')
# 添加数据标签
for bar in bars:
    width = bar.get_width()
    plt.text(width + 10, bar.get_y() + bar.get_height()/2,
             f'{width}', va='center', fontsize=10)
# 格式设置
plt.gca().invert_yaxis()
plt.xlabel('Value')
plt.title('Core Test Overview Metrics')
plt.tight_layout()
plt.savefig('Core_Metrics.svg', bbox_inches='tight')
plt.close()

# 图2：UI组件执行占比环形饼图
plt.figure(figsize=(6, 6))
wedges, texts, autotexts = plt.pie(
    df_ratio['Proportion (%)'],
    labels=df_ratio['Component'],
    autopct='%1.2f%%',
    pctdistance=0.85,
    wedgeprops=dict(width=0.4, edgecolor='white'),
    colors=['#003366', '#0066cc', '#6699cc', '#cccccc', '#666666']
)
plt.setp(texts, fontsize=10)
plt.setp(autotexts, fontsize=9)
plt.title('UI Component Execution Proportion')
plt.tight_layout()
plt.savefig('Component_Ratio.svg', bbox_inches='tight')
plt.close()

# 图3：UI组件覆盖度对比柱状图
plt.figure(figsize=(8, 5))
x = range(len(df_coverage['Component']))
width = 0.35
plt.bar([i - width/2 for i in x], df_coverage['Expected'], width, label='Expected Count', color='#cccccc')
plt.bar([i + width/2 for i in x], df_coverage['Actual'], width, label='Actual Covered Count', color='#003366')
# 添加数据标签
for i in x:
    plt.text(i - width/2, df_coverage['Expected'][i] + 0.3, f'{df_coverage["Expected"][i]}', ha='center', fontsize=9)
    plt.text(i + width/2, df_coverage['Actual'][i] + 0.3, f'{df_coverage["Actual"][i]}', ha='center', fontsize=9)
# 格式设置
plt.xticks(x, df_coverage['Component'])
plt.ylabel('Count')
plt.legend(loc='upper center', bbox_to_anchor=(0.5, -0.15), ncol=2)
plt.title('UI Component Coverage Verification')
plt.ylim(0, 22)
plt.tight_layout()
plt.savefig('Component_Coverage.svg', bbox_inches='tight')
plt.close()

# 图4：双模块组件执行对比条形图  ← 替换原来的这段代码
plt.figure(figsize=(8, 5))
# 按模块分组绘图
main_app = df_module[df_module['Module'] == 'Main App']
service_card = df_module[df_module['Module'] == 'Service Card']

y_main = list(range(len(main_app['Component'])))
y_card = [i + len(main_app) + 1 for i in range(len(service_card['Component']))]

plt.barh(y_main, main_app['Execution Times'], color='#003366', label='Main Application')
plt.barh(y_card, service_card['Execution Times'], color='#666666', label='Service Card')

# 添加数据标签
for i, v in enumerate(main_app['Execution Times']):
    plt.text(v + 10, y_main[i], f'{v}', va='center', fontsize=9)
for i, v in enumerate(service_card['Execution Times']):
    plt.text(v + 10, y_card[i], f'{v}', va='center', fontsize=9)

# 格式设置
all_y = y_main + y_card
all_labels = list(main_app['Component']) + list(service_card['Component'])
plt.yticks(all_y, all_labels)
plt.gca().invert_yaxis()
plt.xlabel('Execution Times')
plt.legend(loc='upper right')
plt.title('Module Component Execution Comparison')
plt.tight_layout()
plt.savefig('Module_Comparison.svg', bbox_inches='tight')
plt.close()

# 图5：Ability组件覆盖度柱状图
plt.figure(figsize=(6, 4))
x = range(len(df_ability['Bundle']))
width = 0.35
plt.bar([i - width/2 for i in x], df_ability['Expected'], width, label='Expected Count', color='#cccccc')
plt.bar([i + width/2 for i in x], df_ability['Actual'], width, label='Actual Covered Count', color='#003366')
# 添加数据标签
for i in x:
    plt.text(i - width/2, df_ability['Expected'][i] + 0.05, f'{df_ability["Expected"][i]}', ha='center', fontsize=9)
    plt.text(i + width/2, df_ability['Actual'][i] + 0.05, f'{df_ability["Actual"][i]}', ha='center', fontsize=9)
# 格式设置
plt.xticks(x, df_ability['Bundle'])
plt.ylabel('Ability Count')
plt.legend(loc='upper center', bbox_to_anchor=(0.5, -0.2), ncol=2)
plt.title('Ability Component Coverage Results')
plt.ylim(0, 1.5)
plt.tight_layout()
plt.savefig('Ability_Coverage.svg', bbox_inches='tight')
plt.close()

print("所有图片已生成完毕，均为SVG矢量图，保存在当前代码同目录下")