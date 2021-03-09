# handwritten-digits-recognition
Handwritten digits recognition using NN and Ruby 🧠💎

## About the project
This project is using neural network written in ruby for handwritten digits recognition. It is complete solution with frontend and backend parts.
Model was trained and tested on [MNIST](http://yann.lecun.com/exdb/mnist/) handwritten digits set converted into libsvm format dataset.
Set contains 60k train and 10k test examples.

![digits 0-9](https://github.com/jdrzj/handwritten-digits-recognition/raw/main/digits.gif)

## Instalation
Application is using [Rumale::Torch](https://github.com/yoshoku/rumale-torch), which requires to install [LibTorch](https://github.com/ankane/torch.rb#libtorch-installation):

### Running app with docker
Build image:
```bash
docker build -t hdr_app .
```
Run container:
```bash
docker run -p 4567:4567 hdr_app:latest
```
### Running app locally
For MacOS:

```bash
brew install automake libtorch
```
Then execute:
```bash
bundle install
```

For Linux please follow Dockerfile when installing libtorch.

## Model & training data
### Transforming data to libsvm format
Download MNIST file and extract it in `/utils` folder:

#### Downloading & etracting training set
```bash
cd utils/
wget https://www.csie.ntu.edu.tw/~cjlin/libsvmtools/datasets/multiclass/mnist.t.bz2
wget https://www.csie.ntu.edu.tw/~cjlin/libsvmtools/datasets/multiclass/mnist.bz2
bzip2 -d mnist.t.bz2 mnist.bz2
```

#### Prepare libsvm files
MNIST files does not contain zero values, which is problematic when using Rumale library. The simple fix is to fill it with zeros, and make sure we have 784 values (28x28 pixels) in one line. For that there is script:

```bash
// in utils/
ruby fill_libsvm_with_zeros.rb mnist
ruby fill_libsvm_with_zeros.rb mnist.t
```

##### Libsvm files
Libsvm files contain datas in multiple lines with format:

```
<label> <index1>:<value1> <index2>:<value3> ...
.
.
.
```

For MNIST data which are just 28x28 pixels images of digits index is the position of pixel (`x=index%size`, `y=floor(index/size)`) and value is color of pixel (0-white, 255-black).

### Training & testing model
#### Training model
Now you can start training with `train.rb` script.
```bash
// in utils/
ruby train.rb
```

Mind that it has parameters such as:
- batch_size
- max_epoch
- validation_split
- layers

For training you can tweak them and see how it impacts the learning process and accuracy.

#### Testing model
To test model simply run:
```bash
// in utils/
ruby test.rb
```

Make sure scipt is using the right model file, and NN has the same dimensions as in training.

#### Using different model in app
To use you own model copy your .dat and .pth file to models folder, and rename it to `model.dat` and `model.pth`.
The default model has ~97% accuracy.