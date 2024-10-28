cd spconv
git checkout abf0acf30f5526ea93e687e3f424f62d9cd8313a
git submodule update --init --recursive

# Modify setup.py to handle PyTorch version parsing
sed -i '26s/PYTORCH_VERSION = list(map(int, PYTORCH_VERSION.split(".")))/PYTORCH_VERSION = [int(v.split("post")[0]) for v in PYTORCH_VERSION.split(".")[:3]]/' setup.py


# Set CUDA architecture flags
export TORCH_CUDA_ARCH_LIST="6.0;6.1;7.0;7.5;8.0;8.6;8.9;8.9+PTX"

# Force CUDA build
export SPCONV_FORCE_BUILD_CUDA=1

# Rebuild spconv with the correct architecture
python setup.py clean

# Build the wheel
python setup.py bdist_wheel

# Check if the wheel was created and install it
WHEEL_FILE=$(ls dist/spconv-*.whl 2>/dev/null)
if [ -n "$WHEEL_FILE" ]; then
    pip install $WHEEL_FILE
else
    echo "Failed to build spconv wheel"
    exit 1
fi