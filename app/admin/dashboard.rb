ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do


  columns do

    column do
      panel "Recent Observation Reads" do
        table_for ObservationRead.order('updated_at desc').limit(10) do
          column('State') {|observation_read| observation_read.observation_status }
          column('Reader') {|observation_read| observation_read.reader.full_name }
          column('Observation Group') {|observation_read| observation_read.observation_group_id }
          column('Employee ID') {|observation_read| observation_read.employee_id_observer}
          column('Last Updated') {|observation_read| observation_read.updated_at }
        end
      end
    end

    column do
      panel "Readers" do
        table_for Reader.order('email asc') do
          column("Current Readers") {|reader| link_to(reader.email, admin_reader_path(reader.id)) }
        end
      end
    end

  end

    columns do
      column do
          panel "This is where a Chart can go" do
            div do
              "chart here"
            end
          end
      end
    end

  end
end
