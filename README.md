# mdvsc_fpga



```
mdvsc_fpga/
├── ai/                      # AI 工程师：模型 + 量化 + AIE 部署
│   ├── model/               # PyTorch 原始模型
│   │   ├── __init__.py
│   │   ├── config.py         # 模型参数配置（通道数、层数）
│   │   ├── encoder.py        # 图像 → 特征向量
│   │   ├── decoder.py        # 向量 → 图像
│   │   ├── temporal_comp.py  # 时序压缩（GOP 帧间处理）
│   │   ├── vq_model.py       # PyTorch 版 VQ 量化（训练用）
│   │   └── utils.py          # 数据预处理、张量工具
│   │
│   ├── quantize/            # 模型量化 + 权重导出
│   │   ├── quantizer.py      # INT8 量化逻辑
│   │   ├── calibrate.py      # 校准数据统计
│   │   ├── export_weights.py # 导出权重为 .bin/.coe
│   │   ├── export_scale.py   # 导出每层量化参数
│   │   ├── quant_info.json   # 量化参数表
│   │   └── weights/          # 输出权重文件
│   │       ├── encoder_w.bin
│   │       ├── decoder_w.bin
│   │       └── vq_codebook.bin
│   │
│   ├── aie/                 # AIE 引擎 C++ 代码
│   │   ├── graph.cpp         # AIE 总流程图（Encoder+Decoder 连接）
│   │   ├── graph.hpp
│   │   ├── kernels/          # 算子核函数
│   │   │   ├── encoder_kernel.cpp
│   │   │   ├── decoder_kernel.cpp
│   │   │   ├── conv2d.cpp
│   │   │   ├── relu.cpp
│   │   │   └── downsample.cpp
│   │   ├── include/
│   │   │   ├── params.h
│   │   │   └── kernels.h
│   │   └── Makefile
│   │
│   └── deploy/              # 最终交付给硬件工程师的文件
│       ├── aie.xclbin       # AIE 编译后的固件
│       ├── aie.aie          # AIE 指令
│       ├── weights.bin      # 最终权重
│       ├── interface.md     # 输入输出接口说明（必须！）
│       └── readme.md        # 集成说明
│
├── fpga/                    # 硬件/外围工程师：视频 + 接口 + 控制
│   ├── hls/                 # HLS C++ 模块（不用写 Verilog）
│   │   ├── vq_quantizer.cpp # VQ 量化
│   │   ├── vq_dequant.cpp   # 解量化
│   │   ├── bsc_channel.cpp  # BSC 误码信道
│   │   ├── frame_buffer.cpp  # 帧缓存控制
│   │   └── config.h
│   │
│   ├── ip/                  # 官方 IP 核（自动生成）
│   │   ├── axi_dma/
│   │   ├── fifo_generator/
│   │   ├── video_dma/
│   │   └── bram_ctrl/
│   │
│   ├── top/                 # 顶层集成
│   │   ├── top.v            # 顶层 Verilog/SV
│   │   ├── bd/              # Block Design 图形文件
│   │   └── constraints.xdc  # 时序约束
│   │
│   └── constraints/         # 引脚、时钟约束
│       ├── pins.xdc
│       └── timing.xdc
│
├── host/                    # 上位机控制
│   ├── host.cpp             # C++ 控制程序
│   ├── test.py              # Python 测试
│   ├── config.ini           # 参数配置
│   └── Makefile
│
├── scripts/                 # 自动化脚本
│   ├── build_aie.sh
│   ├── build_fpga.tcl
│   ├── deploy.sh
│   └── quantize.sh
│
├── test/                    # 测试数据
│   ├── 1080p_test.yuv
│   ├── ref_frame.yuv
│   └── output_result.yuv
│
└── README.md                # 项目说明
```





AI 工程师只需要交付 3 样东西：
量化后的权重（.bin）
AIE 编译好的固件（.xclbin/.aie）
接口说明（输入输出格式）   
硬件工程师拿到后，只做 4 件事：
读入视频
送给 AIE
做 VQ 量化 + BSC 信道
输出重建视频
