require File.join(File.dirname(__FILE__), "../lib/svm")

describe SVM::Problem do 
  before(:each) do
    #@model = [1,-1], [1,0,1], [0,0,1]
    @y = [1, -1]
    @x = [[0,2], [2]]
  end
  
  
  it 'should return the right results' do
    prob = SVM::Problem.new(@y, *@x)
    param = SVM::Parameter.new(:kernel_type => RBF, :C => 10)
    model = SVM::Model.new(prob, param)
    
    model.predict([2]).should == -1.0
    model.predict([0]).should == 1.0
  end
end