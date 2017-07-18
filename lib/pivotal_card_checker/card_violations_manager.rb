module PivotalCardChecker
  class CardViolationsManager
    attr_reader :missing_prod_label, :missing_sys_label, :missing_criteria,
                :other_issues

    def initialize
      @missing_prod_label = []
      @missing_sys_label = []
      @missing_criteria = []
      @other_issues = []
    end

    def add_violation(type, story_id, message)
      violation = CardViolation.new(story_id, message)
      case type
      when MISSING_PROD_TYPE
        @missing_prod_label.push(violation)
      when MISSING_SYS_LABEL_TYPE
        @missing_sys_label.push(violation)
      when MISSING_CRITERIA_TYPE
        @missing_criteria.push(violation)
      when OTHER_ISSUE_TYPE
        @other_issues.push(violation)
      else
        puts 'Invalid type.'
      end
    end
  end
end