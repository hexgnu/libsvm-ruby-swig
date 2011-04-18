require File.join(File.dirname(__FILE__), '../ext/libsvm')
include Libsvm

%w[libsvm/problem libsvm/model libsvm/parameter].each do |r|
  require File.join(File.dirname(__FILE__), r)
end

# TODO: these are super weird should be inside of a module; extend self; end...


def _int_array(seq)
  size = seq.size
  array = new_int(size)
  i = 0
  for item in seq
    int_setitem(array,i,item)
    i = i + 1
  end
  return array
end

def _double_array(seq)
  size = seq.size
  array = new_double(size)
  i = 0
  for item in seq
    double_setitem(array,i,item)
    i = i + 1
  end
  return array
end

def _free_int_array(x)
  if !x.nil? and !x.empty?
    delete_int(x)
  end
end

def _free_double_array(x)
  if !x.nil? and !x.empty?
    delete_double(x)
  end
end

def _int_array_to_list(x,n)
  list = []
   (0..n-1).each {|i| list << int_getitem(x,i) }
  return list
end

def _double_array_to_list(x,n)
  list = []
   (0..n-1).each {|i| list << double_getitem(x,i) }
  return list
end    

def _convert_to_svm_node_array(x)
  # Make index array 
  iter_range = x.each_index.to_a
  
  data = svm_node_array(iter_range.length + 1)
  svm_node_array_set(data, iter_range.length, -1, 0)
  
  iter_range.each do |k|
    svm_node_array_set(data, k, k, x[k])
  end
  
  data
end

module SVM
  extend self
  
  def convert_to_svm_node_array(indicies, max) 
    # Make index array
    # x = indexes_to_array(indicies, max)
    # iter_range = x.each_index.to_a
    
    data = svm_node_array(indicies.length + 1)
    svm_node_array_set(data, indicies.length, -1, 0)
    
    # max.times do |i|
    #   # Set to zero if not in indicies
    #   if indicies.include?(i)
    #     svm_node_array_set(data, i, i, 1)
    #   else
    #     svm_node_array_set(data, i, i, 0)
    #   end
    # end
    
    indicies.sort.each_with_index do |idx, i|
      svm_node_array_set(data, i, idx, 1)
    end

    data
  end
end


def cross_validation(prob, param, fold)
  if param.gamma == 0
    param.gamma = 1.0/prob.maxlen
  end
  dblarr = new_double(prob.size)
  svm_cross_validation(prob.prob, param.param, fold, dblarr)
  ret = _double_array_to_list(dblarr, prob.size)
  delete_double(dblarr)
  return ret
end

def read_file filename
  labels = []
  samples = []
  max_index = 0

  f = File.open(filename)
  f.each do |line|
    elems = line.split
    sample = {}
    for e in elems[1..-1]
       points = e.split(":")
       sample[points[0].to_i] = points[1].to_f
       if points[0].to_i < max_index
          max_index = points[0].to_i
       end
    end
    labels << elems[0].to_i
    samples << sample
  end
  puts "#{filename}: #{samples.size} samples loaded."
  return labels,samples
end

