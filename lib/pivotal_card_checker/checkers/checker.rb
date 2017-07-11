# Documentation
class Checker
  attr_accessor :all_stories, :all_labels, :all_comments, :results

  def initialize(all_stories, all_labels, all_comments)
    @all_stories = all_stories
    @all_labels = all_labels
    @all_comments = all_comments
    @results = Hash.new {}
  end

  def candidate?(story_id, state)
    state == 'finished' || state == 'delivered' || (state == 'accepted' &&
    search_comments(story_id, 'Commit by') != 'not found')
  end

  def get_system_label_from_commit(story_id)
    temp = 'sysLabelUnknown'
    search_result = search_comments(story_id, 'github.com/')

    if search_result != 'not found'
      temp = search_result.split(/github.com\/(.*?)\/(.*?)\/commit/)[2]
      if temp.include? 'hedgeye-'
        temp = temp[8...temp.length]
      end
      temp.tr!('_', ' ')
    end
    result = temp
  end

  def has_label?(story_id, label_looking_for)
    found = false
    unless @all_labels[story_id].nil?
      @all_labels[story_id].each do |label|
        if label.name == label_looking_for
          found = true
          break
        end
      end
    end
    return found
  end

  def search_comments(story_id, search_string)
    temp = 'not found'
    @all_comments[story_id].each do |comment|
      if !comment.text.nil? && (comment.text.downcase.include? search_string)
        temp = comment.text
        break
      end
    end
    return temp
  end
end
