module PivotalCardChecker
  # Organizes the violations into a map of owner names -> card violations.
  class ViolationsOrganizer
    PROD_INFO_INDEX = 0
    SYS_LABEL_INDEX = 1
    ACCEPTANCE_CRIT_INDEX = 2
    OTHER_ISSUES_INDEX = 3
    UNASSIGNED_CARDS_INDEX = 4

    def initialize
      @bad_card_info = Hash.new { |hash, key| hash[key] = CardViolationsManager.new }
    end

    # Sends the cards to be processed, by type, then returns the resulting
    # info (@bad_card_info).
    def organize(results)
      [[PROD_INFO_ISSUE, results[PROD_INFO_INDEX]],
       [SYS_LABEL_ISSUE, results[SYS_LABEL_INDEX]],
       [ACCEPTANCE_CRIT_ISSUE, results[ACCEPTANCE_CRIT_INDEX]],
       [OTHER_ISSUE, results[OTHER_ISSUES_INDEX]],
       [UNASSIGNED_CARDS_ISSUE, results[UNASSIGNED_CARDS_INDEX]]].each do |type, violations|
        process_list(type, violations)
      end

      @bad_card_info
    end

    # Goes through the list of cards and places them into a Hash, which maps the
    # owner name(s) to a CardViolationsManager object.
    def process_list(type, list)
      unless list.nil?
        list.each do |story_card, message|
          card_owners = get_owners(story_card.owners)
          @bad_card_info[card_owners].add_violation(type, story_card, message)
        end
      end
    end

    # Returns a comma seperated list of all the story's owners. If a card has no
    # owners, then this method will return 'NOBODY??!?!'.
    def get_owners(owners)
      return 'NOBODY??!?!' if owners.empty?

      owner_names = []
      owners.each do |person|
        owner_names << person.name
      end

      owner_names.join(', ')
    end
  end
end
