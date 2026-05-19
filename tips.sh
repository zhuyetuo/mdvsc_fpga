# 构建并启动
docker-compose build --no-cache
docker-compose up -d
docker exec -it mdvsc-vitis-ai-dev /bin/bash

# ── 容器内 ──
# 验证工具是否存在
# 先激活 pytorch 环境
conda activate vitis-ai-pytorch
export PATH=/opt/vitis_ai/conda/envs/vitis-ai-pytorch/bin:$PATH
vai_c_xir --help   # 应该有输出了
which vai_q_pytorch          # 应该有输出
vai_q_pytorch --help

# 查看 VCK190 的 arch.json 是否存在
ls /opt/vitis_ai/compiler/arch/DPUCVDX8G/VCK190/

# 量化（PTQ）
python quantize.py           # 见上一条消息的模板

# 编译为 VCK190 的 xmodel
vai_c_xir \
  --xmodel  ./quantized/your_model_int.xmodel \
  --arch    /opt/vitis_ai/compiler/arch/DPUCVDX8G/VCK190/arch.json \
  --output_dir ./compiled \
  --net_name  my_model