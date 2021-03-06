require 'spec_helper'

describe Admin::SpeakersController do
  let(:user) { mock_model(User) }

  before do
    User.stub(:find).and_return(user)
    user.stub(:has_role?).and_return(true)
    sign_in user
  end

  def mock_speaker(stubs={})
    @mock_speaker ||= mock_model(Speaker, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all speakers as @speakers" do
      Speaker.stub(:all) { [mock_speaker] }
      get :index
      assigns(:speakers).should eq([mock_speaker])
    end
  end

  describe "GET show" do
    it "assigns the requested speaker as @speaker" do
      Speaker.stub(:find).with("37") { mock_speaker }
      get :show, :id => "37"
      assigns(:speaker).should be(mock_speaker)
    end
  end

  describe "GET new" do
    it "assigns a new speaker as @speaker" do
      Speaker.stub(:new) { mock_speaker }
      get :new
      assigns(:speaker).should be(mock_speaker)
    end
  end

  describe "GET edit" do
    it "assigns the requested speaker as @speaker" do
      Speaker.stub(:find).with("37") { mock_speaker }
      get :edit, :id => "37"
      assigns(:speaker).should be(mock_speaker)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created speaker as @speaker" do
        Speaker.stub(:new).with({'these' => 'params'}) { mock_speaker(:save => true) }
        post :create, :speaker => {'these' => 'params'}
        assigns(:speaker).should be(mock_speaker)
      end

      it "redirects to the created speaker" do
        Speaker.stub(:new) { mock_speaker(:save => true) }
        post :create, :speaker => {}
        response.should redirect_to(admin_speaker_url(mock_speaker))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved speaker as @speaker" do
        Speaker.stub(:new).with({'these' => 'params'}) { mock_speaker(:save => false) }
        post :create, :speaker => {'these' => 'params'}
        assigns(:speaker).should be(mock_speaker)
      end

      it "re-renders the 'new' template" do
        Speaker.stub(:new) { mock_speaker(:save => false) }
        post :create, :speaker => {}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested speaker" do
        Speaker.should_receive(:find).with("37") { mock_speaker }
        mock_speaker.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :speaker => {'these' => 'params'}
      end

      it "assigns the requested speaker as @speaker" do
        Speaker.stub(:find) { mock_speaker(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:speaker).should be(mock_speaker)
      end

      it "redirects to the speaker" do
        Speaker.stub(:find) { mock_speaker(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(admin_speaker_url(mock_speaker))
      end
    end

    describe "with invalid params" do
      it "assigns the speaker as @speaker" do
        Speaker.stub(:find) { mock_speaker(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:speaker).should be(mock_speaker)
      end

      it "re-renders the 'edit' template" do
        Speaker.stub(:find) { mock_speaker(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested speaker" do
      Speaker.should_receive(:find).with("37") { mock_speaker }
      mock_speaker.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the speakers list" do
      Speaker.stub(:find) { mock_speaker }
      delete :destroy, :id => "1"
      response.should redirect_to(admin_speakers_url)
    end
  end

  describe "unauthenticated users get redirected when" do
    before do
      sign_out user
    end

    it "GET index" do
      get :index
      response.should be_redirect
    end

    it "GET show" do
      get :show, :id => "37"
      response.should be_redirect
    end
    
    it "GET new" do
      get :new
      response.should be_redirect
    end

    it "GET edit" do
      get :edit, :id => "37"
      response.should be_redirect
    end

    it "POST create" do
      post :create
      response.should be_redirect
    end

    it "PUT update" do
      put :update, :id => "37"
      response.should be_redirect
    end

    it "DELETE destroy" do
      delete :destroy, :id => "37"
      response.should be_redirect
    end
  end

end
