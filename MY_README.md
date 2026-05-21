## Method

- Ttraining a test-to-video diffusion model

### temporally-persistent 4D point cloud
- video -> point cloud **P** (Depth Anything 3 (DA3) or Pi3X)
- video -> static mask **M** (Segment Anything 3 (SAM3))
- using **M** to select out the static pixel and related point cloud of **P**

### Conditioning on source videos and point clouds
1. point cloud render (from **B**)
2. warped alpha mask (from **M**)
3. video
- encode by VAE

## Env
### install
```
$ conda create --name vista4d python=3.10 -y
$ conda activate vista4d
$ pip install torch==2.10.0 torchvision==0.25.0 torchaudio==2.10.0 --index-url https://download.pytorch.org/whl/cu128
$ pip install -r requirements.txt

# install Flash Attention and XFuser 
### find gpu CUDA_ARCH
$ nvidia-smi --query-gpu=compute_cap --format=csv,noheader 
### replace TORCH_CUDA_ARCH_LIST to the number from previous command 
$ MAX_JOBS=1 TORCH_CUDA_ARCH_LIST="12.0" pip3 install flash-attn==2.8.3 --no-build-isolation -v
$ pip3 install "xfuser[flash-attn]==0.4.5"
```

### runpod
```
$ source venv/bin/activate
```

### moduel conflict
```
# for using old pkg_resources
$ pip install "setuptools<70.0.0"
```

## Inference

1. EXAMPLE=couple-newspaper RECON_METHOD=pi3 bash scripts/preprocess/example_recon_and_seg_single.sh
2. EXAMPLE=couple-newspaper RESOLUTION=720p bash scripts/preprocess/example_render_single.sh
3. EXAMPLE=couple-newspaper RESOLUTION=720p bash scripts/inference/example_inference_single.sh