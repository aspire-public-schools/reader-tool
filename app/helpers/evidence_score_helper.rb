module EvidenceScoreHelper

  def get_percentages(observation_id)
    sql = "SELECT obr.id, dom.number,AVG(evds.quality::integer) AS quality_average,  AVG(evds.alignment::integer) AS alignment_average
    FROM observation_reads obr
      LEFT JOIN domain_scores doms
          ON doms.observation_read_id = obr.id
      LEFT JOIN domains dom
          ON doms.domain_id = dom.id
      LEFT JOIN indicator_scores inds
          ON inds.domain_score_id = doms.id
      LEFT JOIN evidence_scores evds
          ON evds.indicator_score_id = inds.id
      WHERE obr.id = #{observation_id}
      GROUP BY obr.id, dom.number"
      @observation_scores = ObservationRead.find_by_sql(sql)
  end

  def percent_of(n)
    self.to_f / n.to_f * 100.0
  end

end


