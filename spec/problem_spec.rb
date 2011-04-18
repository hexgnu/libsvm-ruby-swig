require File.join(File.dirname(__FILE__), "../lib/hex-svm")

describe SVM::Problem do 
  before(:each) do
    #@model = [1,-1], [1,0,1], [0,0,1]
    @y = [1, -1]
    @x = [[0,2], [2]]
    
    prob = SVM::Problem.new(@y, *@x)
    param = SVM::Parameter.new(:kernel_type => LINEAR, :C => 10)
    @model = SVM::Model.new(prob, param)
  end
  
  
  it '0,1,2 should retrieve 1' do
    @model.predict([0,1,2], 3).should == 1.0
  end
  
  it '' do
    @model.predict([2], 3).should == -1.0
  end
  
  it '' do
    @model.predict([], 3).should == -1.0
  end
  
  it '' do
    @model.predict([0], 3).should == 1.0
  end
end