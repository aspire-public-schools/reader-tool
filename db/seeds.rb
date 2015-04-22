def with_log msg=nil
  Rails.logger.info "#{msg}..." if msg
  yield
  Rails.logger.info "#{msg} done!" if msg
end

[ Reader, Domain, Indicator ].each do |klass|
  with_log("importing #{klass.table_name}.csv") do
    klass.truncate!
    klass.pg_copy_from Rails.root.join("db","seeds",klass.table_name+".csv").to_s
    klass.pg_update_sequence!
  end
end

Reader.where(:password_digest => nil).each(&:make_temporary_password!)