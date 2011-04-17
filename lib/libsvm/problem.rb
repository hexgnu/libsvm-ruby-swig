module SVM
  class Problem
    attr_accessor :prob, :maxlen, :size
    
    def initialize(y, *x)
      #assert y.size == x.size
      @prob = prob = Svm_problem.new 
      @size = size = y.size
    
      @y_array = y_array = new_double(size)
      y.each_with_index do |label, i|
        double_setitem(@y_array, i, label)
      end
    
      @x_matrix = x_matrix = svm_node_matrix(size)
      @data = []
      @maxlen = 0
      x.each_with_index do |row, i|
        data = _convert_to_svm_node_array(row)
        @data << data
        svm_node_matrix_set(x_matrix, i, data)
        @maxlen = [@maxlen, row.size].max
      end
    
      prob.l = size
      prob.y = y_array
      prob.x = x_matrix
    end
  
    def inspect
      return "Problem: size = #{size}"
    end
  
    def destroy
      delete_svm_problem(@prob)
      delete_double(@y_array)
      for i in (0..size-1)
        svm_node_array_destroy(@data[i])
      end
      svm_node_matrix_destroy(@x_matrix)
    end
  end
end