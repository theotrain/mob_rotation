class Database
  def sanitized_entries_in
    dirty_entries = each_database_entry(@filename) do |entry|
      yield entry.to_s.strip
    end
  end

  def initialize(filename)
    @filename = filename
    FileUtils.touch(filename) unless File.exist?(filename)
  end

  def write(names, emails)
    File.open(@filename, 'w') do |file|
      names.zip(emails).each { |name, email| file << format_mobster(name.to_s, email) << "\n" }
    end
  end

  def format_mobster(name, email)
    name + (" <#{email}>" if email && !email.empty?).to_s
  end

  def each_database_entry(filename)
    File.readlines(filename).map do |entry|
      yield entry
    end
  end
end
