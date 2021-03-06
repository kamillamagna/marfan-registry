class Hospitalization < ApplicationRecord
  include ApplicationHelper
  mount_uploader :attachment, AttachmentUploader

  attr_reader :table_headings,
              :table_body
  attr_accessor :time_ago_scale,
                :time_ago_amount,
                :duration_amount,
                :duration_scale,
                :absolute_start_date

  belongs_to :topic,
             required: true
  belongs_to :patient,
             inverse_of: :hospitalizations

  validates :visit_id,
            numericality: {
              only_integer: true,
              greater_than: 0
            },
            allow_nil: true

  def self.attributes
    %i[visit_id patient_id topic_id present hospitalization admission_date time_ago time_ago_scale length_of_stay length_of_stay_scale hosp_type description location note attachment]
  end

  def self.table_headings
    return ['Date', 'Length of Stay', 'Name', 'Location', 'Description', 'Attachments', 'Actions']
  end

  def table_body
    action_view = ActionView::Base.new(Rails.configuration.paths["app/views"])
    action_view.class_eval do
      include Rails.application.routes.url_helpers
      include ApplicationHelper

      def protect_against_forgery?
        false
      end
    end

    {
      'date': (self.admission_date ? self.admission_date.strftime('%B %Y') : 'not noted'),
      'length_of_stay': print_if_present(self.length_of_stay),
      'name': print_if_present(self.hosp_type),
      'location': print_if_present(self.location),
      'description': print_if_present(self.description),
      'attachment': action_view.render(
        partial: 'layouts/attachment_thumbnails',
        format: :txt,
        locals: { model: self }
      ).to_s.html_safe,
      'actions': action_view.render(
        partial: 'hospitalizations/link_buttons',
        format: :txt,
        locals: { h: self }
      ).to_s.html_safe
    }
  end

  def length_of_stay
  end

  def generate_summary
    if note
      "#{topic.name} (#{note})"
    else
      "#{topic.name} procedure"
    end
  end

  def generate_full_summary
    summ = ""
    admission_date? ? (summ << "hospitalized on #{admission_date.strftime('%d %B %Y')}") : nil
    (length_of_stay && length_of_stay_scale) ? "for #{length_of_stay} #{length_of_stay_scale}" : nil
    summ << "for #{topic.name}"
    location? ? (summ << "at #{location}") : nil
  end
end
