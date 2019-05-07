class MrSystematic::Parser
  attr_reader :bibtex_path, :bibtex

  OUT_DIR_PATH = 'out'

  def initialize(bibtex_path)
    @bibtex_path = bibtex_path
    @bibtex = BibTeX.open(bibtex_path)
  end

  def render(template_name, output_filename, template_data = {})
    evaluator = MrSystematic::CriteriaEvaluator.new(bibtex, template_data)
    template_data.merge!(evaluator.do_in_ex_evaluation)

    template_contents = File.read("lib/mr_systematic/templates/#{template_name}.tex.erb").gsub(/^ +/, '')
    erb = ERB.new(template_contents, trim_mode: '<>')
    rendered = erb.result_with_hash({ bibtex: bibtex, data: template_data })

    FileUtils.mkdir_p(OUT_DIR_PATH)
    output_path = "#{OUT_DIR_PATH}/#{output_filename}.tex"
    File.open(output_path, 'w') do |f|
      f.write(rendered)
    end
    true
  end
end
