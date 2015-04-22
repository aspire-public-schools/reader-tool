module Truncate
  def truncate!
    connection.execute "TRUNCATE TABLE #{table_name};"
  end

  def pg_update_sequence!
    connection.execute <<-SQL.squish
      WITH mx AS (SELECT MAX(id) AS id FROM public.#{table_name})
      SELECT setval('public.#{table_name}_id_seq', mx.id) AS curseq
      FROM mx;
    SQL
  end

end


ActiveRecord::Base.send :extend, Truncate