module SVM
  class Parameter
    attr_accessor :param
  
    def initialize(*args)
      @param = Svm_parameter.new
      @param.svm_type = C_SVC
      @param.kernel_type = RBF
      @param.degree = 3
      @param.gamma = 0    # 1/k
      @param.coef0 = 0
      @param.nu = 0.5
      @param.cache_size = 100
      @param.C = 1
      @param.eps = 1e-3
      @param.p = 0.1
      @param.shrinking = 1
      @param.nr_weight = 0
      #@param.weight_label = _int_array([])
      #@param.weight = _double_array([])
      @param.probability = 0
    
      args[0].each {|k,v| 
        self.send("#{k}=",v)
      } if !args[0].nil?
    end
  
    def method_missing(m, *args)
      if m.to_s == 'weight_label='
        @weight_label_len = args[0].size
        pargs = _int_array(args[0])
        _free_int_array(@param.weight_label)
      elsif m.to_s == 'weight='
        @weight_len = args[0].size
        pargs = _double_array(args[0])
        _free_double_array(@param.weight)
      else
        pargs = args[0]
      end
    
      if m.to_s.index('=')
        @param.send("#{m}",pargs)
      else
        @param.send("#{m}")
      end
    
    end
  
    def destroy
      _free_int_array(@param.weight_label)
      _free_double_array(@param.weight)
      #delete_svm_parameter(@param)
      @param = nil
    end
  end
end