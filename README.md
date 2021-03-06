# handwritten-digits-recognition
Handwritten digits recognition using NN and Ruby 🧠💎

## About the project
This project is using neural network written in ruby for handwritten digits recognition.
Model was trained and tested on [MNIST](http://yann.lecun.com/exdb/mnist/) handwritten digits set converted into libsvm format dataset.
Set contains 60k train and 10k test examples.

## Instalation
Application is using [Rumale::Torch](https://github.com/yoshoku/rumale-torch), which requires to install [LibTorch](https://github.com/ankane/torch.rb#libtorch-installation):

### Building docker image
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

## Transforming data to libsvm format
todo

## Training model
todo
