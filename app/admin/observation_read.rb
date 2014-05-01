ActiveAdmin.register ObservationRead do
#setting scopes
  scope :first_read
  scope :second_read
  scope :completed_read

#setting batch actions
  batch_action :flag do |selection|
    ObservationRead.find(selection).each { |p| p.flag! }
    redirect_to collection_path, :notice => "Observation flagged!"
  end

#sets priority of tabs at top
  menu :priority => 1

#customizing filter selections
  filter :reader
  filter :employee_id_observer
  filter :employee_id_learner
  filter :reader_number
  filter :observation_status

#customizing columns
  index do
    selectable_column
    column :id
    column :observation_group_id
    column :employee_id_observer
    column :reader_number
    column :comments
    column :document_quality
    column :document_alignment
    column :live_quality
    column :live_alignment
    column :reader_id, :sortable => :reader_id do |observation_read|
      div :class => "reader" do
        observation_read.reader.full_name
      end
    end
    default_actions
  end


end
