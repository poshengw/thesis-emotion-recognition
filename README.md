# Using Support Vector Machine for </br> Emotion Classification in presence of Noise Label

### Overview
This research is implemented in [MATLAB](https://www.mathworks.com/products/matlab.html) and the facial expression dataset was provided by [Michael Lyons, Miyuki Kamachi, and Jiro Gyoba](http://www.kasrl.org/jaffe.html). There are 5 different emotions (Anger, Disgust, Happy, Sad and Neutral) we are targeting at and want to clasify. The goal of this thesis is to perform Support Vector Machine (SVM) classifier under the circumstance that the data true labels are ambiguous. This research proposed a facial expression **Multi-class Label Noise Robust SVMs framework** with 85% accuracy to overcome ambiguity and uncertainty in the data label. 


### Code
The [RunFile](https://github.com/poshengw/thesis-emotion-recognition/blob/master/RunFile.m) listed the workflow of this project. This research performed 
- **Feature extration**: Local Phase Quantization (LPQ), Pyramid Histogram of Oriented Gradients (PHOG), and Local Binary Patterns (LBP) 
- **Feature Dimensionality Reduction**: Principle Component Analysis (PCA).
- **Classification algorithm**: Multi-classes Support Vector Machine with different kernel and framework. 




