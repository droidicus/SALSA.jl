validation_criteria(model::SALSAModel,X,Y,val_idx) = validation_criteria(model,X[val_idx,:],Y[val_idx])
validation_criteria{L <: Loss, A <: SGD}(model::SALSAModel{L,A},X,Y) = misclass(Y, predict_raw(model,X))
validation_criteria{L <: LEAST_SQUARES, A <: SGD}(model::SALSAModel{L,A},X,Y) = mse(Y, predict_raw(model,X))
validation_criteria{L <: Loss, A <: RDA}(model::SALSAModel{L,A},X,Y) = model.sparsity_cv*mean(model.output.w .!= 0) + (1-model.sparsity_cv)*misclass(Y, predict_raw(model,X))
validation_criteria{L <: LEAST_SQUARES, A <: RDA}(model::SALSAModel{L,A},X,Y) = model.sparsity_cv*mean(model.output.w .!= 0) + (1-model.sparsity_cv)*mse(Y, predict_raw(model,X))

validation_criteria{L <: Loss, A <: SGD}(model::SALSAModel{L,A}) = "misclassification rate"
validation_criteria{L <: LEAST_SQUARES, A <: SGD}(model::SALSAModel{L,A}) = "mean squared error"
validation_criteria{L <: Loss, A <: RDA}(model::SALSAModel{L,A}) = "weighted combination of: error/sparisty"