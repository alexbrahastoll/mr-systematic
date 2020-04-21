class MrSystematic::Util
  def self.filter_bibtex(processed_path, to_be_filtered_path)
    processed = BibTeX.open(processed_path).data.map { |e| [e.title.to_s.gsub(/\s+/, ' ').downcase, e] }.to_h
    filtered = BibTeX.open(to_be_filtered_path).data.map { |e| [e.title.to_s.gsub(/\s+/, ' ').downcase, e] }.to_h
    filtered.delete_if { |title, entry| processed[title] }

    novel = BibTeX::Bibliography.new
    novel.add(*(filtered.values))
    novel.save_to("#{to_be_filtered_path[0..-5]}_filtered.bib") # Removes .bib before using the original filename
  end

  def self.classify_known_bibtex_entries(processed_paths, to_be_enhanced_path)
    processed_bibs =
      processed_paths.map do |p|
        BibTeX.open(p).data.map { |e| [e.title.to_s.gsub(/\s+/, ' ').downcase, e] }.to_h
      end
    to_be_enhanced_bib = BibTeX.open(to_be_enhanced_path).data.map { |e| [e.title.to_s.gsub(/\s+/, ' ').downcase, e] }.to_h

    entries = {}
    to_be_enhanced_bib.each do |title, entry|
      bib_containing_entry = processed_bibs.find { |pb_entries| pb_entries[title] }
      bib_containing_entry.nil? ? entries[title] = entry : entries[title] = bib_containing_entry[title]
    end

    novel = BibTeX::Bibliography.new
    novel.add(*(entries.values))
    novel.save_to("#{to_be_enhanced_path[0..-5]}_enhanced.bib") # Removes .bib before using the original filename
  end
end
