class Presentation < ActiveRecord::Base
  # Callbacks
  before_save :render_description
  before_save :update_search_cache

  # Attributes
  attr_protected :tag_cache

  # Extensions
  acts_as_taggable

  has_friendly_id :title, :use_slug => true, 
                          :scope => :event, 
                          :approximate_ascii => true
  
  define_completeness_scoring do
    check :title, lambda { |per| per.title.present? }, :high
    check :description, lambda { |per| per.description.present? }, :medium
    check :took_place_on, lambda { |per| per.took_place_on.present? }, :low
    check :videos, lambda { |per| per.videos.present? }, :high
    check :slideshows, lambda { |per| per.slideshows.present? }, :medium
  end
  
  # Full Text Searching
  index do
    title         'A'
    speaker_cache 'B'
    event_cache   'C'
    tag_cache     'D'
    description
  end

  # Associations
  belongs_to :event
  has_and_belongs_to_many :speakers
  has_many :videos
  accepts_nested_attributes_for :videos,     :reject_if => :all_blank
  has_many :slideshows
  accepts_nested_attributes_for :slideshows, :reject_if => :all_blank
  has_many :saved_presentations

  # Scopes
  scope :released, :conditions => { :released => true }
  scope :unreleased, :conditions => { :released => false }

  # Validations
  validates :title,      :presence => true
  validates :event_id,   :presence => true, :numericality => true

  # Logic
  def build_extras
    speakers.build unless speakers.present?
    videos.build unless videos.present?
    slideshows.build unless slideshows.present?
  end

  def queued_by?(user)
    saved_presentations.exists?(:user_id => user.id)
  end

  def set_short_url(url)
    bitly = Bitly.new(AppConfig.bitly.user, AppConfig.bitly.api_key)
    short_url = bitly.shorten(url).try(:short_url)
    self.update_attributes :short_url => short_url
    short_url
  rescue BitlyError => e
    logger.error "[Bitly]: #{e}"
    url
  end

  def thumbnail
    return "" unless videos.present? && videos.first.thumbnail.present?  
    videos.first.thumbnail
  end

  def unreleased?
    !released?
  end

  private
    def build_speaker_cache
      cache_array = []
      speakers.each do |speaker|
        cache_array << speaker.name
      end
      cache_array.reverse.join(', ').downcase
    end

    def render_description
      return unless description?
      self.rendered_description = RDiscount.new(
        description, :smart, :filter_html, :autolink
      ).to_html
    end

    def update_search_cache
      self.tag_cache = self.tag_list.to_s
      self.event_cache = event.name
      self.speaker_cache = build_speaker_cache
    end
end
