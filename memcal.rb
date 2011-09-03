require 'ri_cal'
require 'active_support/all'
require 'open-uri'

class MemCal
  # Provides a Calendar, EventHelper, and Occurrence.
  # These three together wrap up a google calendar and extrapolate
  # its events for the next month.  Provides a simple hashmap of these
  # events suitable for JSON rendering.
  
  CALENDAR_URL = 'https://www.google.com/calendar/ical/fqog3035hqhjvo48sqerb3ki9c%40group.calendar.google.com/public/basic.ics'

  class Calendar
    attr_accessor :events

    def initialize
      cals = RiCal.parse_string open(MemCal::CALENDAR_URL).read
      cal = cals.first
      @events =  cal.events.map{ |ev| MemCal::EventHelper.new(ev)}
    end

    def simple
      val = @events.map{ |ev| ev.occurrences }
      val = val.reduce { |all, one| all.concat(one) }
      val.sort!
      val.map { |occ| occ.simple }
    end

  end

  class EventHelper
    # Converts a RiCal event to a MemCal event.
    # Provides a list of Memcal::Occurence with a simple representation.

    attr_accessor :summary, :occurrences

    def initialize(event)
      @event = event
      @summary = @event.summary
      occurrences = @event.occurrences({ overlapping:  [Time.now, 1.month.from_now] })

      @occurrences = occurrences.map { |occ| MemCal::Occurrence.new(occ, @summary) }
    end

    def simple
      {
        name: @summary,
        simple: @occurrences.map { |occ| occ.simple }
      }
    end

  end

  class Occurrence
    attr_accessor :start, :stop, :location, :simple, :source, :summary

    def initialize(occurrence, summary)
      @source   = occurrence
      @summary  = summary
      @start    = @source.dtstart
      @location = @source.location
      @stop     = @source.dtend
    end

    def <=>(another_occurrence)
      return -1 if self.start < another_occurrence.start
      return 1  if self.start > another_occurrence.start
      return 0
    end

    def to_s
      simple.to_s
    end

    def simple
      {
        name:     @summary,
        start:    @start,
        stop:     @stop,
        location: @location
      }
    end

  end

end
