## Residual neural network for binary classification of two fish species from hydroacoustic data.

# Load in the libraries
library(dplyr)
library(tidymodels)
library(vip)
library(keras)
library(rBayesianOptimization)
library(caret)
library(tensorflow)
library(kernelshap)
library(shapviz)
library(str2str)
library(ROCR)


# Fit the RNN. Currently, there is no cross validation implemented. 

set_random_seed(15)
rnn = keras_model_sequential() 
rnn %>%
  layer_lstm(input_shape=c(5,249),units = 249) %>%
  layer_activation_leaky_relu()%>%
  layer_batch_normalization()%>%
  layer_dense(units=150,activity_regularizer = regularizer_l2(1e-4))%>%
  layer_activation_leaky_relu()%>%
  layer_dense(units=75,activity_regularizer = regularizer_l2(1e-4))%>%
  layer_activation_leaky_relu()%>%
  layer_dense(units=38,activity_regularizer = regularizer_l2(1e-4))%>%
  layer_activation_leaky_relu()%>%
  layer_dense(units=19,activity_regularizer = regularizer_l2(1e-4))%>%
  layer_activation_leaky_relu()%>%
  layer_dense(units = 2, activation = 'sigmoid')


# look at our model architecture
summary(rnn)

#compile the model
rnn %>% compile(
  loss = loss_binary_crossentropy,
  optimizer = optimizer_adam(3e-4),
  metrics = c('accuracy')
)

# train the model
history <- rnn %>% fit(
  x_data_train_S, dummy_y_train_S,
  batch_size = 500, 
  epochs = 38,
  validation_data = list(x_data_validate_S,dummy_y_validate_S),
  class_weight = list("0"=1,"1"=2))

plot(history)

# evaluate performance on test data
evaluate(rnn, x_data_test, dummy_y_test) 

# extract test data classifications
preds<-predict(rnn, x=x_data_test)

species.predictions<-apply(preds,1,which.max)
species.predictions<-as.factor(ifelse(species.predictions == 1, "LT",
                                      "SMB"))
confusionMatrix(species.predictions,as.factor(y_data_test))

# plot the ROC curve

# put the data in the format necessary (bind the prediction for class SMB with the true labelled data) 
pred <- prediction(preds[,2], y_data_test)
# extract the performance of the model - true positive rate and false postive rate
perf <- performance(pred,"tpr","fpr")
# plot the ROC curve
ROC_PLOT<-plot(perf,colorize=TRUE,lwd=5)

ROC_PLOT<-ggplot()+
  geom_abline(slope=1, color="grey",size=2)+
  geom_point(aes(x=perf@x.values[[1]],y=perf@y.values[[1]],col=perf@alpha.values[[1]]))+
  scale_colour_gradientn(colors=rainbow(7),guide = guide_colorbar(
    barwidth = 0.5,barheight=15,title="threshold",ticks=T))+
  theme_classic()+
  xlab("False positive rate")+
  ylab("True positive rate")+
  theme(text=element_text(size=18))

ggsave(file="ROC.svg", plot=ROC_PLOT, width=6.5, height=5)
