require 'pivotal_card_checker'
require 'tracker_api'
require 'spec_helper'

describe PivotalCardChecker::Checkers::AcceptanceCritChecker do
  attr_accessor :all_stories, :all_labels, :all_comments, :all_owners

  it 'should detect one story that is missing a prod info label' do
    VCR.use_cassette 'acceptance_crit_check_one_violation' do
      @all_stories, @all_labels, @all_comments, @all_owners =
        PivotalCardChecker::DataRetriever.new('using cassette', 414_867).retrieve_data
    end

    result = PivotalCardChecker::Checkers::AcceptanceCritChecker.new([@all_stories, @all_labels,
                                        @all_comments]).check
    expect(result.length).to eql(1)
  end
end