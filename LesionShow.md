# 准备部分：下载显示所需的工具和文件
  链接：https://pan.baidu.com/s/1VIbN0M2_j37QdtAjE1aPzw?pwd=1111 
  提取码：1111   
### 共有18位被试的数据和一个tool文件夹
### 注：其他3名被试由于数据质量问题无法得到纤维追踪的结果
### 注：excel上另外的被试目前没有原始数据
![image](https://user-images.githubusercontent.com/52966164/210580479-995edc2f-e0d3-4dda-937d-e246eac06e52.png)

# 第一部分：大脑多值mask + 纤维束
## 1. 打开大脑多值mask
### 被试文件夹里的文件如图所示
![image](https://user-images.githubusercontent.com/52966164/210581422-447467e7-4de1-471c-bf85-1dc6bcf8637a.png)
### 打开DOC0034-BrainBS.mz3文件
### 方式一：右键选择打开方式，选择surfice.exe
![image](https://user-images.githubusercontent.com/52966164/210583093-91463c99-786a-409f-aa19-85648d8eb032.png)

### 方式二：进入tool\surfice_windows\Surf_Ice文件夹，双击打开surfice.exe
![image](https://user-images.githubusercontent.com/52966164/210583977-1e9ff36f-e8bf-479c-ad80-c7b4a09e366c.png)
### 点击file-Open
![image](https://user-images.githubusercontent.com/52966164/210584446-4e6771ec-f9fb-4e3f-83f7-f89da4fc9295.png)
### 选择DOC0034-BrainBS.mz3
![image](https://user-images.githubusercontent.com/52966164/210584866-97bb920d-9824-450f-8b9b-426f5a4ee0c0.png)
![image](https://user-images.githubusercontent.com/52966164/210585058-48243585-3f18-454b-abb4-608ba1274252.png)

## 2. 调整大脑多值mask
### 2-1. 调整截面
![image](https://user-images.githubusercontent.com/52966164/210585593-8e6a1a38-6134-4a63-bc11-97a8bdd2efcd.png)
### 将以上参数调整到如下图所示
### 其中depth是指切割面深度，Azimuth是值绕垂直轴(z轴)切割面的角度，elevation是值绕水平轴(x轴)切割面的角度
![image](https://user-images.githubusercontent.com/52966164/210585809-15e1b393-5431-4023-98e2-c83d827fd8d2.png)
![image](https://user-images.githubusercontent.com/52966164/210585843-4ad1b953-549a-48aa-bf15-e625f63a09c8.png)
### 如果想看横截面而不是矢状面的界面，可以将参数调整如下图所示
![image](https://user-images.githubusercontent.com/52966164/210587117-02489745-402f-4de2-95f9-4cb35a96e33a.png)
![image](https://user-images.githubusercontent.com/52966164/210587147-8f8b751d-2104-4fdd-b811-bb9506261ff6.png)
![image](https://user-images.githubusercontent.com/52966164/210587221-13d1e8bb-a517-4d60-a1a5-e6a5cdba91ff.png)
![image](https://user-images.githubusercontent.com/52966164/210587267-18a7456a-ced2-4727-8490-b9a8d927d179.png)

### 2-2. 调整透明度
![image](https://user-images.githubusercontent.com/52966164/210587492-e7e70557-c8c5-4b52-bc2f-5d151888ec5f.png)
### 将以上参数调整到如下图所示
### 或根据需要调整得更浅或更深
![image](https://user-images.githubusercontent.com/52966164/210587607-2cd633c5-f68a-4bfc-a05e-e1e76dc08450.png)

## 3. overlay病灶
### 打开病灶数据，点击工具栏overlays-Add overlay，打开DOC0034-Lesion文件
### 注：一定要选择对应被试的文件夹，打开对应被试的数据！很容易忘记选这个被试的文件夹，而是在上一个被试文件夹选择数据
### 如果要关闭病灶，点击工具栏overlays-Close overlays
![image](https://user-images.githubusercontent.com/52966164/210588038-9e1d1337-b729-4c51-af91-17cd0aad4508.png)
![image](https://user-images.githubusercontent.com/52966164/210588425-b2e18809-e83b-495f-b3ba-3cde6de5a48a.png)
![image](https://user-images.githubusercontent.com/52966164/210588990-68b01e51-4c61-4c75-975f-da8d0570f7be.png)

## 4. 添加第一种纤维束
### 4-1. 第一种纤维束：这种纤维束是穿过脑干的纤维束种选取200根得到的(根数数目一定，长度不一定)，标记为num200
### 打开病灶数据，点击工具栏Tracks-Add tracks，打开track_sub-DOC0034_BS_num200.tck文件
### 注：一定要选择对应被试的文件夹，打开对应被试的数据！很容易忘记选这个被试的文件夹，而是在上一个被试文件夹选择数据
![image](https://user-images.githubusercontent.com/52966164/210589454-d69f27e5-dae7-4702-83cb-016ca26b585d.png)
![image](https://user-images.githubusercontent.com/52966164/210590180-c614efa4-7725-4be0-9adb-6486769989d8.png)
![image](https://user-images.githubusercontent.com/52966164/210590294-a2404202-29d0-4039-9d88-aedabdb4fedf.png)

## 4-2. 调整纤维束
### 调整纤维数量粗细和颜色
![image](https://user-images.githubusercontent.com/52966164/210590549-05314a5e-aebf-4dc4-ac97-eb84412d613d.png)
### 将以上参数调整到如下图所示
![image](https://user-images.githubusercontent.com/52966164/210590635-71a3cd62-3705-45c9-9c47-95126a564f6e.png)
![image](https://user-images.githubusercontent.com/52966164/210590713-b331995e-85e7-4b44-8518-8abd3bd9e548.png)
### 注：只有对于number 200筛选出的纤维数据才要把length调到最小，这个选项是在筛选长度大于特定值的纤维束。由于number200筛选的纤维束文件纤维数目少，不需要进一步筛选。

## 5. 添加第二种纤维束
### 5-1. 第二种纤维束：这种纤维束是穿过脑干的纤维束种选取长度>245mm得到的(根数数目不一定)，标记为minl245
### 关闭上一种纤维束，点击Tracks-Close tracks
### 打开病灶数据，点击工具栏Tracks-Add tracks，打开track_sub-DOC0034_BS_minl245.tck文件
### 注：一定要选择对应被试的文件夹，打开对应被试的数据！很容易忘记选这个被试的文件夹，而是在上一个被试文件夹选择数据
![image](https://user-images.githubusercontent.com/52966164/210592640-fc46d318-e850-4482-a205-3864b5b1fa2d.png)
![image](https://user-images.githubusercontent.com/52966164/210592521-f3cc6ae9-cb7a-4197-85ff-334995a34d19.png)

## 5-2. 调整纤维束
### 调整纤维数量粗细和颜色
![image](https://user-images.githubusercontent.com/52966164/210590549-05314a5e-aebf-4dc4-ac97-eb84412d613d.png)
### 将以上参数调整到如下图所示
### 注：对于minl245筛选出的纤维数据需要把length调到最大或比较大，因为minl245筛选出的纤维一般很多，会挡住视线。
![image](https://user-images.githubusercontent.com/52966164/210592788-e2ad24ee-be41-437c-9092-62bc030b319b.png)
![image](https://user-images.githubusercontent.com/52966164/210592849-da711d2b-9067-4952-9011-cbe6414ceacf.png)



# 第二部分：脑干mask + 纤维束
## 1. 打开脑干mask + 调整脑干mask
### 打开DOC0034-BS.mz3文件
![image](https://user-images.githubusercontent.com/52966164/210593689-5ed30686-4d10-4c08-b4a1-780ee7891aef.png)
### 方式一：右键选择打开方式，选择surfice.exe
### 方式二：进入tool\surfice_windows\Surf_Ice文件夹，双击打开surfice.exe，点击file-Open选择DOC0034-BS.mz3
![image](https://user-images.githubusercontent.com/52966164/210594080-e969ef91-75f3-4f4c-88de-3ec5fe868c34.png)

## 2. 调整脑干mask
### 2-1. 调整颜色
![image](https://user-images.githubusercontent.com/52966164/210594929-304f2b7a-e8cc-4263-b692-cb6beae77b32.png)

![image](https://user-images.githubusercontent.com/52966164/210597045-791979c5-dee5-477a-bafb-932a73153306.png)

### 将以上参数调整到如下图所示
![image](https://user-images.githubusercontent.com/52966164/210595008-54d969b7-578f-4fe7-97a4-16c1fc43bd7c.png)
![image](https://user-images.githubusercontent.com/52966164/210597158-63b23459-d39f-4bfb-8733-1ae0c27117e4.png)

### 2-2. 调整角度
### 把脑干摆到侧面
![image](https://user-images.githubusercontent.com/52966164/210595154-2b65aa78-95e9-4675-8525-340364bb4cba.png)

### 2-3. 调整截面
![image](https://user-images.githubusercontent.com/52966164/210585593-8e6a1a38-6134-4a63-bc11-97a8bdd2efcd.png)
### 将以上参数调整到如下图所示
### 其中depth是指切割面深度，Azimuth是值绕垂直轴(z轴)切割面的角度，elevation是值绕水平轴(x轴)切割面的角度
![image](https://user-images.githubusercontent.com/52966164/210585809-15e1b393-5431-4023-98e2-c83d827fd8d2.png)
![image](https://user-images.githubusercontent.com/52966164/210595505-0ba59bd5-2df6-4785-afc9-0c7f413c1abb.png)

### 如果想看横截面而不是矢状面的界面，可以将参数调整如下图所示
![image](https://user-images.githubusercontent.com/52966164/210596030-321f8fb4-e203-47b3-8bea-f33c0be83f10.png)

![image](https://user-images.githubusercontent.com/52966164/210595939-2d36925d-e86f-4088-bf05-b5e8a0afe043.png)

![image](https://user-images.githubusercontent.com/52966164/210596136-80fb4852-30e8-409e-90c0-5bc4f723226f.png)

## 3、4、5. overlay病灶、添加第一种纤维束、添加第二种纤维束
### 方法和第一部分完全一样
### 结果如下图所示
![image](https://user-images.githubusercontent.com/52966164/210596857-5cb4d00a-b8d2-433d-bacd-d2038939c2b8.png)

![image](https://user-images.githubusercontent.com/52966164/210596759-9df5a121-d07b-4f01-8b88-ec063cedf8af.png)
