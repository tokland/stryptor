require 'rails_helper'

describe StripsController, :type => :controller do
  render_views
  
  before do
    FactoryGirl.create(:strip_collection, :code => "snoopy")
    @strip_collection = FactoryGirl.create(:strip_collection, :code => "mafalda")
    @strip1 = FactoryGirl.create(:strip, :code => "001", :strip_collection => @strip_collection)
    @strip2 = FactoryGirl.create(:strip, :code => "002", :strip_collection => @strip_collection)
  end
  
  describe "#index" do
    before do
      get :index, :strip_collection_id => "mafalda"
    end
    
    it "redirect to the first strip of the collection" do
      expect(response).to redirect_to([@strip_collection, @strip1])
    end
  end

  describe "#show" do
    before do
      get :show, :strip_collection_id => "mafalda", :id => "001"
    end
    
    it { expects(response).to be_success }
    it { expects(response).to render_template(:show) }
  end

  describe "#random" do
    before do
      get :random, :strip_collection_id => "mafalda"
    end
  
    it "redirects to a random strip of the collection" do
      path1 = polymorphic_path([@strip_collection, @strip1])
      path2 = polymorphic_path([@strip_collection, @strip2])
      expect(response).to redirect_to(path1).or redirect_to(path2)
    end
  end
end
