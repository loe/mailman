module Mailman
  class Route
    class StringMatcher < Matcher

      attr_reader :keys

      def initialize(pattern)
        super
        compile!
      end

      def match(string)
        params = {}
        if match = @pattern.match(string)
          captures = match.captures
          params.merge!(Hash[*@keys.zip(captures).flatten])
          [params, captures]
        end
      end

      private

      def compile!
        @keys = []
        special_chars = %w/* . + ? \\ | ^ $ ( ) [ ] { } /
        compiled_pattern = @pattern.to_s.gsub(/((%[A-Za-z_]+%)|[\*\\.+?|^$()\[\]{}])/) do |match|
          case match
          when *special_chars
            Regexp.escape(match)
          else
            @keys << $2[1..-2].to_sym
            '(.*)'
          end
        end
        @pattern = /#{compiled_pattern}/i
      end

    end
  end
end
