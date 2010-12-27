require 'spec_helper'

describe SpeakersController do
  describe "GET index" do
    let(:speakers) { mock_model(Speaker) }

    before do
      Speaker.stub_chain(:order, :limit).and_return(speakers)
    end

    it "succeeds" do
      get :index
      response.should be_success
    end

    it "finds speakers and assigns for the view" do
      get :index
      assigns[:speakers].should == speakers
    end
  end

  describe "GET show" do
    let(:speaker) { mock_model(Speaker, :name => 'Matt') }
    let(:presentations) { [mock_model(Presentation, :created_at => Time.now)] }

    before do
      Speaker.stub(:find).with("37").and_return(speaker)
      speaker.stub_chain(:presentations, :released).and_return(presentations)
    end

    it "assigns the requested speaker as @speaker" do
      get :show, :id => "37"
      assigns(:speaker).should be(speaker)
    end

    it "assigns the speakers released presentations for the view" do
      get :show, :id => "37"
      assigns[:speaker_presentations].should == presentations
    end

    describe "with HTML" do
      it "succeeds" do
        get :show, :id => "37"
        response.should be_success
      end

      it "should render the show template" do
        get :show, :id => "37"
        response.should render_template(:show)
      end
    end

    describe "with ATOM" do
      it "succeeds" do
        get :show, :id => "37", :format => :atom
        response.should be_success
      end
    end

    describe "with RSS" do
      it "succeeds" do
        get :show, :id => "37", :format => :rss
        response.should be_redirect
      end
    end
  end

end
