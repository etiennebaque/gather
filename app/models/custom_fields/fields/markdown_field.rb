module CustomFields
  module Fields
    class MarkdownField < TextField
      def input_type
        :markdown
      end
    end
  end
end
