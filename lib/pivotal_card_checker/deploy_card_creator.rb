
class DeployCardCreator
  DEPLOY_LABEL_ID = 2_506_935
  FORREST_ID = 23_159

  def initialize(api_key, proj_id)
    @api_key = api_key
    @proj_id = proj_id
  end

  def create_deploy_card(systems)
    title = "#{Time.now.strftime('%-m/%-d/%y')} #{systems.keys.join(', ')} deploy"
    card_description = create_card_description(systems)
    card_labels = gather_card_label_ids(systems.keys)
    hedgeye_project = TrackerApi::Client.new(token: @api_key).project(@proj_id)
    hedgeye_project.create_story(name: title,
                                 description: card_description,
                                 story_type: 'Chore',
                                 current_state: 'unstarted',
                                 label_ids: card_labels)
                                 # owner_ids: [FORREST_ID],
                                 # requested_by_id: FORREST_ID)
  end

  def create_card_description(systems)
    card_description = ''
    systems.keys.each do |systems_label|
      card_description << "#{systems_label}\n"
      systems[systems_label].each do |story|
        card_description << "[#{story.name}](https://www.pivotaltracker.com/story/show/#{story.id})\n"
      end
      card_description << "\n"
    end
    card_description
  end

  def gather_card_label_ids(system_labels)
    label_ids_for_deploy_card = [DEPLOY_LABEL_ID]
    SysLabelChecker::ALL_SYSTEM_LABELS.zip(SysLabelChecker::ALL_SYS_LABEL_IDS).each do |name, id|
      label_ids_for_deploy_card.push(id) if system_labels.include? name
    end
    label_ids_for_deploy_card
  end
end
