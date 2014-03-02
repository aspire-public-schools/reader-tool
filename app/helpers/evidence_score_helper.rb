 module EvidenceScoreHelper

  def get_evidence_scores(obs_read_id, ind_code)
     sql = "SELECT evds.*, inds.*
      FROM evidence_scores evds
      LEFT JOIN indicator_scores inds
           ON evds.indicator_score_id = inds.id
      LEFT JOIN domain_scores doms
           ON inds.domain_score_id = doms.id
      LEFT JOIN observation_reads obsr
           ON doms.observation_read_id = obsr.id
      LEFT JOIN indicators ind
      ON inds.indicator_id = ind.id

      WHERE
      observation_read_id = '#{obs_read_id}''
      AND ind.code = '#{ind_code}'
      ORDER BY obsr.id, ind.code"

      @evidence_scores = EvidenceScore.find_by_sql(sql)
  end
end


