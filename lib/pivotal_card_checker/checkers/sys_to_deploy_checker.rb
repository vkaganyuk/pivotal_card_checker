
class SystemsToDeployChecker < SysLabelChecker
  def find_systems_to_deploy
    systems_to_deploy = Hash.new {}
    @all_stories.each do |story_id, story|
      next unless has_label?(story_id, 'to_prod') &&
                  (story.current_state == 'finished' ||
                  story.current_state == 'delivered')
      sys_label = check_labels(story_id)
      unless sys_label == 'not found'
        systems_to_deploy[sys_label] = [] if systems_to_deploy[sys_label].nil?
        systems_to_deploy[sys_label].push(story)
      end
    end
    return systems_to_deploy
  end
end

















