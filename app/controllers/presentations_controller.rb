class PresentationsController < ApplicationController
  def index
    respond_to do |format|
      format.html do
        @presentations = Presentation.released.order(:created_at.desc).paginate(
          :page => params[:page], :per_page => (params[:per_page] || 10),
          :include => [:speakers, :videos, :event, :tags]
        )
      end
      format.rss do
        redirect_to(
          presentations_url(:format => :atom), :status => :moved_permanently
        )
      end
      format.atom do
        @presentations = Presentation.released.order(:created_at.desc)
        render 'shared/feed', :locals => {
          :feed_title => 'Most Recently Added Presentations - Confed',
          :feed_updated_at => @presentations.first.created_at,
          :presentations => @presentations
        }
      end
    end
  end

  def show
    event = Event.find(params[:event_id])
    @presentation = event.presentations.released.
      order(:created_at.desc).find(params[:id])
  end
end
