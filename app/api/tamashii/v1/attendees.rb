# frozen_string_literal: true

module Tamashii
  module V1
    # :nodoc:
    class Attendees < Grape::API
      resources :attendees do
        desc 'Get attendees summary'
        get '/summary' do
          attendees = Event.find(params[:event_id]).attendees
          # TODO: Why this is "NOT CHECKED INT" called "CHECKIN"
          {
            attendees: attendees.count,
            checkin: attendees.not_checked_in.count
          }
        end
      end
    end
  end
end
