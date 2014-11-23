require 'rails_helper'

describe StripsController, :type => :controller do
  render_views
  
  it "renders the :index view" do
    strip = FactoryGirl.create(:strip)
    get :index, :strip_collection_id => strip.strip_collection.code
    expect(response).to redirect_to([strip.strip_collection, strip])
  end

  it "renders the :show view" do
    strip = FactoryGirl.create(:strip)
    get :show, :strip_collection_id => strip.strip_collection.code, :id => strip.code
    expect(response).to render_template(:show)
  end

  it "redirects to a random strip" do
    strip = FactoryGirl.create(:strip)
    get :random, :strip_collection_id => strip.strip_collection.code
    expect(response).to render_template(:show)
  end
end
