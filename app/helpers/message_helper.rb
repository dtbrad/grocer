module MessageHelper
  def wipe_cc(body_field)
    cc_field = cc_field(body_field)
    body_field.gsub!(cc_field, "CREDIT CARD INFO REMOVED") if cc_field
  end

  def cc_field(body_field)
    rows = extract_text_rows(body_field)
    loc = rows.find_index { |i| i [/^(Total|TOTAL)$/] }
    rows[loc + 2].delete("")
  end

  def tax(body_field)
    rows = extract_text_rows(body_field)
    loc = rows.find_index { |i| i [/^(Tax|TAX)$/] }
    rows[loc + 1]
  end

  def total_string(body_field)
    rows = extract_text_rows(body_field)
    loc = rows.find_index { |i| i [/^(Total|TOTAL)$/] }
    rows[loc + 1]
  end

  def transaction_date_string(body_field)
    rows = extract_text_rows(body_field)
    loc = rows.find_index { |i| i == "Transaction Date" }
    rows[loc + 1]
  end

  def extract_text_rows(body_field)
    Nokogiri::HTML(body_field).search('//text()').map(&:text).delete_if { |x| x !~ /\w/ }.collect(&:squish)
  end

  def extract_email(value)
    value.scan(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i).first
  end

  def extract_urls(value)
    value.scan(%r{https:+\/\/\S+})
  end
end
