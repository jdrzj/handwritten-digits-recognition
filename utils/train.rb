require 'rumale'
require 'rumale/torch'
require './neural_network'
require 'pry'


Torch.manual_seed(1)
device = Torch.device('cpu')
puts 'Loading dataset...'

x, y = Rumale::Dataset.load_libsvm_file('mnist')

batch_size = 8000
layers = [800]
validation_split = 0.1
max_epoch = 10

puts 'Training started parameters'
puts "batch_size: #{batch_size}, max_epoch: #{max_epoch}, validation_split: #{validation_split}, layers: #{layers}"

net = NeuralNetwork.new(784, 10, layers).to(device)

classifier = Rumale::Torch::NeuralNetClassifier.new(
  model: net,
  device: device,
  batch_size: batch_size,
  max_epoch: max_epoch,
  validation_split: validation_split,
  verbose: true
)

classifier.fit(x, y)
Torch.save(net.state_dict, "model_pd_#{batch_size}_#{max_epoch}_#{validation_split}_layer_#{layers.join('|')}.pth")
File.binwrite("model_pd_#{batch_size}_#{max_epoch}_#{validation_split}_layer_#{layers.join('|')}.dat",
              Marshal.dump(classifier))

puts 'Model files saved'
