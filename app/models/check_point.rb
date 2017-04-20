# frozen_string_literal: true
# missing top-level class documentation comment
class CheckPoint < ApplicationRecord
  self.inheritance_column = :_type

  has_many :check_records
  belongs_to :event
  belongs_to :machine

  validates :name, presence: true
  validate :machine_available

  def checkin(attendee_id)
    @record = CheckRecord.where(attendee_id: attendee_id, check_point_id: id)
    if @record.blank?
      CheckRecord.create(attendee_id: attendee_id, check_point_id: id)
    else
      in_time_range?(attendee_id)
    end
  end

  def machine_available
    return unless machine.events.overlap(event.peroid).any?
    errors.add(:machine, '這時間已經有人使用此機器')
  end

  private

  def in_time_range?(attendee_id)
    last_record = @record.last
    time_range = (-DateTime::Infinity.new.to_f..5.days.ago.to_f)

    if time_range.include?(last_record.updated_at.to_f)
      CheckRecord.create(attendee_id: attendee_id, check_point_id: id)
    else
      last_record.increment
    end
  end
end
