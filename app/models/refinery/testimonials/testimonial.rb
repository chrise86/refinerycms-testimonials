module Refinery
  module Testimonials
    class Testimonial < Refinery::Core::BaseModel
      self.table_name = "refinery_testimonials"

      # Constants for how to show the testimonials
      ORDER = %w[Random Recent]
      CHANNELS = %w[Letter Email Facebook Twitter Website]

      CHANNELS.each_with_index do |meth, index|
        define_method("#{meth}?") { channels == index }
      end

      acts_as_indexed :fields => [:name, :company]

      validates :name, presence: true, unless: :via_letter? #, :uniqueness => true
      validates :quote, presence: true
      validates :email, presence: true, if: :via_website?

      scope :random, -> limit { where('id >= ?', rand(count)).limit(limit) }
      scope :approved, -> { where(approved: true) }

      def flash_name
        "Quote by #{self.name}"
      end

      private

      def via_website?
        received_channel == 'Website'
      end

      def via_letter?
        received_channel == 'Letter'
      end
    end
  end
end
