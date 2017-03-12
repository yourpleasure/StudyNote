# Learn Vimscript the Hard Way

# 1.echo 消息  
echo: 回显消息  
echom: 回显消息，并将消息放入message中  
vim脚本注释: 使用双引号(")进行注释  

# 2.选项设置
vim中有两种类型的选项，boolean类型的选项和有其他值的选项。  
1. boolean类型选项示例: number  
    1. set number  
        * 显示行号
    2. set nonumber  
        * 不显示行号
    3. set number!  
        * 设置一个和当前选项相反的值
    4. set number?  
        * 查询当前number值
2. 有值类型选项示例: numberwidth  
    1. set numberwidth=10
        * 将numberwidth设置为10
    2. set numberwidth?
        * 查询当前的numberwidth值

# 3.映射
