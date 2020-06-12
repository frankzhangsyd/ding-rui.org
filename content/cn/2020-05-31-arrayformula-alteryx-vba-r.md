---
title: Excel 数组公式 , Alteryx, VBA 与R
author: Frank
date: '2020-05-31'
slug: arrayformula-alteryx-vba-r
categories: []
tags: []
---

这个星期来PwC上班以后，第一次又重新干起了老本行，写VBA和做template （Excel Based）。

做template，最痛苦的事，莫过于design你的template。一方面要囊括尽可能多的，有用的信息给用户，另一方面又要考虑用户会怎么会去使用你的template (这一点我在悉尼大学工作的时候和Casey同学学习到了很多)。PwC又尤其注重你的效率，所以还得考虑到后续的功能增删所耗费的时间与精力。总之让我深刻体验到了，在非码农部门coding的痛苦。

1. 没有产品设计手册
咱们就来简化一点，也别来个手册文档了，能把要求说清楚就不错了，更别提能老老实实写在纸面上而且保证后面不赖账。说多了都是泪
2. 不合理的预期
Coding 并不是万能药，尤其是在这么一个快节奏的工作环境，经常就是4,5个小时内就要开发完成，想想看这也不太可能。更别提VBA那个屎一样的coding 感受，真是欲仙欲死。

吐槽完毕，开始聊聊我觉得有意识的地方。

## 数组公式

好久没写数组公式了，这几天才反应过来，数组公式和R其实写起来感觉差不多，尤其如果你比较习惯R里面向量化的写法的话。

<!--more-->

这是数组公式
`=SUM(A1:B7)`
这是R
`sum(x*y)`

这是数组公式
`=IF(B1:B8<>"Target",ROW(B1:B8),"")`
这是R
``` r
x <- c("Target", "a", "Target", "c", "Target", "a", "Target", "c")

which(x == "Target")
#> [1] 1 3 5 7
```
还是挺有意思的，逻辑都是对整个数组同时进行操作，只不过数组公式debug不太方便，一步步拆开检查

## Alteryx

自从一月份入职以来，我已经憋了好几百字的草稿吐槽Alteryx，准备啥时候好好写一写。

Alteryx最大的问题，就是操作的精细度不够。所有的东西都是一个数据框，一列。诚然，这对非技术背景的，非常友好。但是会有一些edge case, 超级蛋疼。

这和R里面的tidyverse是差不多的, tidyverse的管道传递的也是数据框, 但是R里面不只有tidyverse, R里面还可以操作到向量 - aka vector 这个级别。

举个例子，
Input data


| Emp|Job | Grade|
|---:|:---|-----:|
|   1|a   |     6|
|   1|b   |     7|
|   1|b   |     8|
|   2|c   |     4|
|   2|d   |     5|

期待的结果

| Emp|Job        |Grade               |
|---:|:----------|:-------------------|
|   1|a &#124; b |6 &#124; 7 &#124; 8 |
|   2|c &#124; d |4 &#124; 5          |

逻辑非常简单，按照Emp进行group by, 然后把所有Job和Grade的列都合并起来。

要是在Alteryx里面做，那可是真是要了亲命了，你需要无数个summarise tool, 先
1. group by (Emp+Job) + group by Emp + Concat Job
2. group by (Emp+Grade) + group by Emp + Concat Grade
3. 把1,2的结果，join on  Emp

要是你有很多个field需要这样做（我指的是Job, Grade这样的），那你就等着哭吧，我有一次至少花了半个多小时来处理一个50多列的数据。

要是换了R，一句代码搞定，管你后面有多少个column呢
``` r
library(data.table)
setDT(dt) 

dt
#>    Emp Job Grade
#> 1:   1   a     6
#> 2:   1   b     7
#> 3:   1   b     8
#> 4:   2   c     4
#> 5:   2   d     5

dt[,lapply(.SD, function(x) paste0(unique(x),collapse = " | ")),by=.(Emp),.SDcols=2:3]
#>    Emp   Job     Grade
#> 1:   1 a | b 6 | 7 | 8
#> 2:   2 c | d     4 | 5
```

当然了，R的学习曲线比Alteryx陡峭许多，比如上面这个代码，至少小白会问出这么几个问题，啥是`lapply`,`.SD`,`.SDcols`? 

所以，每个工具都有自己的使用场景。Alteryx在PwC这种服务行业，不追求data钻研的深度，只追求按时deliver 一定quality的result, Alteryx恐怕还真是最好的选择。更别提每年超高的流失率，要是真的用R或者Python，那就估计以后只能招带着技能进组的新人了。实话实说，R和Python这种东西，就是会用的人，觉得很好用，不会coding,那就是百无一用。

希望以后还是能去一个能够对data钻研较深的位置，乙方有时候也不过就是工具人而已哈哈

## VBA

我对VBA还是很有感情的，毕竟我的第一门coding lannguage就是VBA （很不可思议吧，作为一个传统会计背景出身的人，这个选择还是很正确的）。我也是靠着VBA的技能，在澳洲找到了第一份实习，而且很不幸（？？？），后续的每一份工作都用到了VBA。之前在悉尼大学的短暂工作，也是靠着VBA技能与会计的双重背景，得到了这个机会。

VBA说起来也很有意思，PwC的working paper竟然是based on 一个个macro上的，是的，你没有看错，就是一个个xlsm文件。我现在觉得还有些不可思议 LOL

话说回来，VBA的缺点实在太多了，比如落后了一个世纪的VBE Editor，手动`debug.print` 打断点的痛苦，莫名其妙的报错。。。要说我能说一个晚上都不带停嘴的,以后慢慢吐槽吧。





