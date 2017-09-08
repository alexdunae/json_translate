module JSONTranslate
  module Translates
    module ActiveRecordWithJSONTranslate
      def respond_to?(symbol, include_all = false)
        return true if parse_translated_attribute_accessor(symbol)
        super(symbol, include_all)
      end

      def method_missing(method_name, *args)
        translated_attr_name, locale, suffix = parse_translated_attribute_accessor(method_name)

        return super(method_name, *args) unless translated_attr_name

        case suffix
        when '='
          write_json_translation(translated_attr_name, args.first, locale)
        when '?'
          query_json_translation(translated_attr_name, locale)
        else
          read_json_translation(translated_attr_name, locale)
        end
      end
    end
  end
end
