cd spconv
git checkout abf0acf30f5526ea93e687e3f424f62d9cd8313a
git submodule update --init --recursive

# Modify setup.py to handle PyTorch version parsing
sed -i '26s/PYTORCH_VERSION = list(map(int, PYTORCH_VERSION.split(".")))/PYTORCH_VERSION = [int(v.split("post")[0]) for v in PYTORCH_VERSION.split(".")[:3]]/' setup.py

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