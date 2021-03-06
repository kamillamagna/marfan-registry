class Diagnosis < ApplicationRecord
  include ApplicationHelper
  mount_uploader :attachment, AttachmentUploader

  attr_reader :table_headings,
              :table_body

  attr_accessor :time_ago_amount,
                :time_ago_scale,
                :duration_amount,
                :duration_scale,
                :frequency_amount,
                :frequency_scale,
                :descriptors

  before_create :concat_duration,
                :concat_time_ago,
                :concat_frequency,
                :descriptors_to_note

  belongs_to :topic,
             required: true
  belongs_to :visit,
             inverse_of: :diagnoses,
             required: false
  belongs_to :patient,
             inverse_of: :diagnoses

  def self.attributes
    [:visit_id, :topic_id, :patient_id, :present, :time_ago_amount, :time_ago_scale, :duration_amount, :duration_scale, :frequency_amount, :frequency_scale, :absolute_start_date, :note, :attachment, descriptors: []]
  end

  def self.table_headings
    %w[Date Description Present Note When Duration Frequency Attachment Actions]
  end

  def concat_duration
    self.duration = "for #{duration_amount} #{duration_scale}" unless duration_amount.blank? || duration_scale.blank?
  end

  def concat_time_ago
    if !time_ago_amount.blank? && !time_ago_scale.blank?
      date = find_date(time_ago_amount.to_i, time_ago_scale, DateTime.now)
      self.time_ago = "#{time_ago_amount} #{time_ago_scale} ago"
      self.absolute_start_date = date
    elsif !absolute_start_date.blank?
      self.absolute_start_date = absolute_start_date
    else
      self.absolute_start_date = DateTime.now
    end
  end

  def concat_frequency
    self.frequency = "#{frequency_amount} times per #{frequency_scale}" unless frequency_amount.blank? || frequency_scale.blank?
  end

  def descriptors_to_note
    list = descriptors ? descriptors.join(', ') : nil
    if note.blank?
      self.note = list
    else
      self.note += "; #{list}"
    end
  end

  def table_body
    action_view = ActionView::Base.new(Rails.configuration.paths['app/views'])
    action_view.class_eval do
      include Rails.application.routes.url_helpers
      include ApplicationHelper

      def protect_against_forgery?
        false
      end
    end

    {
      'date': absolute_start_date.strftime('%B %Y'),
      'description': find_trail(topic_id),
      'present': present,
      'note': blank_unless_present(note),
      'when': blank_unless_present(time_ago),
      'duration': blank_unless_present(duration),
      'frequency': blank_unless_present(frequency),
      'attachment': action_view.render(
        partial: 'layouts/attachment_thumbnails', format: :txt,
        locals: { model: self }
      ).to_s.html_safe,
      'actions': action_view.render(
        partial: 'diagnoses/link_buttons', format: :txt,
        locals: { d: self }
      ).to_s.html_safe
    }
  end

  def times
    clause = ''
    clause << " #{time_ago}" unless time_ago.blank?
    clause << " #{duration}" unless duration.blank?
    clause << " #{frequency}" unless frequency.blank?
    clause
  end

  def generate_summary
    ap = present? ? 'presence' : 'absence'
    "#{ap.with_indefinite_article} of #{find_pretty_trail(topic_id)}"
  end

  def generate_full_summary
    generate_summary << times
  end
end
