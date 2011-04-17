module SVM
  class Model
    attr_accessor :model
  
    def initialize(arg1,arg2=nil)
      if arg2 == nil
        # create model from file
        filename = arg1
        @model = svm_load_model(filename)
      else
        # create model from problem and parameter
        prob,param = arg1,arg2
        @prob = prob
        if param.gamma == 0
          param.gamma = 1.0/prob.maxlen
        end
        msg = svm_check_parameter(prob.prob,param.param)
        raise ::ArgumentError, msg if msg
        @model = svm_train(prob.prob,param.param)
      end
    
      #setup some classwide variables
      @nr_class = svm_get_nr_class(@model)
      @svm_type = svm_get_svm_type(@model)
      #create labels(classes)
      intarr = new_int(@nr_class)
      svm_get_labels(@model,intarr)
      @labels = _int_array_to_list(intarr, @nr_class)
      delete_int(intarr)
      #check if valid probability model
      @probability = svm_check_probability_model(@model)

    end
  
    def predict(x)
      data = _convert_to_svm_node_array(x)
      ret = svm_predict(@model,data)
      svm_node_array_destroy(data)
      return ret
    end
  
  
    def get_nr_class
      return @nr_class
    end
  
    def get_labels
      if @svm_type == NU_SVR or @svm_type == EPSILON_SVR or @svm_type == ONE_CLASS
        raise TypeError, "Unable to get label from a SVR/ONE_CLASS model"
      end
      return @labels
    end
  
    def predict_values_raw(x)
      #convert x into svm_node, allocate a double array for return
      n = (@nr_class*(@nr_class-1)/2).floor
      data = _convert_to_svm_node_array(x)
      dblarr = new_double(n)
      svm_predict_values(@model, data, dblarr)
      ret = _double_array_to_list(dblarr, n)
      delete_double(dblarr)
      svm_node_array_destroy(data)
      return ret
    end
  
    def predict_values(x)
      v=predict_values_raw(x)
      #puts v.inspect
      if @svm_type == NU_SVR or @svm_type == EPSILON_SVR or @svm_type == ONE_CLASS
        return v[0]
      else #self.svm_type == C_SVC or self.svm_type == NU_SVC
        count = 0
      
        # create a width x height array
        width = @labels.size
        height = @labels.size
        d = Array.new(width)
        d.map! { Array.new(height) }
      
        for i in (0..@labels.size-1)
          for j in (i+1..@labels.size-1)
            d[@labels[i]][@labels[j]] = v[count]
            d[@labels[j]][@labels[i]] = -v[count]
            count += 1
          end
        end
        return d
      end
    end
  
    def predict_probability(x)
      #c code will do nothing on wrong type, so we have to check ourself
      if @svm_type == NU_SVR or @svm_type == EPSILON_SVR
        raise TypeError, "call get_svr_probability or get_svr_pdf for probability output of regression"
      elsif @svm_type == ONE_CLASS
        raise TypeError, "probability not supported yet for one-class problem"
      end
      #only C_SVC,NU_SVC goes in
      if not @probability
        raise TypeError, "model does not support probabiliy estimates"
      end
    
      #convert x into svm_node, alloc a double array to receive probabilities
      data = _convert_to_svm_node_array(x)
      dblarr = new_double(@nr_class)
      pred = svm_predict_probability(@model, data, dblarr)
      pv = _double_array_to_list(dblarr, @nr_class)
      delete_double(dblarr)
      svm_node_array_destroy(data)
      p = {}
      for i in (0..@labels.size-1)
        p[@labels[i]] = pv[i]
      end
      return pred, p
    end
  
    def get_svr_probability
      #leave the Error checking to svm.cpp code
      ret = svm_get_svr_probability(@model)
      if ret == 0
        raise TypeError, "not a regression model or probability information not available"
      end
      return ret
    end
  
    def get_svr_pdf
      #get_svr_probability will handle error checking
      sigma = get_svr_probability()
      return Proc.new{|z| exp(-z.abs/sigma)/(2*sigma)}  # TODO: verify this works
    end
  
    def save(filename)
      svm_save_model(filename,@model)
    end
  
    def destroy
      svm_destroy_model(@model)
    end
  end
end