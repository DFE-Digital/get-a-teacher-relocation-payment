# frozen_string_literal: true

module Reports
  class HomeOffice < Base
    file_ext "xlsx"

    HEADER_MAPPINGS_KEY = "header_mappings"
    WORKSHEET_NAME_KEY = "worksheet_name"

    def generate
      cell_coords.each { worksheet.add_cell(*_1) }
      workbook.stream.string
    end

    def post_generation_hook
      base_query.update_all(home_office_csv_downloaded_at: Time.zone.now) # rubocop:disable Rails/SkipsModelValidations
    end

  private

    def workbook
      @workbook ||= ::RubyXL::Parser.parse_buffer(template.file)
    end

    def template
      @template ||= ReportTemplate.find_by!(report_class: self.class.name)
    end

    def worksheet
      @worksheet ||= workbook[worksheet_name]
    end

    def worksheet_name
      template.config.fetch(WORKSHEET_NAME_KEY)
    end

    def header_mappings
      template.config.fetch(HEADER_MAPPINGS_KEY)
    end

    def headers_with_column_index
      @headers_with_column_index ||= worksheet[0]
        .cells
        .each
        .with_index
        .map { |v, i| [v.value, i] }
    end

    def sheet_col_number(header_mapping)
      _, col_number = headers_with_column_index.detect { |(header, _)| header == header_mapping }

      col_number
    end

    def cell_coords
      dataset.each.with_index.flat_map do |cols, sheet_row_number|
        header_mappings.each.with_index.map do |(header_mapping, _), col_idx|
          [sheet_row_number + 1, sheet_col_number(header_mapping), cols[col_idx].to_s]
        end
      end
    end

    def base_query
      @base_query ||= Application
        .joins(:application_progress)
        .includes(:applicant)
        .where.not(application_progresses: { initial_checks_completed_at: nil })
        .where(
          application_progresses: {
            home_office_checks_completed_at: nil,
            rejection_completed_at: nil,
          },
          home_office_csv_downloaded_at: nil,
        )
    end

    def dataset
      base_query.pluck(*dataset_fields)
    end

    def dataset_fields
      header_mappings.values.map do |cols|
        if cols.size == 1
          cols.first
        else
          Arel.sql("CONCAT(#{cols.join(', \' \', ')})")
        end
      end
    end
  end
end
