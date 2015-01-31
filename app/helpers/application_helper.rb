module ApplicationHelper
  def edit_reader_list
    sql = "SELECT onea.employee_id_observer, onea.id AS document_observation_read_id, onea.observation_status AS document_status, onea.reader_id AS Document_reader_id, oneb.id AS live_observation_read_id, oneb.observation_status AS live_status, oneb.reader_id AS Live_reader_id, two.id AS second_observation_read_id, two.reader_id AS second_reader_id, two.observation_status AS second_status, onea.flags AS onea_flags, oneb.flags AS oneb_flags, two.flags AS two_flags
    FROM observation_reads onea
    JOIN observation_reads oneb
    ON oneb.reader_number = '1b' AND onea.observation_group_id = oneb.observation_group_id
    JOIN observation_reads two
    ON two.reader_number = '2' AND onea.observation_group_id = two.observation_group_id
    WHERE onea.reader_number = '1a'
    ORDER BY onea.employee_id_observer"
    edit_reader_list = ObservationRead.find_by_sql(sql)
  end

  def bootstrap_class_for(error)
    case error
    when :success
      "alert-success"
    when :error
      "alert-error"
    when :alert
      "alert-block"
    when :notice
      "alert-info"
    else
      flash_type.to_s
    end
  end

end
