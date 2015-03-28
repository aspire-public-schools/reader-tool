def execute sql, msg=nil
  sql = sql.read if sql.is_a? Pathname
  Rails.logger.info "#{msg}..." if msg
  ActiveRecord::Base.connection.execute sql
  Rails.logger.info "#{msg} done!" if msg
end

%w[ readers domains indicators ].each do |table|
  execute begin
    <<-SQL
    TRUNCATE table #{table};
    COPY #{table} FROM '#{Rails.root.join("db","seeds",table+".csv")}'
      DELIMITER ',' CSV HEADER;
    SQL
  end , "importing #{table}.csv"
end
