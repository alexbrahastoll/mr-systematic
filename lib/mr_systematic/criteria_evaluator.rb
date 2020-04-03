class MrSystematic::CriteriaEvaluator
  attr_reader :bibtex, :in_ex_criteria

  ALL_PLACEHOLDER = 'all'.freeze

  def initialize(bibtex, data)
    @bibtex = bibtex
    @in_ex_criteria = data.fetch(:in_ex_criteria)
  end

  def do_in_ex_evaluation
    included_studies = []
    excluded_studies = []

    bibtex.each do |entry|
      study = entry.to_h.merge
      study[:inclusion_criteria] = replace_placeholders(study[:mrs_inclusion_criteria])
      study[:exclusion_criteria] = replace_placeholders(study[:mrs_exclusion_criteria])

      if study[:exclusion_criteria] != nil
        study[:in_ex_result] = 'Excluded'
        excluded_studies << study
      else
        study[:in_ex_result] = 'Included'
        included_studies << study
      end
    end

    {
      included_studies: included_studies,
      excluded_studies: excluded_studies
    }
  end

  private

  def replace_placeholders(raw_in_criteria)
    if raw_in_criteria == ALL_PLACEHOLDER
      in_ex_criteria[:inclusion].keys.join(', ')
    else
      raw_in_criteria
    end
  end
end
