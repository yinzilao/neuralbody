### Set up the python environment

```
conda create -n neuralbody python=3.7
conda activate neuralbody

# make sure that the pytorch cuda is consistent with the system cuda
# e.g., if your system cuda is 10.0, install torch 1.4 built from cuda 10.0
pip install torch==1.4.0+cu100 -f https://download.pytorch.org/whl/torch_stable.html

pip install -r requirements.txt

# fixing pip install issues, scikit-image removed from the requirements.txt
pip install "numpy>=1.15.4,<1.17"
pip install "Cython>=0.23.4"
pip install --no-binary :all: "scikit-image>=0.14.2,<0.15"
pip install --upgrade trimesh
pip uninstall PIL
pip uninstall Pillow
pip install Pillow
pip install --upgrade imageio

# install spconv
cd
git clone https://github.com/traveller59/spconv --recursive
cd spconv
git checkout abf0acf30f5526ea93e687e3f424f62d9cd8313a
git submodule update --init --recursive
export CUDA_HOME="/usr/local/cuda-10.0"
python setup.py bdist_wheel
cd dist
pip install spconv-1.2.1-cp36-cp36m-linux_x86_64.whl
```

### Set up datasets

#### People-Snapshot dataset

1. Download the People-Snapshot dataset [here](https://graphics.tu-bs.de/people-snapshot).
2. Process the People-Snapshot dataset using the [script](https://github.com/zju3dv/neuralbody#process-people-snapshot).
3. Create a soft link:
    ```
    ROOT=/path/to/neuralbody
    cd $ROOT/data
    ln -s /path/to/people_snapshot people_snapshot
    ```

#### ZJU-Mocap dataset

1. If someone wants to download the ZJU-Mocap dataset, please fill the [form](https://docs.google.com/forms/d/1QcTp5qIbIBn8PCT-EQgG-fOB4HZ9khpRkT3q2OnH2bs) to obtain the download link. Another way is filling in the [agreement](https://pengsida.net/project_page_assets/files/ZJU-MoCap_Agreement.pdf) and emailing me (pengsida@zju.edu.cn) and cc Xiaowei Zhou (xwzhou@zju.edu.cn) to request the download link.
2. Create a soft link:
    ```
    ROOT=/path/to/neuralbody
    cd $ROOT/data
    ln -s /path/to/zju_mocap zju_mocap
    ```
