# frozen_string_literal: true

# Formats a collection of row hashes as a fixed-width, aligned plain-text table
# for command-line / rake output. The keys of the first row become the column
# headers (in order); each row is read by those keys and its values stringified.
# Columns are padded to the width of their widest value (header included).
#
#   CommandLineTableFormatter.new(
#     [{ "ID" => 1, "Status" => "active" },
#      { "ID" => 42, "Status" => "ceased" }]
#   ).render
#   # =>
#   # ID  Status
#   # --  ------
#   # 1   active
#   # 42  ceased
#
# A single hash is accepted and treated as a one-row table. An empty collection
# renders as an empty string.
class CommandLineTableFormatter
  COLUMN_GAP = "  "

  def initialize(rows)
    @rows = rows.is_a?(Hash) ? [rows] : rows.to_a
  end

  def render
    return "" if @rows.empty?

    ([format_row(headers), format_row(dashes)] + data_rows).join("\n")
  end

  private

  def keys
    @keys ||= @rows.first.keys
  end

  def headers
    keys.map(&:to_s)
  end

  def data_rows
    @rows.map { |row| format_row(keys.map { |key| row[key].to_s }) }
  end

  def dashes
    widths.map { |width| "-" * width }
  end

  def widths
    @widths ||= keys.map { |key| ([key.to_s] + @rows.map { |row| row[key].to_s }).map(&:length).max }
  end

  def format_row(cells)
    cells.each_with_index.map { |cell, index| cell.ljust(widths[index]) }.join(COLUMN_GAP).rstrip
  end
end
