class Product < ApplicationRecord
  require "roo"

  class << self
    def import(file)
      export_columns = {}
      spreadsheet = Roo::Spreadsheet.open(file.path, extension: :xlsx)
      header = spreadsheet.row(1)
      header.each_with_index do |cell, index|
        cell = cell.split(/\s+/).join(" ").strip
        if APP_CONFIG["columns"].values.include?(cell)
          key = APP_CONFIG["columns"].key(cell)
          export_columns.merge!({ index => cell })
        end
      end

      tmp_sheet = []
      tmp_row = []
      export_keys = export_columns.keys
      last_index = export_keys.length - 1

      (2..spreadsheet.last_row).each do |i|
        previous_row = spreadsheet.row(i - 1) if i > 2
        current_row = spreadsheet.row(i)
        next unless current_row.any?

        if current_row.first == previous_row.first
          tmp_row[last_index] = current_row.last.to_i + previous_row.last.to_i
        else
          tmp_sheet.push(tmp_row) if tmp_row.any?
          tmp_row = []
          current_row.each_with_index do |cell, index|
            next unless export_keys.include?(index)
            tmp_row.push(cell)
          end
        end
      end

      xlsx = Roo::Excelx.new(Rails.root.join("app", "assets", "excel", "test.xlsx"), file_warning: :ignore)
      xlsx.each_row_streaming do |row|
        puts row.inspect
      end
    end

  end

  class String
    def underscore
     self.gsub(/::/, "/").
     gsub(/([A-Z]+)([A-Z][a-z])/,"\1_\2").
     gsub(/([a-z\d])([A-Z])/,"\1_\2").
     tr(" ", "_").
     downcase
    end
  end
end


      # (2..spreadsheet.last_row).each do |i|
      #   row = Hash[[header, spreadsheet.row(i)].transpose]
      #   product = find_by(id: row["id"]) || new
      #   product.attributes = row.to_hash
      #   product.save!
      # end
