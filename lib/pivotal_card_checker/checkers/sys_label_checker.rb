module PivotalCardChecker
  module Checkers
    # Verifies the cards to see if any of them are either missing a system
    # label(s) or have an incorrect system label(s).
    class SysLabelChecker < Checker

      # Loops through all of the stories, and checks the candidate cards for
      # any violations.
      def check
        @all_story_cards.each do |story_card|
          next unless is_candidate?(story_card)
          sys_labels_on_story = find_system_labels_on_story(story_card.labels)
          sys_label_violation_check(story_card, sys_labels_on_story)
        end
        @results
      end

      # Returns an array of system labels that were found on the story card.
      def find_system_labels_on_story(labels)
        sys_labels = Set.new
        unless labels.nil?
          labels.each do |label|
            sys_labels << label.name if ALL_SYSTEM_LABELS.include? label.name
          end
        end
        sys_labels.to_a
      end

      # Checks given cards for violations, and adds any violators to the
      # @results Hash.
      def sys_label_violation_check(story_card, sys_labels_on_story)
        sys_labels_from_comments = get_system_label_from_commit(story_card.comments)
        if sys_labels_on_story.empty?
          if sys_labels_from_comments.empty?
            @results[story_card] = 'No system labels detected (reader, cms, dct, etc...)'
          else
            @results[story_card] = "Did not find expected label(s): '#{sys_labels_from_comments.join('\', \'')}'"
          end
        elsif !sys_labels_from_comments.empty?
          sys_labels_from_comments.each do |sys_label|
            unless has_label?(story_card.labels, sys_label)
              @results[story_card] = "Expected label(s): '#{sys_labels_from_comments.join('\', \'')}', but found: '#{sys_labels_on_story.join('\', \'')}' instead."
              break
            end
          end
        end
      end
    end
  end
end
