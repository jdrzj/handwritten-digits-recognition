
require "rumale"
require "rumale/torch"
require "./neural_network.rb"

Torch.manual_seed(1)
device = Torch.device('cpu')

layers = [800]
net = NeuralNetwork.new(784, 10, layers).to(device)
net.load_state_dict(Torch.load('model_pd_8000_10_0.1_layer_800.pth'))

# Loading classifier.
classifier = Marshal.load(File.binread('model_pd_8000_10_0.1_layer_800.dat'))
classifier.model = net

# Loading test dataset.
x_test, y_test = Rumale::Dataset.load_libsvm_file('mnist.t')

# Predict labels of test data.
p_test = classifier.predict(x_test)

# Evaluate predicted result.
accuracy = Rumale::EvaluationMeasure::Accuracy.new.score(y_test, p_test)
puts(format("Accuracy: %2.2f%%", accuracy * 100))
