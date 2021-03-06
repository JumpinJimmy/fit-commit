require "fit_commit/validators/base"

module FitCommit
  module Validators
    class LineLength < Base
      def validate_line(lineno, text)
        if lineno == 1 && text.empty?
          add_error(lineno, "Subject line cannot be blank.")
        elsif lineno == 2 && !text.empty?
          add_error(lineno, "Second line must be blank.")
        elsif line_too_long?(text)
          add_error(lineno, format("Lines should be <= %i chars. (%i)",
            max_line_length, text.length))
        elsif lineno == 1 && text.length > subject_warn_length
          add_warning(lineno, format("Subject line should be <= %i chars. (%i)",
            subject_warn_length, text.length))
        end
      end

      def line_too_long?(text)
        text.length > max_line_length && !(allow_long_urls? && contains_url?(text))
      end

      def contains_url?(text)
        text =~ %r{[a-z]+://}
      end

      def max_line_length
        config.fetch("MaxLineLength")
      end

      def subject_warn_length
        config.fetch("SubjectWarnLength")
      end

      def allow_long_urls?
        config.fetch("AllowLongUrls")
      end
    end
  end
end
