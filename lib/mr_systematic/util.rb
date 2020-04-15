class MrSystematic::Util
  def self.filter_bibtex(processed_path, to_be_filtered_path)
    processed = BibTeX.open(processed_path).data.map { |e| [e.title.to_s.gsub(/\s+/, ' ').downcase, e] }.to_h
    filtered = BibTeX.open(to_be_filtered_path).data.map { |e| [e.title.to_s.gsub(/\s+/, ' ').downcase, e] }.to_h
    filtered.delete_if { |title, entry| processed[title] }

    novel = BibTeX::Bibliography.new
    novel.add(*(filtered.values))
    novel.save_to("#{to_be_filtered_path[0..-5]}_filtered.bib") # Removes .bib before using the original filename
  end
end
