# Transform .tck to .trk

## **create environment**

### `cd /GPFS/cuizaixu_lab_permanent/wangmiao/app_packages/`  % 进入DATA/目录再新建环境

### `conda create -n tck2trk python==3.8` % 新建python3.8环境，名字任意

![image](https://user-images.githubusercontent.com/52966164/199166581-2abe8a5c-e8b6-4d74-8164-9909b84aa550.png)

### `conda activate tcktrk` % 激活环境

### `pip install nibabel` % 安装需要的包

![image](https://user-images.githubusercontent.com/52966164/199166759-564d25fc-ab75-47bf-bbec-98f3f4055acd.png)

## **Use tck2trk**

### `cp -r app-convert-tck-to-trk /GPFS/cuizaixu_lab_permanent/wangmiao/app_packages/`

![image](https://user-images.githubusercontent.com/52966164/199167019-0519b5af-768c-4560-93f9-dab5f6e3fc1e.png)

### 将config.json内的tck文件路径和dwi文件路径改成待处理的数据所在路径

### 在activate tcktrk 的环境中执行 `python convert_tck_to_trk.py`
