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

    WITH mx AS (SELECT MAX(id) AS id FROM public.#{table})
    SELECT setval('public.#{table}_id_seq', mx.id) AS curseq
    FROM mx;

    SQL
  end , "importing #{table}.csv"
end

Reader.where(:password_digest => nil).each(&:make_temporary_password!)

#for heroku:
#$ PGPASSWORD=PWHERE psql -h HOSTHERE -U USERHERE DBNAMEHERE -c "\copy my_things FROM 'my_data.csv' WITH CSV;"