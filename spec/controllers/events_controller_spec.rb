require 'spec_helper'

describe EventsController do

  describe "GET show" do
    let(:event) { mock_model(Event, :name => "Event Name") }
    let(:presentation) { mock_model(Presentation, :created_at => '') }

    before do
      Event.stub(:find).and_return(event)
    end

    it "finds event and assigns for the view" do
      get :show, :id => "37"
      assigns[:event].should == event
    end
    
    describe "with HTML" do
      it "succeeds" do
        get :show, :id => "37"
        response.should be_success
      end

      it "renders the correct template" do
        get :show, :id => "37"
        response.should render_template(:show)
      end
    end
    
    describe "with RSS" do
      it "should be redirect" do
        get :show, :id => "37", :format => :rss
        response.should be_redirect
      end

      it "returns a moved permanently response code" do
        get :show, :id => "37", :format => :rss
        response.status.should == 301
        response.status_message.should == "Moved Permanently"
      end
    end

    describe "with ATOM" do
      before do
        event.stub(:presentations).and_return([presentation])
      end

      it "succeeds" do
        get :show, :id => "37", :format => :atom
        response.should be_success
      end
    end
  end
end
