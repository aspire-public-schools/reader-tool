module Truncate
  def truncate!
    connection.execute "TRUNCATE TABLE #{table_name};"
  end

  def update_sequence!
    connection.execute <<-SQL.squish
      WITH mx AS (SELECT MAX(id) AS id FROM public.#{table})
      SELECT setval('public.#{table}_id_seq', mx.id) AS curseq
      FROM mx;
    SQL
  end

end


ActiveRecord::Base.send :extend, Truncate