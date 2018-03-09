# mlprediction
# Restaurant Visitor Prediction using Machine Learning Algorithm

# Project Overview
This project was intended to go deeper into machine learning prediction aglorithms and implement it to predict the number of visitors to the restaurant on a particular given day.
The dataset used for this project was taken from kaggle website.

# Approach and steps performed to predict the restaurant visitors

# Step 1 Data cleaning and processing
1. In this step first checked for the inaccurate and missing data records for different csv files.
2. Replaced and modified the incorrect data with the mean data, also normailzed the data records for smooth accuracy in prediction at later stage.
3. Dataset consists of data from two websites so the data needs to be merged to apply ML algorithm over combined data. Dataset was large enough so used the Hadoop Mapreduce to perform normalization and merging of the data of the two websites.

# Step 2 Regression Analysis of data 
1. Performed regression analysis on the dataset using R.
2. Plotted graphs and visual representation of different features in the dataset.
3. Studied the impact of the various features on the prediction of the number of visitors.
4. Using R studio performed Time Series Prediction, also using the Facebook Prophet API for future prediction.

# Step 3 Building the Training Model
1. Developed the training model using Microsoft Azure ML API
2. Based on the regression analysis selected the list of features to be considered for the training model.
3. Considered the 75% of the data for training model and 25 % for the test data.
4. Used different ML algorithms for prediction such as Linear Regression, Logistic Regression and Neural Networks.

# Step 4 Performing ML algorithm over the Training dataset to predict restaurant visitors
1. Based on the training model created, the prediction on the test data was performed and its results were noted.
2. Different parameters such as mean error, root mean square error , accuracy were taken into consideration to select the best possible ML algorithm for prediction.
3. Prediction results were good for Neural Network ML algorithm with accuracy of about 74%

# Step 5 Hosting and Deployment of Application 
1. A Nodejs application was created so that end user can use it where they just need to enter the restaurant name and a date to predict the number of visitors on that date.
2. Application was hosted on the AWS EC2 instance using A Docker image.


